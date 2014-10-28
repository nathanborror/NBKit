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

    override func intrinsicContentSize() -> CGSize {
        let size = super.intrinsicContentSize()
        return CGSizeMake(size.width + (self.padding.left+self.padding.right), size.height + (self.padding.top+self.padding.bottom))
    }

}
