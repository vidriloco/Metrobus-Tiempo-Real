//
//  Line.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/3/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

struct Line {
    var color: String
    var name: String
    var stations: [Station]
    
    init(withLineFromAPI line: LineFromAPI) {
        self.color = line.color
        self.name = line.name
        self.stations = line.stations.map { Station(withStationFromAPI: $0) }
    }
}
