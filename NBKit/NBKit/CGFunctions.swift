/*
    CGFunctions.swift
    NBKit

    Created by Nathan Borror on 2/2/15.
    Copyright (c) 2015 Nathan Borror. All rights reserved.

    Abstract:
        The `CGFunctions` are a set of convenience functions for making the
        Core Geometry functions a little easier and more terser to use.
*/

import Foundation
import UIKit

enum CGProperty {
    case Width, Height
    case MinX, MidX, MaxX
    case MinY, MidY, MaxY
}

func GetCGProperty(prop: CGProperty, frame: CGRect?) -> CGFloat {
    if let frame = frame {
        switch prop {
        case .Width:
            return CGRectGetWidth(frame)
        case .Height:
            return CGRectGetHeight(frame)
        case .MinX:
            return CGRectGetMinX(frame)
        case .MidX:
            return CGRectGetMidX(frame)
        case .MaxX:
            return CGRectGetMaxX(frame)
        case .MinY:
            return CGRectGetMinY(frame)
        case .MidY:
            return CGRectGetMidY(frame)
        case .MaxY:
            return CGRectGetMaxY(frame)
        default:
            break
        }
    }
    return 0.0
}

func Width(view: UIView?) -> CGFloat {
    return GetCGProperty(.Width, view?.bounds)
}

func Height(view: UIView?) -> CGFloat {
    return GetCGProperty(.Height, view?.bounds)
}

func MinX(view: UIView?) -> CGFloat {
    return GetCGProperty(.MinX, view?.frame)
}

func MidX(view: UIView?) -> CGFloat {
    return GetCGProperty(.MidX, view?.frame)
}

func MaxX(view: UIView?) -> CGFloat {
    return GetCGProperty(.MaxX, view?.frame)
}

func MinY(view: UIView?) -> CGFloat {
    return GetCGProperty(.MinY, view?.frame)
}

func MidY(view: UIView?) -> CGFloat {
    return GetCGProperty(.MidY, view?.frame)
}

func MaxY(view: UIView?) -> CGFloat {
    return GetCGProperty(.MaxY, view?.frame)
}

func CenterX(parent: UIView?, child: UIView?) -> CGFloat {
    return (Width(parent) / 2.0) - (Width(child) / 2.0)
}

func CenterY(parent: UIView?, child: UIView?) -> CGFloat {
    return (Height(parent) / 2.0) - (Height(child) / 2.0)
}

func Right(parent: UIView?, child: UIView?) -> CGFloat {
    return Width(parent) - Width(child)
}
