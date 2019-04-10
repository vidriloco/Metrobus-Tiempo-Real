//
//  LinesGeometryDataSource.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/7/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import Foundation

class LinesGeometryDataSource {
        
    func allLinesPaths(completion: @escaping ([LinePath]) -> Void) {
        var lines = [LinePath]()
        
        if let path = Bundle.main.path(forResource: "LinesData", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                dict.forEach { (key, val) in
                    if let line = val as? [String: Any], let number = line["number"] as? Int, let stringPaths = line["path"] as? [String] {
                        
                        let paths = stringPaths.map({
                            $0.components(separatedBy: ",")
                                .map({ $0.components(separatedBy: "\t")
                                    .map({ $0.trimmingCharacters(in: .whitespaces) })
                                    .map({ Double($0) ?? Double(0) }) }) })
                        
                        
                        lines.append(LinePath.init(number: number, paths: paths ))
                    }
                }
            }
        }
        
        completion(lines)
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
