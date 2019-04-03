//
//  API.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

protocol ReportableError {
    var detailed : String { get }
}

// MARK - Error

enum APIError: Error, ReportableError {
    var detailed: String {
        switch self {
        case .malformedURL:
            return "The provided URL is malformed"
        }
    }
    
    case malformedURL
}

// MARK - An enum for handling API responses

public enum Result<DataType> {
    case success(DataType)
    case fail(Error)
}
