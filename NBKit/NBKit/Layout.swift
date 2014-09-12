//
//  Layout.swift
//  NBKit
//
//  Created by Nathan Borror on 9/4/14.
//  Copyright (c) 2014 Nathan Borror. All rights reserved.
//

import UIKit

// A basic method for applying layout constraints to views.
public class Layout {

    public let views: [String:UIView]
    public let superview: UIView

    public var constraints = [AnyObject]()

    /**
        A Layout applies constraints to views using Auto Layout's visual
        formatting language.

        :param: constraints Constraints defined by auto-layout's visual 
            formatting language to be applied to the superview.
        :param: views The UIViews involved in the constraints.
        :param: superview The UIView where constraints will be applied.
    */
    public init(formats:[String], options:NSLayoutFormatOptions, metrics:[String: AnyObject]?, views:[String:UIView], superview:UIView) {
        self.views = views
        self.superview = superview

        for format in formats {
            self.addConstraint(format, options: options, metrics: metrics)
        }
    }

    /**
        A method for adding more constraints to the superview.
    
        :param: constraints Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
    */
    public func addConstraint(format:String, options:NSLayoutFormatOptions, metrics:[String: AnyObject]?) {
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: self.views)
        self.superview.addConstraints(constraint)

        self.constraints += constraint
    }

}