//
//  APIResourceProvider.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

protocol APIResourceDescriptor {
    init(decodable: Decodable)
}

protocol APIResourceProvider {
}

protocol APIResourceProviderDelegate {
    func didFinishRetrieving(resources: [APIResourceDescriptor])
    func failedToRetrieveResources()
}
