//
//  MapViewController.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var mapView = AppleMapView().withoutAutoConstraints()
    private var busPanelView = BusPanelView().withoutAutoConstraints()
    
    private let locationCoordinates: Coordinates
    private let linesProvider: LinesProvider
    
    private var busesCardViewController: BusesCardViewController!

    //var coordinatorDelegate: LocationForecastDetailsDelegate?
    
    private var stations = [Station]()
    
    init(location: Coordinates, linesProvider: LinesProvider) {
        self.locationCoordinates = location
        self.linesProvider = linesProvider

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
        fetchLines()
    }
    
    private func configureViewController() {
        navigationItem.title = "Metrobus en Tiempo Real"
        mapView.centerMapOn(location: locationCoordinates, animated: true)
        //mapView.addPinToMap(at: locationCoordinates, title: locationCoordinates.name, isUnique: true, isSelected: true)
        mapView.centerCameraOn(location: locationCoordinates, animated: true)
    }
    
    private func fetchLines() {
        
        if stations.isEmpty {
            linesProvider.allLines(completion: { lines in
                lines.forEach({ line in
                    line.stations.forEach { [weak self] station in
                        
                        guard let self = self else { return }
                        self.mapView.addPinToMap(at: station, title: station.name, isUnique: false)
                        self.stations.append(station)
                    }
                })
            }) {
                print("Error")
            }
        }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let coordinate = view.annotation?.coordinate else {
            return
        }

        if let station = stations.first(where: { $0.equals(to: coordinate) }) {
            linesProvider.nextArrivals(to: station.id, completion: { [weak self] buses in
                guard let self = self else { return }
                
                self.busesCardViewController.updateWith(busList: buses)
                let viewModel = BusPanelView.BusPanelHeaderViewModel(title: station.name, subtitle: station.lineName, arrivals: buses.count)
                self.busPanelView.configureHeader(with: viewModel, withView: self.busesCardViewController.collectionView)
            }) {
                print("Error")
            }
        }
    }
    
}

extension Station {
    func equals(to coordinate: CLLocationCoordinate2D) -> Bool {
        return self.longitude == coordinate.longitude && self.latitude == coordinate.latitude
    }
}
