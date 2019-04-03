//
//  LinesProvider.swift
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

// MARK - LinesProvider concrete resource provider

class LinesProvider: APIResourceProvider {
    
    private let providerURL = "api-dev.cdmx.gob.mx"
    private let apiClient = APIJSONClient<JSON.LinesResponse>()
    private let decoder = JSONDecoder()
    
    var delegate: APIResourceProviderDelegate?
    
    func allLines(completion: @escaping ([Line]) -> Void, failure: @escaping () -> Void) {
        let endPoint = APIEndpoint(host: providerURL, path: "/index.php/Metrobus/Lineas")
        
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
}

// MARK - API Response structure
typealias LineFromAPI = JSON.LinesResponse.Line
typealias StationFromAPI = JSON.LinesResponse.Line.Station

struct JSON {
    struct LinesResponse: Decodable {
        
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
}
