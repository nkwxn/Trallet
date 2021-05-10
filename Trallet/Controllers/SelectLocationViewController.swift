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
    @IBOutlet weak var MapView: MKMapView!
    
    // Outlet for search bar
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarLocation: UISearchBar!
    @IBOutlet weak var searchResult: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.maskTopOnlyRoundedCorner(for: searchView)
        
        // Delegate Method Setup
        searchBarLocation.delegate = self
        searchResult.delegate = self
        searchResult.dataSource = self
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
        // Load search result
        print(String(describing: searchBar.text))
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            // When search query is empty
            if searchBar.text != "" {
                self.searchViewHeight.constant = self.view.safeAreaLayoutGuide.layoutFrame.size.height / 2.0
            } else {
                self.searchViewHeight.constant = self.searchView.layoutMargins.top + self.searchBarLocation.frame.height + self.view.safeAreaInsets.bottom
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel clicked")
    }
}

// MARK: - TableView Delegate and Data Source
extension SelectLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell data for location name and adress
        let cellData = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cellData.textLabel?.text = "Row Title #\(indexPath.row)"
        cellData.detailTextLabel?.text = "Row Desc #\(indexPath.row)"
        return cellData
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
