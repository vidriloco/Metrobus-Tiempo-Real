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
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let mapViewController = MapViewController()
        presenter.pushViewController(mapViewController, animated: true)
        presenter.setNavigationBarHidden(true, animated: false)
    }
}
