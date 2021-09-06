//
//  LocationSearchViewController.swift
//  lesson17
//
//  Created by Đại Nguyễn  on 9/1/21.
//

import UIKit
import MapKit


class LocationSearchViewController: UIViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var selectedPin:MKPlacemark? = nil

    var handleMapSearchDelegate:HandleMapSearch? = nil

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LocationSearchCell", bundle: nil), forCellReuseIdentifier: "LocationSearchCell")
    }

    
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as! LocationSearchCell
        
        let place = matchingItems[indexPath.row].placemark
        cell.nameLabel.text = place.name
        cell.locate.text = place.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //zoom, switch to map view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }

    }
}
