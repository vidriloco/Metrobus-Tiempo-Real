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
    
    private var allowedAltitudeRange = CLLocationDistance(9000)...CLLocationDistance(15000)
    
    var mapDelegate: GenericMapDelegate?
    
    func configureTapGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        let doubletapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
        doubletapGestureRecognizer.numberOfTapsRequired = 2
        doubletapGestureRecognizer.cancelsTouchesInView = false
        
        tapGestureRecognizer.require(toFail: doubletapGestureRecognizer)
        
        addGestureRecognizer(tapGestureRecognizer)
        addGestureRecognizer(doubletapGestureRecognizer)
        showsUserLocation = true
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
        
        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude, coordinateLocation.longitude)
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
    
    func addRouteToMap(with coordinates: [Coordinates], title: String) {
        let polyline = MKPolyline(coordinates: coordinates.map({ CLLocationCoordinate2DMake(CLLocationDegrees($0.latitude), CLLocationDegrees($0.longitude)) }), count: coordinates.count)
        polyline.title = title
        self.addOverlay(polyline)
    }
    
    func centerMapOnUserLocation() {
        let coordinates = Location(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        self.centerCameraOn(location: coordinates, animated: true)
    }
}

extension CLLocationCoordinate2D {
    init(_ coordinates: Coordinates) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
