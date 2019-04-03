//
//  Location.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

struct Location: Coordinates {
    
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    var representation: String {
        return "\(latitude)-\(longitude)"
    }
    
    var asDictionary: [String: Any] {
        return [
            "name": name,
            "longitude": longitude,
            "latitude": latitude
        ]
    }
    
    init(_ name: String, latitude: Double, longitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
        self.name = name
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(dictionary: [String: Any]) {
        self.init(dictionary["name"] as? String ?? "",
                  latitude: dictionary["latitude"] as? Double ?? 0,
                  longitude: dictionary["longitude"] as? Double ?? 0)
    }
}
