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
    @IBOutlet var adaButton : UIButton!
    @IBOutlet var uButton : UIButton!
    
    var selectedBathroom : Bathroom! = nil
    
    override func viewDidLoad() {
        setUpTableView()
        self.uButton.setTitleColor(.systemGray, for: .normal)
        self.uButton.backgroundColor = .white
        self.adaButton.setTitleColor(.systemGray, for: .normal)
        self.adaButton.backgroundColor = .white
        DataManger.shared.makeAPIRequest(calling: {
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
    
    @IBAction func onClick(_ sender: UIButton) {
        if (sender == self.adaButton) {
            let highlighted = DataManger.shared.toggleAda();
            DataManger.shared.makeAPIRequest(calling: {
                if (highlighted) {
                    self.adaButton.setTitleColor(.white, for: .normal)
                    self.adaButton.backgroundColor = .systemIndigo
                } else {
                    self.adaButton.setTitleColor(.systemGray, for: .normal)
                    self.adaButton.backgroundColor = .white
                }
                // todo loading sign or something
                self.tableview.reloadData()
            })
        } else if (sender == self.uButton) {
            let highlighted = DataManger.shared.toggleUnisex();
            DataManger.shared.makeAPIRequest(calling: {
                if (highlighted) {
                    self.uButton.setTitleColor(.white, for: .normal)
                    self.uButton.backgroundColor = .systemIndigo
                } else {
                    self.uButton.setTitleColor(.systemGray, for: .normal)
                    self.uButton.backgroundColor = .white
                }
                // todo loading sign or something
                self.tableview.reloadData()
            })
        }
    }
}
