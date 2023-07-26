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
        self.arrivingIn = convertToMinutes(arriving: metrobus.arrivingIn)
        self.destination = metrobus.destination
        self.busNumber = metrobus.busNumber
    }

    func convertToMinutes(arriving: String) -> String {
        let pattern = #"(\d+)\s\w+"#
        
        return arriving.matches(for: pattern).first ?? arriving
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
