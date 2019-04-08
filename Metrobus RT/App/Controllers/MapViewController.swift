//
//  MapViewController.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit
import MapKit
import JGProgressHUD

class MapViewController: UIViewController {
    
    private var mapView = AppleMapView().withoutAutoConstraints()
    private var busPanelView = BusPanelView().withoutAutoConstraints().with {
        $0.isHidden = true
    }
    
    private let locationCoordinates: Coordinates
    private let apiDevProvider: APIDevProvider
    
    private var busesCardViewController: BusesCardViewController!
    
    private var stations = [Station]()
    
    init(location: Coordinates, apiDevProvider: APIDevProvider) {
        self.locationCoordinates = location
        self.apiDevProvider = apiDevProvider

        super.init(nibName: nil, bundle: nil)
        
        self.busesCardViewController = self.makeBusesCardViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        mapView.configure(on: view)
        mapView.delegate = self
        
        addChild(busesCardViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.addSubview(busPanelView)
        busPanelView.setupViewsAndConstraintsAgainst(parent: mapView)
        fetchLinesData()
    }
    
    private func configureViewController() {
        configureNavigationBar()
        mapView.centerMapOn(location: locationCoordinates, animated: true)
        mapView.centerCameraOn(location: locationCoordinates, animated: true)
    }
    
    private func configureNavigationBar() {
        let nav = navigationController?.navigationBar
        nav?.isTranslucent = false
        nav?.setBackgroundImage(UIImage(named: "nav-bar-bg"), for: .default)
        nav?.shadowImage = UIImage(named: "shadow-bar-bg")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "nav-bar-logo")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    private func fetchLinesData() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Cargando Líneas"
        hud.show(in: self.view)
        
        if stations.isEmpty {
            apiDevProvider.allLines(completion: { lines in
                lines.forEach({ line in
                    line.stations.forEach { [weak self] station in
                        
                        guard let self = self else { return }
                        self.mapView.addPinToMap(at: station, title: station.name, isUnique: false)
                        self.stations.append(station)
                    }
                })
                hud.dismiss()
            }) { [weak self] in
                
                guard let self = self else { return }
                
                hud.dismiss(animated: false)
                self.displayFailedFetchingLinesErrorAlert()
            }
        }
    }
    
    private func displayFailedFetchingLinesErrorAlert() {
        let alert = UIAlertController(title: "Ujule", message: "No pudimos descargar el mapa de las líneas. Revisa tu conexión a internet.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: { action in
            self.fetchLinesData()
        }))
        
        self.present(alert, animated: true)
    }
    
    private func fetchStationData(at coordinate: CLLocationCoordinate2D) {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)
        
        if let station = stations.first(where: { $0.equals(to: coordinate) }) {
            apiDevProvider.nextArrivals(to: station.id, completion: { [weak self] buses in
                guard let self = self else { return }
                
                self.busesCardViewController.updateWith(busList: buses)
                let viewModel = BusPanelView.BusPanelHeaderViewModel(title: station.name, subtitle: station.lineName, arrivals: buses.count)
                self.busPanelView.configureHeader(with: viewModel, withView: self.busesCardViewController.collectionView)
                self.busPanelView.isHidden = false
                hud.dismiss()
            }) { [weak self] in
                
                guard let self = self else { return }
                
                hud.dismiss(animated: false)
                self.displayFailedFetchingStationErrorAlert()
            }
        }
    }
    
    private func displayFailedFetchingStationErrorAlert() {
        let alert = UIAlertController(title: "Ujule", message: "No pudimos cargar la info de esta estación", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func makeBusesCardViewController() -> BusesCardViewController {
        let busesCardViewController = BusesCardViewController()
        
        let oldFrame = busesCardViewController.collectionView.frame
        
        let extraWidth = busPanelView.extraWidthDueConstraints
        busPanelView.layoutIfNeeded()
        
        let newSize = CGSize(width: busPanelView.frame.width-extraWidth, height: oldFrame.size.height)
        busesCardViewController.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        busesCardViewController.collectionView.frame = CGRect(origin: oldFrame.origin, size: newSize)
        return busesCardViewController
    }
}

extension MapViewController: MKMapViewDelegate {
    // For handling icons
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Pin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            if let station = stations.first(where: { $0.equals(to: annotation.coordinate)  }) {
                
                //annotationView?.image = UIImage(named: station.namedIcon)
            }
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }*/
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        busPanelView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let coordinate = view.annotation?.coordinate else {
            return
        }

        fetchStationData(at: coordinate)
    }
    
}

extension Station {
    func equals(to coordinate: CLLocationCoordinate2D) -> Bool {
        return self.longitude == coordinate.longitude && self.latitude == coordinate.latitude
    }
}
