//
//  Bus.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class Bus: Location {

    var arrivingIn: String = ""
    var destination: String = ""
    var busNumber: String = ""
    
    required init(latitude: Double, longitude: Double) {
        super.init(latitude: latitude, longitude: longitude)
    }
    
    init(withMetrobusFromAPI metrobus: BusFromAPI) {
        super.init(latitude: metrobus.latitude, longitude: metrobus.longitude)
        self.arrivingIn = metrobus.arrivingIn
        self.destination = metrobus.destination
        self.busNumber = metrobus.busNumber
    }

}
