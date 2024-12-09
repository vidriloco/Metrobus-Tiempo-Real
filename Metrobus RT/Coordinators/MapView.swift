//
//  MapView.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

public class MapView {
    public static func build(with flavor: Flavor) -> UIViewController {
        let viewModel = MapViewController.ViewModel(flavor: flavor)
        return MapViewController(viewModel: viewModel)
    }
}

public struct MetrobusFlavor: Flavor {
    
    public var url: URL? { URL(string: "https://wikiando.mx/mobile") }
    
    public init() { }
}

public struct MexibusFlavor: Flavor {
    public var url: URL? { URL(string: "https://wikiando.mx/mobile-mexibus") }
    
    public init() { }
}
