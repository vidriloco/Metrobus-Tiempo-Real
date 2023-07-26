//
//  CustomLoaderIndicatorView.swift
//  Metrobus RT
//
//  Created by Alejandro Cruz on 23/07/2023.
//  Copyright © 2023 El Chahuistle. All rights reserved.
//

import UIKit

class CustomLoaderIndicatorView: UIView {
    
    private let loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        layer.backgroundColor = UIColor.white.cgColor
        addSubview(loadingIndicatorView)
        
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        loadingIndicatorView.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        loadingIndicatorView.stopAnimating()
        isHidden = true
    }
    
    struct Constants {
        static let cornerRadius: CGFloat = 5
    }
}
