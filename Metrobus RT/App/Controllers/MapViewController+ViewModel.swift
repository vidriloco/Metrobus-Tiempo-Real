//
//  MapViewController+ViewModel.swift
//  Metrobus RT
//
//  Created by Alejandro Cruz on 23/07/2023.
//  Copyright © 2023 El Chahuistle. All rights reserved.
//

import Foundation
import Combine

extension MapViewController {
    class ViewModel {
        @Published private(set) var selectedStation: Station?
        @Published private(set) var availableBuses: [Bus] = []
        @Published private(set) var error: Error?

        private let apiDevProvider: APIDevProvider
        
        init(with provider: APIDevProvider) {
            self.apiDevProvider = provider
        }
        
        func fetchStationData(at station: Station) {
            
            selectedStation = station
            
            apiDevProvider.nextArrivals(to: station.id, completion: { [weak self] buses in
                guard let self = self else { return }
                
                if buses.isEmpty {
                    error = NSError(domain: "", code: 404)
                } else {
                    availableBuses = buses
                }
                
            }) { [weak self] in
                
                guard let self = self else { return }
            }
        }
    }
}

extension MapViewController.ViewModel {
    class StationInfo: ObservableObject {
        @Published var name: String
        
        @Published var destination: String?
        @Published var busNumber: String?
        @Published var arrivingInMinutes: String?

        public init(name: String) {
            self.name = name
        }
        
        func update(with destination: String, busNumber: String, arrivingInMinutes: String) {
            self.destination = destination
            self.busNumber = busNumber
            self.arrivingInMinutes = arrivingInMinutes
        }
    }
}
