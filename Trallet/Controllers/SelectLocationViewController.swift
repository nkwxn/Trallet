//
//  SelectLocationViewController.swift
//  Trallet
//
//  Created by Nicholas on 10/05/21.
//

import UIKit
import MapKit

class SelectLocationViewController: UIViewController, MaskedCorner {
    
    // Outlet for Map View
    @IBOutlet weak var pinMapView: MKMapView!
    
    // Location Manager to get location
    let locationManager = CLLocationManager()
    
    // Outlet for search bar
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarLocation: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    // Value to show on Search Result
    var searchResultArr = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.maskTopOnlyRoundedCorner(for: searchView)
        
        // Delegate Setup
        searchBarLocation.delegate = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        // Location Setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        self.searchViewHeight.constant = self.searchView.layoutMargins.top + searchBarLocation.frame.height + view.safeAreaInsets.bottom
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadSearch(for searchQuery: String) {
        
    }
}

// MARK: - Search Bar Delegate
extension SelectLocationViewController: UISearchBarDelegate {
    
    // Search bar starts editing -> change height to full
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.searchViewHeight.constant = self.view.safeAreaLayoutGuide.layoutFrame.size.height + self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // When we edit, change the tableview content for search result
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        
        if searchText == "" {
            self.searchResultArr.removeAll()
            self.searchResultTableView.reloadData()
        } else {
            // Load / Update Search Result
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = pinMapView.region
            
            // Get the search result
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else { return }
                
                self.searchResultArr = response.mapItems
                self.searchResultTableView.reloadData()
                
                // input annotation on map
            }
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            // When search query is empty
            if searchBar.text != "" && self.searchResultArr.count != 0 {
                self.searchViewHeight.constant = self.view.safeAreaLayoutGuide.layoutFrame.size.height / 2.0
            } else {
                self.searchViewHeight.constant = self.searchView.layoutMargins.top + self.searchBarLocation.frame.height + self.view.safeAreaInsets.bottom
                self.searchResultArr.removeAll()
                self.searchResultTableView.reloadData()
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Location Manager Delegate
extension SelectLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            pinMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

// MARK: - TableView Delegate and Data Source
extension SelectLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell data for location name and adress
        let cellData = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        let locationData = searchResultArr[indexPath.row]
        
        guard let locationName = locationData.name,
              let locationAddress = locationData.placemark.title else { return cellData }
        
        cellData.textLabel?.text = locationName
        cellData.detailTextLabel?.text = locationAddress
        return cellData
    }
    
    // When row selected, bring back the map variable to the prev view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
