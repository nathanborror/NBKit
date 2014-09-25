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

    public let views: [String:AnyObject]
    public let superview: AnyObject
    public var constraints = [AnyObject]()

    /**
        A Layout applies constraints to views using Auto Layout's visual
        formatting language.

        :param: formats Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: options Formatting options using NSLayoutFormatOptions.
        :param: metrics Optional metric values.
        :param: views The UIViews involved in the constraints.
        :param: superview The UIView where constraints will be applied.
    */
    public init(superview: UIView, views: [String:AnyObject], formats: [String], metrics: [String:Double]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        self.superview = superview
        self.views = views
        self.addConstraints(formats, metrics: metrics, options: options)

        for (key,view) in self.views {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
    }

    /**
        A method for adding more constraints to the superview.

        :param: constraints Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
    */
    func addConstraint(format:String, metrics:[String: AnyObject]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: self.views)
        self.superview.addConstraints(constraint)
        self.constraints += constraint
    }

    /**
        A method for adding constraints to a superview.

        :param: formats Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: options Formatting options using NSLayoutFormatOptions.
        :param: metrics Optional metric values.
    */
    func addConstraints(formats:[String], metrics:[String: AnyObject]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        for format in formats {
            self.addConstraint(format, metrics: metrics, options: options)
        }
    }

}