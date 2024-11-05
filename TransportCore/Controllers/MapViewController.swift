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
import TransportCore
import GoogleMobileAds

class MapViewController: UIViewController, WKNavigationDelegate, CLLocationManagerDelegate {
    
    // Add a button to center the user on the map
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "search-icon"), for: .normal)
        button.addTarget(self, action: #selector(displaySearchList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.opacity = 0
        return button
    }()
    
    lazy var adView: GADBannerView = {
        let bannerView = GADBannerView(adSize: GoogleMobileAds.GADAdSize())
        bannerView.adUnitID = "ca-app-pub-9711213702831051/6903737194"
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.isHidden = true
        return bannerView
    }()
    
    let webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        
        return webView
    }()
    
    var locationManager: CLLocationManager!
    var loadingBackground: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "metrobus-wikiando")
        view.contentMode = .scaleAspectFill
        return view
    }()

    var loadingIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        }
        
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        webView.navigationDelegate = self

        // Load a URL
        if let url = viewModel.flavor.url {
            webView.load(URLRequest(url: url))
        }
        
        AppReview.requestIf(launches: 3, days: 3)
        
        adView.load(GADRequest())
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingBackground.removeFromSuperview()
        loadingIndicator.stopAnimating()
        searchButton.layer.opacity = 1
        webView.isHidden = false
        adView.isHidden = false
    }
    
    func configureViews() {
        view.addSubview(loadingBackground)
        view.addSubview(webView)
        view.addSubview(adView)
        
        // Set up auto layout constraints for the loading label
        NSLayoutConstraint.activate([
            loadingBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingBackground.topAnchor.constraint(equalTo: view.topAnchor),
            loadingBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: adView.topAnchor),
            adView.heightAnchor.constraint(equalToConstant: 0),
            adView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            adView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        loadingIndicator.startAnimating()

        // Add the center user button to the view
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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

    @objc func displaySearchList() {
        let viewModel = SearchPlacesViewController.ViewModel()
        viewModel.didSelectALocation = { [weak self] location in
            guard let self = self else { return }
            let jsCode = """
               collapseLayersMenu();
               clearSelectionData();

               var newCenter = [\(location.longitude), \(location.latitude)]; 
               map.flyTo({ center: newCenter, zoom: 15, duration: 1500 });
               drawPolygonForFeature({lat: newCenter[1], lng: newCenter[0]}, 20); 
            """
            
            self.webView.evaluateJavaScript(jsCode) { (result, error) in
                if let error = error {
                    print("Failed to set map center: \(error.localizedDescription)")
                } else {
                    print("Map center set successfully")
                }
            }
        }
        
        let searchViewController = SearchPlacesViewController(with: viewModel)
        searchViewController.modalPresentationStyle = .popover
        searchViewController.modalTransitionStyle = .coverVertical
        present(searchViewController, animated: true, completion: nil)
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

extension MapViewController {
    class ViewModel {
        let flavor: Flavor
        
        init(flavor: Flavor) {
            self.flavor = flavor
        }
    }
}

public protocol Flavor {
    var url: URL? { get }
}
