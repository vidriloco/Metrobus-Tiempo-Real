//
//  Station.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/3/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class Station: Location {
    
    var id = String()
    var name = String()
    var icon = String()
    var lineName = String()
    
    var namedIcon: String  {
        return String(icon.split(separator: "/").last?.split(separator: ".").first ?? "")
    }
    
    init(withStationFromAPI station: StationFromAPI, forLine lineNamed: String) {
        super.init(latitude: Double(station.latitude) ?? 0, longitude: Double(station.longitude) ?? 0)
        self.id = station.id
        self.name = station.name.capitalized.replacingOccurrences(of: "_", with: " ")
        self.icon = station.icon
        self.lineName = lineNamed
    }
    
    required init(latitude: Double, longitude: Double) {
        super.init(latitude: latitude, longitude: longitude)
    }
    
}
