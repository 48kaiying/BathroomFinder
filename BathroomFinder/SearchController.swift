//
//  SeachController.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/23/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import UIKit
import MapKit

protocol HandleSearchDelegate {
    func searchFound(_ MKitem : MKPlacemark, _ name : String)
}

class SearchController : UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    
    var delegate : HandleSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        
        if let name = cell.viewWithTag(20) as? UILabel {
            name.text = selectedItem.name
        }
        if let des = cell.viewWithTag(21) as? UILabel {
            des.text = getAddress(selectedItem)
        }
        return cell
    }
    
    func getAddress(_ selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        let name = selectedItem.name ?? ""
        delegate?.searchFound(selectedItem, name)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = DataManger.shared.getRegion()
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
