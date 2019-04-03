//
//  NSObject.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

public protocol Chainable {}
extension Chainable {
    @discardableResult public func with(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var value = self
        try block(&value)
        return value
    }
}

extension NSObject: Chainable {}
