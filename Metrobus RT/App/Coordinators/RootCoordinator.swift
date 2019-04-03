//
//  RootCoordinator.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {
    
    let window: UIWindow
    let rootViewController: UINavigationController
    
    let mapViewCoordinator: MapViewCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
        
        mapViewCoordinator = MapViewCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        mapViewCoordinator.start()
        window.makeKeyAndVisible()
    }
}
