//
//  APIDevProvider.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/3/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

// MARK - Specific error types for resource

enum APIResourceProviderError: Error {
    case undecodableResponseError
    case unexpectedError
}

// MARK - APIDevProvider concrete resource provider

class APIDevProvider: APIResourceProvider {
    
    private let providerURL = "api-dev.cdmx.gob.mx"
    private let decoder = JSONDecoder()
    
    var delegate: APIResourceProviderDelegate?
    
    func allLines(completion: @escaping ([Line]) -> Void, failure: @escaping () -> Void) {
        let endPoint = APIEndpoint(host: providerURL, path: "/index.php/Metrobus/Lineas")
        
        let apiClient = APIJSONClient<JSON.Lines>()
        apiClient.execute(at: endPoint) { response in
            switch response {
            case .success(let linesResponse):
                
                let lines = linesResponse.response.map { Line(withLineFromAPI: $0) }
                DispatchQueue.main.async {
                    completion(lines)
                }
            case .fail:
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
    
    //func icon(for station: Station) -> NSData {
        // TODO: For when there is a consistent way to retrieve an icon
        //let endPoint = APIEndpoint(host: providerURL, path: "/index.php/Metrobus/Lineas")
    //}
    
    func nextArrivals(to stationId: String, completion: @escaping([Bus]) -> Void, failure: @escaping () -> Void) {
        let endPoint = APIEndpoint(host: providerURL, path: "/index.php/Metrobus/Estaciones").with(params: ["id": stationId, "num_metrobuses": "8"])
        
        let apiClient = APIJSONClient<JSON.Buses>()
        apiClient.execute(at: endPoint) { response in
            switch response {
            case .success(let stations):
                
                let buses = stations.response.metrobuses.map { Bus(withMetrobusFromAPI: $0) }
                DispatchQueue.main.async {
                    completion(buses)
                }
            case .fail:
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
}

// MARK - API Response structure
typealias LineFromAPI = JSON.Lines.Line
typealias StationFromAPI = JSON.Lines.Line.Station
typealias BusFromAPI = JSON.Buses.Metrobus

struct JSON {
    struct Lines: Decodable {
        
        let response: [Line]
        
        struct Line: Decodable {
            let color: String
            let name: String
            let stations: [Station]
            
            private enum CodingKeys : String, CodingKey {
                case color, name = "linea", stations = "estaciones"
            }
            
            struct Station: Decodable {
                let id: String
                let name: String
                let icon: String
                let latitude: String
                let longitude: String
                
                private enum CodingKeys : String, CodingKey {
                    case id, name = "nombre", icon = "nombre_icono", latitude = "latitud", longitude = "longitud"
                }
            }
        }
    }
    
    struct Buses: Decodable {
        
        let response: Response
        
        struct Response: Decodable {
            let icon: String
            let metrobuses: [Metrobus]
            
            private enum CodingKeys : String, CodingKey {
                case icon = "icono", metrobuses
            }
        }
        
        struct Metrobus: Decodable {
            let latitude: Double
            let longitude: Double
            let distance: Double
            let arrivingIn: String
            let destination: String
            let busNumber: String
            
            private enum CodingKeys : String, CodingKey {
                case latitude = "latitud", longitude = "longitud", arrivingIn = "tiempo_llegar", destination = "destino", busNumber = "label", distance = "distancia"
            }
        }
        
    }
}
