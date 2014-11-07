//
//  NBLabel.swift
//  NBKit
//
//  Created by Nathan Borror on 10/27/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import UIKit

class NBLabel: UILabel {

    let padding:UIEdgeInsets!

    init(padding: UIEdgeInsets) {
        super.init(frame: CGRectZero)
        self.padding = padding
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawTextInRect(rect: CGRect) {
        return super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }

    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, self.padding), limitedToNumberOfLines: numberOfLines)
        rect.origin.x += padding.left
        rect.origin.y += padding.top
        rect.size.width += (padding.left + padding.right)
        rect.size.height += (padding.top + padding.bottom)
        return rect
    }

}
