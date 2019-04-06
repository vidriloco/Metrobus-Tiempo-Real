//
//  Location.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/3/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class Location: Coordinates {
    var latitude: Double
    var longitude: Double
    
    required init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
