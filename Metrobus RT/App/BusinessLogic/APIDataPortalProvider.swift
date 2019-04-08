//
//  APIDataPortalProvider.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/7/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class APIDataPortalProvider: APIResourceProvider {
    
    private let providerURL = "datos.cdmx.gob.mx"
    private let decoder = JSONDecoder()
        
    func allLinesPaths(completion: @escaping ([LinePath]) -> Void) {
        let endPoint = APIEndpoint(scheme: "https", host: providerURL, path: "/api/records/1.0/search").with(params: ["dataset": "lineas-metrobus", "facet": "line"])

        let apiClient = APIJSONClient<JSON.Results>()
        apiClient.execute(at: endPoint) { response in
            switch response {
            case .success(let linesResponse):
                let lines = linesResponse.records.map({ LinePath.init(withLineGeometryFromAPI: $0) })
                DispatchQueue.main.async {
                    completion(lines)
                }
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
            let fields: Fields
            
            struct Fields: Decodable {
                let geometry: Geometry
                let line: Int
                
                struct Geometry: Decodable {
                    let coordinates: [[Double]]
                }
            }
        }
    }
}
