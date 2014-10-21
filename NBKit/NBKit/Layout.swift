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

    public var views: [String:AnyObject]
    public var superview: AnyObject?
    public var constraints = [AnyObject]()

    /**
        A Layout applies constraints to views using Auto Layout's visual
        formatting language.

        :param: views The UIViews involved in the constraints.
        :param: with Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: metrics Optional metric values.
        :param: options Formatting options using NSLayoutFormatOptions.
    */
    public init(views:[String:AnyObject], with:[String], metrics:[String:Double]? = nil, options:NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        self.views = views

        for (key,view) in self.views {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)

            // FIXME: not optimal
            if let superview = view.superview? {
                self.superview = superview
            }
        }

        self.addConstraints(with, metrics: metrics, options: options)
    }

    /**
        A method for adding more constraints to the superview.

        :param: with Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: metrics Optional metric values.
        :param: options Formatting options using NSLayoutFormatOptions.
    */
    func addConstraint(with:String, metrics:[String: AnyObject]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat(with, options: options, metrics: metrics, views: self.views)

        if superview != nil {
            self.superview!.addConstraints(constraint)
            self.constraints += constraint
        }
    }

    /**
        A method for adding constraints to a superview.

        :param: with Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: options Formatting options using NSLayoutFormatOptions.
        :param: metrics Optional metric values.
    */
    func addConstraints(with:[String], metrics:[String: AnyObject]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(0)) {
        for format in with {
            self.addConstraint(format, metrics: metrics, options: options)
        }
    }

}
