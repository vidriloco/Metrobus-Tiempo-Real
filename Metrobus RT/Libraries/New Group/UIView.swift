//
//  UIView.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

extension UIView {
    
    func withoutAutoConstraints() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func added(to view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
}
