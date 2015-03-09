//
//  Array.swift
//  NBKit
//
//  Created by Nathan Borror on 3/8/15.
//  Copyright (c) 2015 Nathan Borror. All rights reserved.
//

import Foundation

extension Array {

    mutating func removeObject<T: Equatable>(object: T) {
        var index: Int?

        for (i, obj) in enumerate(self) {
            if let to = obj as? T where object == to {
                index = i
            }
        }

        if index != nil {
            self.removeAtIndex(index!)
        }
    }

}
