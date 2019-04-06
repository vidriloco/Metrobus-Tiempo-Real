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
        static let leading: CGFloat = 20
        static let trailing: CGFloat = 20
        static let top: CGFloat = 20
        static let bottom: CGFloat = 10
    }
    
    struct ParentViewConstraints {
        static let leading: CGFloat = 20
        static let trailing: CGFloat = 20
        static let bottom: CGFloat = 20
    }
    
    struct ImageViewConstraints {
        static let bottom: CGFloat = -25
        static let leading: CGFloat = 10
        static let height: CGFloat = 100
    }
    
    var extraWidthDueConstraints : CGFloat {
        return InnerConstraints.leading + InnerConstraints.trailing
    }
    
    private let stackView = UIStackView().withoutAutoConstraints().with {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .leading
        $0.spacing = 0
    }
    
    private let titleLabel = UILabel().withoutAutoConstraints().with {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray

    }
    
    private let subtitleLabel = UILabel().withoutAutoConstraints().with {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = UIColor.darkGray.withAlphaComponent(0.8)
    }
    
    private let otherLabel = UILabel().withoutAutoConstraints().with {
        $0.font = UIFont.boldSystemFont(ofSize: 10)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = UIColor.darkGray.withAlphaComponent(0.6)
    }
    
    private let spacingView = UIView().withoutAutoConstraints()
    
    private let imageView = UIImageView().withoutAutoConstraints().with {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "metrobus-icon")

    }
    
    init() {
        super.init(frame: .zero)
        customizeAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsAndConstraintsAgainst(parent view: UIView) {
        addSubview(imageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(otherLabel)

        stackView.addArrangedSubview(spacingView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: InnerConstraints.leading),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: InnerConstraints.trailing),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: InnerConstraints.top),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: InnerConstraints.bottom)
            ])
        
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: ParentViewConstraints.bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ParentViewConstraints.leading),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ParentViewConstraints.trailing)
            ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ImageViewConstraints.leading),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ImageViewConstraints.bottom),
            imageView.heightAnchor.constraint(equalToConstant: ImageViewConstraints.height),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            spacingView.heightAnchor.constraint(equalToConstant: 10),
            spacingView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor)
            ])
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        otherLabel.setContentHuggingPriority(.required, for: .vertical)
        otherLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configureHeader(with headerViewModel: BusPanelHeaderViewModel? = nil, withView view: UICollectionView) {
        if !stackView.arrangedSubviews.contains(view) {
            stackView.addArrangedSubview(view)
        }
        
        if let viewModel = headerViewModel {
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            otherLabel.text = viewModel.humanizedArrivals
        }
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            view.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
    }
    
    private func customizeAppearance() {
        backgroundColor = .white
        stackView.backgroundColor = .clear
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.shadowRadius = 2
        layer.borderColor = UIColor.metrobus.cgColor.copy(alpha: 0.2)
        layer.borderWidth = 5
        imageView.alpha = 0.1
        
    }
    
    struct BusPanelHeaderViewModel {
        let title: String
        let subtitle: String
        let arrivals: Int
        
        var humanizedArrivals: String {
            get {
                if arrivals == 1 {
                    return "Próxima llegada".uppercased()
                } else {
                    return "Próximas \(arrivals) llegadas".uppercased()
                }
            }
        }
    }
}
