//
//  GenericMap.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

// MARK - Generic map view protocols

protocol GenericMap {
    func configure(on parentView: UIView)
    func centerCameraOn(location coordinates: Coordinates, animated: Bool)
    func centerMapOn(location coordinates: Coordinates, animated: Bool)
    func addPinToMap(at coordinates: Coordinates, title: String?, isUnique: Bool, isSelected: Bool)
    func addRouteToMap(with coordinates: [Coordinates], title: String)
    func clearPin()
}

protocol GenericMapDelegate {
    func mapTappedAt(coordinates: Coordinates)
}
