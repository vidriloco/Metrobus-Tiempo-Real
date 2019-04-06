//
//  BusCardViewCell.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/4/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class BusCardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var busIcon: UIImageView?
    @IBOutlet weak var busNumberLabel: UILabel?
    @IBOutlet weak var directionTitleLabel: UILabel?
    @IBOutlet weak var directionLabel: UILabel?
    @IBOutlet weak var arrivalTimeLabel: UILabel?
    @IBOutlet weak var detailsBackgroundView: UIView?
    
    struct ViewModel {
        let number: String
        let destination: String
        let arrivingIn: String
        
        init(bus: Bus) {
            self.number = "unidad \(bus.busNumber)"
            self.destination = bus.destination
            self.arrivingIn = "en \(bus.arrivingIn)"
        }
    }
    
    func configureWith(viewModel: ViewModel) {
        busNumberLabel?.text = viewModel.number
        busNumberLabel?.textColor = UIColor.mint
        directionLabel?.text = viewModel.destination
        arrivalTimeLabel?.text = viewModel.arrivingIn
        arrivalTimeLabel?.textColor = UIColor.mint

        directionTitleLabel?.textColor = UIColor.darkGray
        directionLabel?.textColor = UIColor.darkGray

        detailsBackgroundView?.layer.borderColor = UIColor.mint.cgColor.copy(alpha: 0.7)
        detailsBackgroundView?.layer.cornerRadius = 5
        detailsBackgroundView?.layer.borderWidth = 1.5
        backgroundColor = .clear

    }

}
