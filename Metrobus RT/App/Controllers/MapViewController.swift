//
//  MapViewController.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import CoreLocation
import Combine

class MapViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    private lazy var mapView: AppleMapView = {
        let view = AppleMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureTapGestureRecognizers()
        
        view.isZoomEnabled = true
        view.isPitchEnabled = true
        
        view.centerMapOn(location: locationCoordinates, animated: true)
        view.centerCameraOn(location: locationCoordinates, animated: true)
        
        return view
    }()
    
    private let locationCoordinates: Coordinates
    private let apiDevProvider: APIDevProvider
    private let linesGeometryDataSource: LinesGeometryDataSource
        
    private var stations = [Station]()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        return locationManager
    }()
    
    private let viewModel: ViewModel
    
    init(location: Coordinates, apiDevProvider: APIDevProvider, linesGeometryDataSource: LinesGeometryDataSource) {
        self.locationCoordinates = location
        self.apiDevProvider = apiDevProvider
        self.linesGeometryDataSource = linesGeometryDataSource
        self.viewModel = ViewModel(with: apiDevProvider)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureMapViewHierachy()
        bindViewModel()
                
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLinesData()
        fetchLinesGeometryData()
    }
    
    private func configureNavigationBar() {
        let nav = navigationController?.navigationBar
        
        nav?.isTranslucent = false
        nav?.setBackgroundImage(UIImage(named: "nav-bar-bg"), for: .default)
        nav?.shadowImage = UIImage(named: "shadow-bar-bg")
        nav?.backgroundColor = UIColor.metrobus
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "nav-bar-logo")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "locate-me"), style: .plain, target: self, action: #selector(determineMyCurrentLocation))
        nav?.tintColor = .white
    }
    
    private func configureMapViewHierachy() {
        
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: mapView.topAnchor),
            view.bottomAnchor.constraint(equalTo: mapView.bottomAnchor)
        ])
        
    }
    
    private func fetchLinesData() {
        let hud = MBProgressHUD(view: view)
        hud.show(animated: true)
        
        if stations.isEmpty {
            apiDevProvider.allLines(completion: { lines in
                lines.forEach({ line in
                    line.stations.forEach { [weak self] station in
                        
                        guard let self = self else { return }
                        self.mapView.addPinToMap(at: station, title: station.name, isUnique: false)
                        self.stations.append(station)
                    }
                })
                hud.hide(animated: true)
            }) { [weak self] in
                
                guard let self = self else { return }
                
                hud.hide(animated: true)
                self.displayFailedFetchingLinesErrorAlert()
            }
        }
    }
    
    var busPanelView: BusPanelView?
    
    func configureBusPanelView() {
        guard busPanelView == nil else { return }
        
        busPanelView = BusPanelView()
        
        guard let busPanelView = busPanelView else { return }
        
        mapView.addSubview(busPanelView)
        
        busPanelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.bottomAnchor.constraint(equalTo: busPanelView.bottomAnchor, constant: 80),
                                     busPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     view.trailingAnchor.constraint(equalTo: busPanelView.trailingAnchor, constant: 20)])
    }
    
    func bindViewModel() {
        viewModel.$selectedStation.sink { station in
            guard let station = station else { return }
            
            self.configureBusPanelView()
            
            self.busPanelView?.configureHeaderWith(stationName: station.name, lineName: station.lineName)
        }.store(in: &cancellables)
        
        viewModel.$availableBuses.sink { buses in
            if buses.isEmpty { return }

            self.configureBusPanelView()
            
            self.busPanelView?.configureWith(buses: buses)
        }.store(in: &cancellables)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        busPanelView?.setColors()
    }
    
    private func displayFailedFetchingLinesErrorAlert() {
        let alert = UIAlertController(title: "Ujule", message: "No pudimos descargar el mapa de las líneas. Revisa tu conexión a internet.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Intentar de nuevo", style: .default, handler: { action in
            self.fetchLinesData()
        }))
        
        self.present(alert, animated: true)
    }
    
    private func displayFailedFetchingStationErrorAlert() {
        let alert = UIAlertController(title: "Ujule", message: "No pudimos cargar la info de esta estación", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func displayEmptyBusesAlert() {
        let alert = UIAlertController(title: "Aviso", message: "No hay autobuses llegando a esta estación en este momento", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func fetchLinesGeometryData() {
        linesGeometryDataSource.allLinesPaths { lines in
            
            lines.forEach({ line in
                
                line.paths.forEach({ paths in
                    var locations = [Coordinates]()

                    paths.forEach({ coordinates in
                        if let latitude = coordinates.first, let longitude = coordinates.last {
                            locations.append(Location(latitude: latitude, longitude: longitude))
                        }
                        self.mapView.addRouteToMap(with: locations, title: "\(line.number)")

                    })
                    
                })
                
            })
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) { }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        busPanelView?.removeFromSuperview()
        busPanelView = nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let coordinate = view.annotation?.coordinate else {
            return
        }

        // TODO: Improve centering on poi
        self.mapView.centerCameraOn(location: Location(latitude: coordinate.latitude, longitude: coordinate.longitude), animated: true)
        guard let station = stations.first(where: { $0.equals(to: coordinate) }) else { return }
        
        viewModel.fetchStationData(at: station)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            
            testlineRenderer.strokeColor = LineView.colorForLine(with: polyline.title)
            testlineRenderer.lineWidth = 2.0
            return testlineRenderer
        }
        return MKOverlayRenderer()
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    @objc func determineMyCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.centerMapOnUserLocation()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension Station {
    func equals(to coordinate: CLLocationCoordinate2D) -> Bool {
        return self.longitude == coordinate.longitude && self.latitude == coordinate.latitude
    }
}
