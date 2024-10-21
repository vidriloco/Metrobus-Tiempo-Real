//
//  MapViewController.swift
//  Metrobus RT
//
//  Created by Alejandro on 4/2/19.
//  Copyright © 2019 El Chahuistle. All rights reserved.
//

import UIKit
import CoreLocation
import WebKit
import StoreKit
import AppReview

class MapViewController: UIViewController, WKNavigationDelegate, CLLocationManagerDelegate {
    var webView: WKWebView!
    
    // Add a button to center the user on the map
    /*let centerUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.setTitle("Center User", for: .normal)
        button.addTarget(self, action: #selector(centerUserOnMap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()*/
    
    var locationManager: CLLocationManager!
    let loadingIndicator = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the web view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Add a loading indicator
        // Add a text label above the loading indicator
        loadingLabel.text = "Cargando el mapa"
        loadingLabel.font = .systemFont(ofSize: 15, weight: .bold)
        loadingLabel.textColor = .gray
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingLabel)
        
        // Add a loading indicator
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        // Set up auto layout constraints for the loading label
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: loadingIndicator.topAnchor, constant: -20)
        ])
        
        // Stop the loading indicator when the page finishes loading
        webView.navigationDelegate = self
        
        // Set up auto layout constraints
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Add the center user button to the view
        /*view.addSubview(centerUserButton)
        NSLayoutConstraint.activate([
            centerUserButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            centerUserButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            centerUserButton.widthAnchor.constraint(equalToConstant: 100),
            centerUserButton.heightAnchor.constraint(equalToConstant: 50)
        ])*/
        
        // Load a URL
        if let url = URL(string: "https://wikiando.mx/mobile") {
            webView.load(URLRequest(url: url))
        }
        
        AppReview.requestIf(launches: 3, days: 3)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        loadingLabel.removeFromSuperview()
    }
    
    func showRateUsPrompt() {
        let alert = UIAlertController(title: "Rate Us", message: "If you enjoy using our app, would you mind taking a moment to rate us? Your feedback helps us improve!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Rate Now", style: .default, handler: { _ in
            self.requestAppReview()
        }))
        
        alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func requestAppReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }

    @objc func centerUserOnMap() {
        // Implement the logic to center the user on the map
        print("Centering user on the map...")
        
        // Check if location services are enabled
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }
        
        // Request the current location
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted")
            case .denied, .restricted:
                print("Location access denied/restricted")
            case .notDetermined:
                print("Location access not determined")
            @unknown default:
                print("Unknown location authorization status")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            let coordinate = currentLocation.coordinate
            print("User's current location: \(coordinate.latitude), \(coordinate.longitude)")
            
            // Center the map on the user's location
            //let center = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            // Center the Mapbox map on the user's location using JavaScript
            let jsCode = "map.setCenter([\(coordinate.longitude), \(coordinate.latitude)]);"
            webView.evaluateJavaScript(jsCode) { (result, error) in
                if let error = error {
                    print("Failed to set map center: \(error.localizedDescription)")
                } else {
                    print("Map center set successfully")
                }
            }
        } else {
            print("Unable to retrieve user's current location")
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}
