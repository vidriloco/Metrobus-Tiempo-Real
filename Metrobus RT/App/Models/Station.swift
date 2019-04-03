//
//  Station.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/3/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

struct Station: Coordinates {
    
    var id = String()
    var name = String()
    var icon = String()

    var latitude: Double
    var longitude: Double
    
    var namedIcon: String  {
        return String(icon.split(separator: "/").last?.split(separator: ".").first ?? "")
    }
    
    init(withStationFromAPI station: StationFromAPI) {
        self.init(latitude: Double(station.latitude) ?? 0, longitude: Double(station.longitude) ?? 0)
        self.id = station.id
        self.name = station.name
        self.icon = station.icon
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
