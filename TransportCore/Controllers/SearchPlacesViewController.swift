import UIKit

import CoreLocation

class SearchPlacesViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var searchResults: [Location] = []
    private var searchTask: DispatchWorkItem?
    
    private let viewModel: ViewModel
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private var lastSearchText: String = ""
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.updateLegend(with: .start)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var emptyStateViewBottomConstraint: NSLayoutConstraint!
    
    init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        setupLocationManager()
        setupEmptyStateView()
        setupKeyboardObservers()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "¿A dónde vas?"
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        
        emptyStateViewBottomConstraint = emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateViewBottomConstraint
        ])
        
        emptyStateView.isHidden = false
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        emptyStateViewBottomConstraint.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    private func addHideKeyboardButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let hideButton = UIBarButtonItem(title: "Colapsar teclado", style: .done, target: self, action: #selector(hideKeyboard))
        
        toolbar.items = [flexSpace, hideButton]
        searchBar.inputAccessoryView = toolbar
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHideKeyboardButton()
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        emptyStateViewBottomConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.searchPlacesUsingGMaps(query: searchText)
        }
        searchTask = task
        lastSearchText = searchText
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: task)
    }
    
    private func searchPlacesUsingGMaps(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            tableView.reloadData()
            updateEmptyStateView()
            return
        }
        
        let apiKey = "AIzaSyBJU0uAbjQcMw5LP25RLLbx06olYED7vQk"
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]] {
                    self?.searchResults = results.compactMap { result in
                        if let geometry = result["geometry"] as? [String: Any],
                           let location = geometry["location"] as? [String: Any],
                           let lat = location["lat"] as? Double,
                           let lng = location["lng"] as? Double,
                           let name = result["name"] as? String,
                           let address = result["formatted_address"] as? String {
                                let location = CLLocation(latitude: lat, longitude: lng)
                                let distance = self?.currentLocation?.distance(from: location) ?? 0.0
                                return Location(latitude: lat, longitude: lng, name: name, address: address, distance: distance)
                            }
                        return nil
                    }
                    self?.sortSearchResultsByDistance()
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.updateEmptyStateView()
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func sortSearchResultsByDistance() {
        guard let currentLocation = currentLocation else { return }
        
        searchResults.sort { (location1, location2) -> Bool in
            let loc1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
            let loc2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
            return currentLocation.distance(from: loc1) < currentLocation.distance(from: loc2)
        }
    }
    
    private func updateEmptyStateView() {
        emptyStateView.isHidden = !searchResults.isEmpty
        emptyStateView.updateLegend(with: searchResults.isEmpty && !lastSearchText.isEmpty ? .noSearchResults : .start)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        guard indexPath.row < searchResults.count else { return UITableViewCell() }
        let location = searchResults[indexPath.row]
        cell.configure(with: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = searchResults[indexPath.row]
        self.dismiss(animated: true)
        viewModel.didSelectALocation?(selectedPlace)
    }
}

extension SearchPlacesViewController {
    
    struct Location {
        let latitude: Double
        let longitude: Double
        let name: String
        let address: String
        let distance: Double
        
        init(latitude: Double, longitude: Double, name: String, address: String, distance: Double) {
            self.latitude = latitude
            self.longitude = longitude
            self.name = name
            self.address = address
            self.distance = distance
        }
    }
    
    class ViewModel {
        var didSelectALocation: ((Location) -> Void)?
        
        init() { }
    }
}
