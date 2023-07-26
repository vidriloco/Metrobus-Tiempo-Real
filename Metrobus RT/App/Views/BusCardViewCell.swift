//
//  BusCardViewCell.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/4/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class BusCardViewCell: UIView {
    
    private lazy var mainContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [busIcon, directionLabel, arrivalContainer])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        
        return view
    }()
    
    private lazy var arrivalContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [arrivalIcon, arrivalTimeLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 5
        
        return view
    }()
    
    var busIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "bus")
        return view
    }()
    
    var directionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var arrivalIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "real-time")
        return view
    }()
    
    var arrivalTimeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 13)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var detailsBackgroundView: UIView?
    
    func applyTextColorChange(color: UIColor) {
        directionLabel.textColor = color
    }
    
    private func configureWith(viewModel: ViewModel) {
        directionLabel.text = viewModel.destination
        arrivalTimeLabel.text = viewModel.arrivingIn
        arrivalTimeLabel.textColor = UIColor.mint

        directionLabel.textColor = UIColor.darkGray

        detailsBackgroundView?.layer.borderColor = UIColor.mint.cgColor.copy(alpha: 0.7)
        detailsBackgroundView?.layer.cornerRadius = 5
        detailsBackgroundView?.layer.borderWidth = 1.5
        
        mainContainer.setCustomSpacing(10, after: busIcon)
        mainContainer.setCustomSpacing(10, after: directionLabel)

        layer.backgroundColor = UIColor.gray.withAlphaComponent(0.08).cgColor
        layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
    }
    
    func animate(delay: TimeInterval) {
        UIView.animate(withDuration: 1.5, delay: delay, options: [.repeat, .autoreverse], animations: {
            self.arrivalIcon.alpha = 0.1
        }, completion: nil)
    }
    
    func setupViewAndConstraints() {
        addSubview(mainContainer)
        
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            mainContainer.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            arrivalIcon.widthAnchor.constraint(equalToConstant: 10),
            arrivalIcon.heightAnchor.constraint(equalToConstant: 20),
            busIcon.widthAnchor.constraint(equalToConstant: 20),
            busIcon.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    init(with viewModel: ViewModel) {
        super.init(frame: .zero)
        
        setupViewAndConstraints()
        configureWith(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BusCardViewCell {
    struct ViewModel {
        let number: String
        let destination: String
        let arrivingIn: String
        
        init(bus: Bus) {
            self.number = "unidad \(bus.busNumber)"
            self.destination = bus.destination
            self.arrivingIn = "\(bus.arrivingIn)"
        }
    }
}
