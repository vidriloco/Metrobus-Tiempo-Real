//
//  BusPanelView.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/4/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit

class BusPanelView: UIView {
    
    struct InnerConstraints {
        static let margin: CGFloat = 20
        static let loadingIndicatorSize: CGFloat = 30
    }
    
    private lazy var headerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [stationNameLabel, lineNameLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 1
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView, nextBusesView, loadingIndicatorView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 20
        
        return view
    }()
    
    private lazy var nextBusesView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 8
        
        return view
    }()
    
    private lazy var loadingIndicatorView: CustomLoaderIndicatorView = {
        let view = CustomLoaderIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stationNameLabel = UILabel().withoutAutoConstraints().with {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = defaultTextColor
    }
    
    private lazy var lineNameLabel = UILabel().withoutAutoConstraints().with {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = defaultTextColor.withAlphaComponent(0.5)
    }
    
    private let spacingView = UIView().withoutAutoConstraints()
    
    private let imageView = UIImageView().withoutAutoConstraints().with {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "metrobus-icon")
    }
    
    private var nextArrivalsViews: [BusCardViewCell] = []
    
    init() {
        super.init(frame: .zero)
        customizeAppearance()
        setupViews()
        loadingIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(stackView)
        
        nextBusesView.isHidden = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: InnerConstraints.margin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -InnerConstraints.margin),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: InnerConstraints.margin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -InnerConstraints.margin),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: InnerConstraints.loadingIndicatorSize)
        ])
    }
    
    func configureHeaderWith(stationName: String, lineName: String) {
        stationNameLabel.text = stationName
        lineNameLabel.text = lineName
        loadingIndicatorView.startAnimating()
    }
    
    func configureWith(buses: [Bus]) {
        nextBusesView.isHidden = false
        
        buses.forEach {
            let busView = BusCardViewCell(with: .init(bus: $0))
            
            busView.applyTextColorChange(color: defaultTextColor)
            nextBusesView.addArrangedSubview(busView)
            
            busView.animate(delay: [1.5,1,0.4, 0.1].shuffled().first!)
            
            nextArrivalsViews.append(busView)
        }
        
        loadingIndicatorView.stopAnimating()
    }
    
    private func customizeAppearance() {
        backgroundColor = defaultBackgroundColor
        stackView.backgroundColor = .clear
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.shadowRadius = 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 5
        imageView.alpha = 0.5
    }
    
    func setColors() {
        stationNameLabel.textColor = defaultTextColor
        lineNameLabel.textColor = defaultTextColor.withAlphaComponent(0.5)
        backgroundColor = defaultBackgroundColor
        layer.borderColor = borderColor.cgColor
        
        nextArrivalsViews.forEach { $0.applyTextColorChange(color: defaultTextColor) }
    }
    
    var defaultTextColor: UIColor {
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.darkGray
    }
    
    var defaultBackgroundColor: UIColor {
        return traitCollection.userInterfaceStyle == .dark ? UIColor.darkBackground : UIColor.white
    }
    
    var borderColor: UIColor {
        return traitCollection.userInterfaceStyle == .dark ? UIColor.metrobusDark : UIColor.metrobus.withAlphaComponent(0.5)
    }
}
