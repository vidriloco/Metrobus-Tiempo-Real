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
    //private var forecastDetailsView = ForecastDetailsView().withoutAutoConstraints()
    
    private let locationCoordinates: Location
    private let linesProvider: LinesProvider
    
    //var coordinatorDelegate: LocationForecastDetailsDelegate?
    
    private var stations = [Station]()
    
    init(location: Location, linesProvider: LinesProvider) {
        self.locationCoordinates = location
        self.linesProvider = linesProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        mapView.configure(on: view)
        mapView.delegate = self
        //mapView.addSubview(forecastDetailsView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //forecastDetailsView.setupViewsAndConstraintsAgainst(parent: mapView)
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
        /*let forecastAspectsViewController = makeForecastAspectsViewController()
        addChild(forecastAspectsViewController)
        
        forecastDetailsView.configureForecastAspects(withView: forecastAspectsViewController.collectionView)
        
        locationForecastProvider.weatherAt(coordinates: locationCoordinates, completion: { location in
            forecastAspectsViewController.prepareWithForecastLocation(location: location)
            
            let headerViewModel = ForecastDetailsView.ForecastHeaderViewModel(with: location.generalStatus)
            
            self.forecastDetailsView.configureForecastAspects(with: headerViewModel, withView: forecastAspectsViewController.collectionView)
        }) {
            let alert = UIAlertController(title: "Oops :/", message: "It was not possible to fetch the weather information for this locality", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Return to list of localities", style: .default, handler: { _ in
                self.coordinatorDelegate?.dismissToLocationsListViewController()
            }))
            
            self.present(alert, animated: true)
        }*/
    }
    
    /*private func makeForecastAspectsViewController() -> WeatherCollectionViewController {
        let forecastAspectsViewController = WeatherCollectionViewController()
        
        let oldFrame = forecastAspectsViewController.collectionView.frame
        
        let extraWidth = forecastDetailsView.extraWidthDueConstraints
        forecastDetailsView.layoutIfNeeded()
        
        let newSize = CGSize(width: forecastDetailsView.frame.width-extraWidth, height: oldFrame.size.height)
        forecastAspectsViewController.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        forecastAspectsViewController.collectionView.frame = CGRect(origin: oldFrame.origin, size: newSize)
        return forecastAspectsViewController
    }*/
    
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
                
                annotationView?.image = UIImage(named: station.namedIcon)
            }
            
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }*/
    
}

extension Station {
    func equals(to coordinate: CLLocationCoordinate2D) -> Bool {
        return self.longitude == coordinate.longitude && self.latitude == coordinate.latitude
    }
}
