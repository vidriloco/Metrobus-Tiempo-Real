//
//  Result.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

public extension Result {
    
    func map<U>(_ transform: (DataType) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            return transform(val)
        case .fail(let e):
            return .fail(e)
        }
    }
    
    func transform<U>(_ transformer: (DataType) throws -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            do {
                return try transformer(val)
            } catch {
                return .fail(error)
            }
        case .fail(let e):
            return .fail(e)
        }
    }
}
