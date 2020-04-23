//
//  TableViewController.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/22/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    @IBOutlet var searchbar : UISearchBar!
    @IBOutlet var tableview : UITableView!
    
//    var myBathrooms : [Bathroom] = []
    var selectedBathroom : Bathroom! = nil
    
    override func viewDidLoad() {
        setUpTableView()
        DataManger.shared.makeAPIRequest(at: CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417), accessible: false, unisex: false, limit: 20, calling: {
//            self.myBathrooms = DataManger.dm.getBathrooms()
            self.tableview.reloadData()
        })
    }
    
    func setUpTableView() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // todo should be bathrooms.count
        return DataManger.shared.getBathroomCount();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bathroom = DataManger.shared.getBathroom(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrCell")!
        
        if let name = cell.viewWithTag(1) as? UILabel {
            name.text = bathroom.name ?? "Bathroom # \(String(describing: bathroom.id)) "
        }
        
        if let address = cell.viewWithTag(2) as? UILabel {
            address.text = "\(bathroom.street ?? " ") \(bathroom.city ?? " ") \(bathroom.state ?? " ") "
        }
        
        if let distance = cell.viewWithTag(3) as? UILabel {
            if let dis = bathroom.distance {
                let roundedDis = round((dis)*100)/100
                distance.text = "\(roundedDis)mi"
            } else {
                distance.text = ""
            }
        }
        
        // change to icons
//        if let accessible = cell.viewWithTag(4) as? UILabel {
//            var a = false;
//            if let acc = bathroom.accessible {
//                a = acc;
//            }
//            if (a) {
//                accessible.tintColor = .systemIndigo
//                accessible.text = "ADA Accessible"
//            } else {
//                accessible.tintColor = .systemGray
//                accessible.text = ""
//            }
//        }
//
//        if let unisex = cell.viewWithTag(5) as? UILabel {
//            var u = false;
//            if let uni = bathroom.unisex {
//                u = uni;
//            }
//            if (u) {
//                unisex.tintColor = .systemIndigo
//                unisex.text = "Unisex"
//            } else {
//                unisex.text = ""
//            }
//        }
        
        if let heart = cell.viewWithTag(7) as? UILabel {
            heart.text = "\(String(describing: bathroom.upvote)) ?? 0"
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedBathroom = DataManger.shared.getBathroom(at: indexPath.row)
        performSegue(withIdentifier: "TVCtoDVC_Seg", sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TVCtoDVC_Seg" {
            if let bathroomDetailVC = segue.destination as? BathroomDetailVC {
                bathroomDetailVC.bathroom = selectedBathroom;
            }
        }
    }
    
//    func makeAPIRequest(at position: CLLocationCoordinate2D, accessible : Bool, unisex : Bool, limit : Int) {
//        let numPages = 1;
//        let offset = 0;
//        let lat : Double = position.latitude
//        let lng : Double = position.longitude
//
//        let urlString = "https://www.refugerestrooms.org/api/v1/restrooms/by_location?page=\(numPages)&per_page=\(limit)&offset=\(offset)&ada=\(accessible)&unisex=\(unisex)&lat=\(lat)&lng=\(lng)"
//
//        guard let url = URL(string: urlString) else {return}
//
//        //print(url)
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                if let decodedResponse = try?
//                    JSONDecoder().decode([Bathroom].self, from: data) {
//                    //print(1)
//                    //dump(decodedResponse)
//                    self.myBathrooms = decodedResponse
//                    DispatchQueue.main.async {
//                        self.tableview.reloadData()
//                    }
//                } else {
//                    print("failed trying to decode data")
//                }
//            }
//        }
//        task.resume();
//    }
}
