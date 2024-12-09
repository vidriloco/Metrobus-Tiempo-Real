//
//  LocationTableViewCell.swift
//  Metrobus RT
//
//  Created by Alejandro Cruz on 02/11/24.
//  Copyright © 2024 El Chahuistle. All rights reserved.
//
import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var verticalRightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, addressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var verticalLeftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, distanceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalLeftStackView, verticalRightStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            horizontalStackView.widthAnchor.constraint(equalToConstant: 40),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 40),
            verticalLeftStackView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with location: SearchPlacesViewController.Location) {
        iconImageView.image = UIImage(named: "marker-icon")
        nameLabel.text = location.name
        addressLabel.text = location.address
        
        let distance = String(format: "%.1f", location.distance / 1000)
        distanceLabel.text = "\(distance) kms"
    }
}
