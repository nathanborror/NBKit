/*
    Layout.swift
    NBKit

    Created by Nathan Borror on 9/4/14.
    Copyright (c) 2014 Nathan Borror. All rights reserved.

    Abstract:
        The `Layout` class offers a simpler way for declaring auto-layout
        constraints.
*/

import UIKit

public enum LayoutDirection {
    case Horizontal
    case Vertical
}

// A basic method for applying layout constraints to views.
public class Layout {

    public var views: [String:AnyObject]
    public var superview: AnyObject?
    public var constraints = [NSLayoutConstraint]()

    /**
        Creates a Layout for the given views and figures out the superview
        to apply constraints to.
    
        :param: views A dictionary of views with corresponding keys to be used
            with auto-layout's visual formatting language.
    */
    public init(_ views:[String:AnyObject]) {
        self.views = views

        for (_,view) in self.views {
            // FIXME: not optimal
            if let superview = view.superview {
                self.superview = superview
            }
        }
    }

    /**
        Applies constraints to views using Auto-Layout's visual formatting language.

        :param: formats Constraints defined by auto-layout's visual formatting
            language to be applied to the superview.
        :param: metrics Optional metric values.
        :param: options Formatting options using NSLayoutFormatOptions.
    
        :returns: A reference to the Layout object.
    */
    public func with(formats:[String], metrics:[String:Double]? = nil, options:NSLayoutFormatOptions = NSLayoutFormatOptions(rawValue: 0)) -> Layout {
        for format in formats {
            self.add(format, metrics: metrics, options: options)
        }
        return self
    }

    /**
        A method for adding more constraints to the superview.

        :param: format Constraints defined by auto-layout's visual
            formatting language to be applied to the superview.
        :param: metrics Optional metric values.
        :param: options Formatting options using NSLayoutFormatOptions.
    
        :returns: A reference to the Layout object.
    */
    public func add(format:String, metrics:[String: AnyObject]? = nil, options: NSLayoutFormatOptions = NSLayoutFormatOptions(rawValue: 0)) -> Layout {
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: self.views)
        self.superview?.addConstraints(constraint)
        self.constraints += constraint
        return self
    }

    // MARK: Experimental

    /**
        Maximizes a given view within its superview.

        :param: view The view you want to fill its superview.

        :returns: A reference to the Layout object.
    */
    public class func max(obj:AnyObject, direction:LayoutDirection? = nil) -> Layout {
        if direction == nil {
            return Layout(["obj": obj])
                .add("H:|[obj]|")
                .add("V:|[obj]|")
        }

        switch direction! {
        case .Horizontal:
            return Layout(["obj": obj]).add("H:|[obj]|")
        case .Vertical:
            return Layout(["obj": obj]).add("V:|[obj]|")
        }
    }

    /**
        Returns the last constraint added to a superview.
    */
    public func last() -> NSLayoutConstraint? {
        return self.constraints.last
    }

    /**
        Updates constraints by removing all prior constraints and adding
        newly provided ones.
    
        :param: formats The new constraints to be applied to the superview.
    
        :returns: A reference to the Layout object.
    */
    public func update(formats:[String]) -> Layout  {
        self.superview?.removeConstraints(self.constraints)
        return self.with(formats)
    }

}
