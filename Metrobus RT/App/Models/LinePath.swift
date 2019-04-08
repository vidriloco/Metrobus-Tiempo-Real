//
//  LinePath.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/7/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

struct LinePath {
    let number: Int
    let coordinates: [[Double]]
    
    init(withLineGeometryFromAPI lineGeom: LineGeometryFromAPI) {
        self.number = lineGeom.fields.line
        self.coordinates = lineGeom.fields.geometry.coordinates
    }
}
