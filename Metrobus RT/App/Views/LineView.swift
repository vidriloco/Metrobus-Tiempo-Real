//
//  LineView.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/8/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class LineView {
    
    static func colorForLine(with title: String?) -> UIColor {
        guard let title = title, let number = Int(title) else {
            return UIColor.metrobusL1
        }
        
        return colorForLine(with: number)
    }
    
    static func colorForLine(with number: Int) -> UIColor {
        switch number {
        case 2:
            return UIColor.metrobusL2
        case 3:
            return UIColor.metrobusL3
        case 4:
            return UIColor.metrobusL4
        case 5:
            return UIColor.metrobusL5
        case 6:
            return UIColor.metrobusL6
        case 7:
            return UIColor.metrobusL7
        default:
            return UIColor.metrobusL1
        }
    }
}
