//
//  Dictionary.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

extension Dictionary {
    @discardableResult public func with(_ block: (Dictionary<Key,Value>) throws -> Void) rethrows -> Dictionary<Key,Value> {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Dictionary<Key,Value>) throws -> Void) rethrows -> Dictionary<Key,Value> {
        var value = self
        try block(&value)
        return value
    }
}
