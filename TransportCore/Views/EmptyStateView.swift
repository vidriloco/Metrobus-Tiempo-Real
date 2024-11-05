//
//  EmptyStateView.swift
//  Metrobus RT
//
//  Created by Alejandro Cruz on 02/11/24.
//  Copyright © 2024 El Chahuistle. All rights reserved.
//
import UIKit

class EmptyStateView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.setCustomSpacing(10, after: imageView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateLegend(with mode: Mode) {
        if mode == .start {
            titleLabel.text = "Busca un lugar en el mapa"
            subtitleLabel.text = "Escribe su nombre o su localidad"
            imageView.image = UIImage(named: "start-icon")
        } else {
            titleLabel.text = "Sin resultados que mostrarte"
            subtitleLabel.text = "No encontramos lugares para tu búsqueda"
            imageView.image = UIImage(named: "empty-icon")
        }
    }
    
    enum Mode {
        case start
        case noSearchResults
    }
}
