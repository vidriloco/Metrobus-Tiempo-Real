//
//  APIDataPortalProvider.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/7/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class APIDataPortalProvider: APIResourceProvider {
    
    private let providerURL = "https://datos.cdmx.gob.mx"
    private let decoder = JSONDecoder()
    
    var delegate: APIResourceProviderDelegate?
    
    func allLinesPaths(completion: @escaping ([Line]) -> Void) {
        let endPoint = APIEndpoint(host: providerURL, path: "/api/records/1.0/search/?dataset=lineas-metrobus&facet=line&facet=nombre")
        
        let apiClient = APIJSONClient<JSON.Results.LineGeometry>()
        apiClient.execute(at: endPoint) { response in
            switch response {
            case .success(let linesResponse):
                print(linesResponse)
                /*let lines = linesResponse.response.map { Line(withLineFromAPI: $0) }
                DispatchQueue.main.async {
                    completion(lines)
                }*/
            case .fail:
                print("Error")
            }
        }
    }
}

// MARK - API Response structure
typealias LineGeometryFromAPI = JSON.Results.LineGeometry

extension JSON {
    struct Results: Decodable {
        
        let records: [LineGeometry]
        
        struct LineGeometry: Decodable {
            let fields: [Field]
            
            struct Field: Decodable {
                let line: Int
                let geometry: Geometry
                
                struct Geometry: Decodable {
                    let coordinates: [[Double]]
                }
            }
        }
    }
}
