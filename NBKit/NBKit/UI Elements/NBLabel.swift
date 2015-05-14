/*
    NBLabel.swift
    NBKit

    Created by Nathan Borror on 10/27/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `NBLabel` offers a simpler way to create UILabels with padding.
*/

import UIKit

public class NBLabel: UILabel {

    public var padding:UIEdgeInsets?

    override public func drawTextInRect(rect: CGRect) {
        if let padding = self.padding {
            return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
        }
    }

    override public func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        if let padding = self.padding {
            var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, padding), limitedToNumberOfLines: numberOfLines)
            rect.origin.x += padding.left
            rect.origin.y += padding.top
            rect.size.width += (padding.left + padding.right)
            rect.size.height += (padding.top + padding.bottom)
            return rect
        }
        return super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
    }
    
}
