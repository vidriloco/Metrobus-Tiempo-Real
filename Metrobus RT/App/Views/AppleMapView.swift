//
//  AppleMapView.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import MapKit

// MARK - Apple map view wrapper around MKMapView

class AppleMapView: MKMapView, GenericMap {
    
    private var allowedAltitudeRange = CLLocationDistance(120000)...CLLocationDistance(190000)
    
    var mapDelegate: GenericMapDelegate?
    
    func configure(on parentView: UIView) {
        self.added(to: parentView)
            .withoutAutoConstraints()
            .with({ mapView in
                parentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
                parentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
                mapView.isZoomEnabled = true
                mapView.isPitchEnabled = true
                mapView.showsUserLocation = true
            })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        let doubletapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        doubletapGestureRecognizer.numberOfTapsRequired = 2
        doubletapGestureRecognizer.cancelsTouchesInView = false
        
        tapGestureRecognizer.require(toFail: doubletapGestureRecognizer)
        
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(doubletapGestureRecognizer)
        
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        if sender.numberOfTouches == 1 {
            let locationInView = sender.location(in: self)
            let tappedCoordinate = self.convert(locationInView, toCoordinateFrom: self)
            
            mapDelegate?.mapTappedAt(coordinates: Location(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude))
        }
    }
    
    func addPinToMap(at coordinates: Coordinates, title: String? = "", isUnique: Bool, isSelected: Bool = false) {
        
        if isUnique {
            clearPin()
        }
        
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2D(coordinates)
        addAnnotation(annotation)
        
        if isSelected {
            selectAnnotation(annotation, animated: true)
        }
    }
    
    func centerCameraOn(location coordinateLocation: Coordinates, animated: Bool) {
        let altitude = (allowedAltitudeRange ~= camera.altitude) ? camera.altitude : allowedAltitudeRange.lowerBound
        
        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude-0.11, coordinateLocation.longitude)
        let mapCamera = MKMapCamera(lookingAtCenter: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: altitude)
        setCamera(mapCamera, animated: animated)
    }
    
    func centerMapOn(location coordinateLocation: Coordinates, animated: Bool) {
        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude, coordinateLocation.longitude)
        
        setCenter(mapCenter, animated: animated)
    }
    
    func clearPin() {
        removeAnnotations(annotations)
    }
}

extension CLLocationCoordinate2D {
    init(_ coordinates: Coordinates) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
