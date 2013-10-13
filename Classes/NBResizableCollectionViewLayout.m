//
//  NBResizableCollectionViewLayout.m
//
//  Created by Stan Chang Khin Boon on 1/10/12.
//  Modified by Nathan Borror on 10/12/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBResizableCollectionViewLayout.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define SCROLL_DIRECTION_KEYPATH @"NBScrollingDirection"
#define COLLECTION_VIEW_KEYPATH @"collectionView"

static const CGFloat kFramesPerSecond = 60.0;

CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
  return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

typedef NS_ENUM(NSInteger, NBScrollingDirection) {
  NBScrollingDirectionUnknown = 0,
  NBScrollingDirectionUp,
  NBScrollingDirectionDown,
  NBScrollingDirectionLeft,
  NBScrollingDirectionRight
};


@interface CADisplayLink (userInfo)

@property (nonatomic, copy) NSDictionary *userInfo;

@end


@implementation CADisplayLink (userInfo)

- (void)setUserInfo:(NSDictionary *)userInfo
{
  objc_setAssociatedObject(self, "userInfo", userInfo, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)userInfo {
  return objc_getAssociatedObject(self, "userInfo");
}

@end


@interface UICollectionViewCell (ResizableCollectionViewLayout)

- (UIImage *)rasterizedImage;

@end


@implementation UICollectionViewCell (ResizableCollectionViewLayout)

- (UIImage *)rasterizedImage {
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end


@interface NBResizableCollectionViewLayout ()

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic, readonly) id<NBResizableCollectionViewDataSource> dataSource;
@property (assign, nonatomic, readonly) id<NBResizableCollectionViewDelegateFlowLayout> delegate;

@end

@implementation NBResizableCollectionViewLayout

- (void)setDefaults {
  _scrollingSpeed = 300.0f;
  _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
}

- (void)setupCollectionView {
  _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleLongPressGesture:)];
  _longPressGestureRecognizer.delegate = self;

  // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
  // by enforcing failure dependency so that they doesn't clash.
  for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
      [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
    }
  }

  [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];

  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handlePanGesture:)];
  _panGestureRecognizer.delegate = self;
  [self.collectionView addGestureRecognizer:_panGestureRecognizer];

  // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
}

- (id)init {
  self = [super init];
  if (self) {
    [self setDefaults];
    [self addObserver:self forKeyPath:COLLECTION_VIEW_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setDefaults];
    [self addObserver:self forKeyPath:COLLECTION_VIEW_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
  }
  return self;
}

- (void)dealloc {
  [self invalidatesScrollTimer];
  [self removeObserver:self forKeyPath:COLLECTION_VIEW_KEYPATH];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  if ([layoutAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
    layoutAttributes.hidden = YES;
  }
}

- (id<NBResizableCollectionViewDataSource>)dataSource {
  return (id<NBResizableCollectionViewDataSource>)self.collectionView.dataSource;
}

- (id<NBResizableCollectionViewDelegateFlowLayout>)delegate {
  return (id<NBResizableCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

- (void)invalidateLayoutIfNecessary {
  NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
  NSIndexPath *previousIndexPath = self.selectedItemIndexPath;

  if ((newIndexPath == nil) || [newIndexPath isEqual:previousIndexPath]) {
    return;
  }

  if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)] &&
      ![self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath canMoveToIndexPath:newIndexPath]) {
    return;
  }

  self.selectedItemIndexPath = newIndexPath;

  if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
    [self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath willMoveToIndexPath:newIndexPath];
  }

  __weak typeof(self) weakSelf = self;
  [self.collectionView performBatchUpdates:^{
    __strong typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.collectionView deleteItemsAtIndexPaths:@[ previousIndexPath ]];
      [strongSelf.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];
    }
  } completion:^(BOOL finished) {
    __strong typeof(self) strongSelf = weakSelf;
    if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
      [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:previousIndexPath didMoveToIndexPath:newIndexPath];
    }
  }];
}

- (void)invalidatesScrollTimer {
  if (!self.displayLink.paused) {
    [self.displayLink invalidate];
  }
  self.displayLink = nil;
}

- (void)setupScrollTimerInDirection:(NBScrollingDirection)direction {
  if (!self.displayLink.paused) {
    NBScrollingDirection oldDirection = [self.displayLink.userInfo[SCROLL_DIRECTION_KEYPATH] integerValue];

    if (direction == oldDirection) {
      return;
    }
  }

  [self invalidatesScrollTimer];

  self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
  self.displayLink.userInfo = @{SCROLL_DIRECTION_KEYPATH: @(direction)};

  [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// Tight loop, allocate memory sparely, even if they are stack allocation.
- (void)handleScroll:(CADisplayLink *)displayLink {
  NBScrollingDirection direction = (NBScrollingDirection)[displayLink.userInfo[SCROLL_DIRECTION_KEYPATH] integerValue];
  if (direction == NBScrollingDirectionUnknown) {
    return;
  }

  CGSize frameSize = self.collectionView.bounds.size;
  CGSize contentSize = self.collectionView.contentSize;
  CGPoint contentOffset = self.collectionView.contentOffset;
  CGFloat distance = self.scrollingSpeed / kFramesPerSecond;
  CGPoint translation = CGPointZero;

  switch(direction) {
    case NBScrollingDirectionUp: {
      distance = -distance;
      CGFloat minY = 0.0f;

      if ((contentOffset.y + distance) <= minY) {
        distance = -contentOffset.y;
      }

      translation = CGPointMake(0.0f, distance);
    } break;
    case NBScrollingDirectionDown: {
      CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;

      if ((contentOffset.y + distance) >= maxY) {
        distance = maxY - contentOffset.y;
      }

      translation = CGPointMake(0.0f, distance);
    } break;
    case NBScrollingDirectionLeft: {
      distance = -distance;
      CGFloat minX = 0.0f;

      if ((contentOffset.x + distance) <= minX) {
        distance = -contentOffset.x;
      }

      translation = CGPointMake(distance, 0.0f);
    } break;
    case NBScrollingDirectionRight: {
      CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width;

      if ((contentOffset.x + distance) >= maxX) {
        distance = maxX - contentOffset.x;
      }

      translation = CGPointMake(distance, 0.0f);
    } break;
    default:
      break;
  }

  self.currentViewCenter = CGPointAdd(self.currentViewCenter, translation);
  self.currentView.center = CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
  self.collectionView.contentOffset = CGPointAdd(contentOffset, translation);
}


- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
  switch(gestureRecognizer.state) {
    case UIGestureRecognizerStateBegan: {
      NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];

      if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] && ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
        return;
      }

      self.selectedItemIndexPath = currentIndexPath;

      if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
        [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
      }

      UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];

      self.currentView = [[UIView alloc] initWithFrame:collectionViewCell.frame];

      collectionViewCell.highlighted = YES;
      UIImageView *highlightedImageView = [[UIImageView alloc] initWithImage:[collectionViewCell rasterizedImage]];
      highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      highlightedImageView.alpha = 1.0f;

      collectionViewCell.highlighted = NO;
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[collectionViewCell rasterizedImage]];
      imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      imageView.alpha = 0.0f;

      [self.currentView addSubview:imageView];
      [self.currentView addSubview:highlightedImageView];
      [self.collectionView addSubview:self.currentView];

      self.currentViewCenter = self.currentView.center;

      __weak typeof(self) weakSelf = self;
      [UIView
       animateWithDuration:0.3
       delay:0.0
       options:UIViewAnimationOptionBeginFromCurrentState
       animations:^{
         __strong typeof(self) strongSelf = weakSelf;
         if (strongSelf) {
           strongSelf.currentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
           highlightedImageView.alpha = 0.0f;
           imageView.alpha = 1.0f;
         }
       }
       completion:^(BOOL finished) {
         __strong typeof(self) strongSelf = weakSelf;
         if (strongSelf) {
           [highlightedImageView removeFromSuperview];

           if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
             [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:strongSelf.selectedItemIndexPath];
           }
         }
       }];

      [self invalidateLayout];
    } break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded: {
      NSIndexPath *currentIndexPath = self.selectedItemIndexPath;

      if (currentIndexPath) {
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
          [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
        }

        self.selectedItemIndexPath = nil;
        self.currentViewCenter = CGPointZero;

        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];

        __weak typeof(self) weakSelf = self;
        [UIView
         animateWithDuration:0.3
         delay:0.0
         options:UIViewAnimationOptionBeginFromCurrentState
         animations:^{
           __strong typeof(self) strongSelf = weakSelf;
           if (strongSelf) {
             strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             strongSelf.currentView.center = layoutAttributes.center;
           }
         }
         completion:^(BOOL finished) {
           __strong typeof(self) strongSelf = weakSelf;
           if (strongSelf) {
             [strongSelf.currentView removeFromSuperview];
             strongSelf.currentView = nil;
             [strongSelf invalidateLayout];

             if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
               [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:currentIndexPath];
             }
           }
         }];
      }
    } break;
    default:
      break;
  }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
  switch (gestureRecognizer.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged: {
      self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
      CGPoint viewCenter = self.currentView.center = CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);

      [self invalidateLayoutIfNecessary];

      switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
          if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
            [self setupScrollTimerInDirection:NBScrollingDirectionUp];
          } else {
            if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
              [self setupScrollTimerInDirection:NBScrollingDirectionDown];
            } else {
              [self invalidatesScrollTimer];
            }
          }
        } break;
        case UICollectionViewScrollDirectionHorizontal: {
          if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
            [self setupScrollTimerInDirection:NBScrollingDirectionLeft];
          } else {
            if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
              [self setupScrollTimerInDirection:NBScrollingDirectionRight];
            } else {
              [self invalidatesScrollTimer];
            }
          }
        } break;
      }
    } break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded: {
      [self invalidatesScrollTimer];
    } break;
    default:
      break;
  }
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];

  for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
    switch (layoutAttributes.representedElementCategory) {
      case UICollectionElementCategoryCell: {
        [self applyLayoutAttributes:layoutAttributes];
      } break;
      default:
        break;
    }
  }
  return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];

  switch (layoutAttributes.representedElementCategory) {
    case UICollectionElementCategoryCell: {
      [self applyLayoutAttributes:layoutAttributes];
    } break;
    default:
      break;
  }
  return layoutAttributes;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
    return (self.selectedItemIndexPath != nil);
  }
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
    return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
  }

  if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
    return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
  }
  return NO;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:COLLECTION_VIEW_KEYPATH]) {
    if (self.collectionView != nil) {
      [self setupCollectionView];
    } else {
      [self invalidatesScrollTimer];
    }
  }
}

#pragma mark - Notifications

- (void)handleApplicationWillResignActive:(NSNotification *)notification {
  self.panGestureRecognizer.enabled = NO;
  self.panGestureRecognizer.enabled = YES;
}

@end
