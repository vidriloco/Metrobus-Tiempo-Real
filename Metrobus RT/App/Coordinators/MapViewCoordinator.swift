//
//  MapViewCoordinator.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class MapViewCoordinator: Coordinator {
    private let presenter: UINavigationController
    
    private var mapViewController: MapViewController?
    private var linesProvider: LinesProvider
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.linesProvider = LinesProvider()
    }
    
    func start() {
        let homeLocation = Location(latitude: 19.432795, longitude: -99.1353397)
        let mapViewController = MapViewController(location: homeLocation, linesProvider: linesProvider)
        presenter.pushViewController(mapViewController, animated: true)
    }
}
