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
        setUpButtonView(self.adaButton)
        setUpButtonView(self.uButton)
        DataManger.shared.makeAPIRequest(calling: {
            self.tableview.reloadData()
        })
    }
    
    func setUpButtonView(_ button: UIButton!) {
        if button == nil {return}
        button.layer.borderWidth = 1
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 3.0, bottom: 0.0, right: 3.0)
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.backgroundColor = .white
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 5
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
            let id = bathroom.id ?? 0
            name.text = bathroom.name ?? "Bathroom # \(id)"
        }
        
        //change to icons
        if let accessible = cell.viewWithTag(2) as? UIImageView {
            var a = false;
            if let acc = bathroom.accessible {
                a = acc;
            }
            if (a) {
                accessible.tintColor = .systemIndigo
            } else {
                accessible.tintColor = .systemGray
            }
            accessible.isHighlighted = a
        }

        if let unisex = cell.viewWithTag(3) as? UIImageView {
            var u = false;
            if let uni = bathroom.unisex {
                u = uni;
            }
            if (u) {
                unisex.tintColor = .systemIndigo
            } else {
                unisex.tintColor = .systemGray
            }
            unisex.isHighlighted = u
        }

        if let distance = cell.viewWithTag(5) as? UILabel {
            if let dis = bathroom.distance {
                let roundedDis = round((dis)*100)/100
                distance.text = "\(roundedDis)mi"
            } else {
                distance.text = ""
            }
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
                self.resetButtonView(highlighted: highlighted, self.adaButton)
                // todo loading sign or something
                self.tableview.reloadData()
            })
        } else if (sender == self.uButton) {
            let highlighted = DataManger.shared.toggleUnisex();
            DataManger.shared.makeAPIRequest(calling: {
                self.resetButtonView(highlighted: highlighted, self.uButton)
                // todo loading sign or something
                self.tableview.reloadData()
            })
        }
    }
    
    func resetButtonView(highlighted : Bool, _ button : UIButton!) {
        if button == nil {return}
        if (highlighted) {
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.systemIndigo.cgColor
            button.backgroundColor = .systemIndigo
        } else {
            button.setTitleColor(.systemGray, for: .normal)
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.backgroundColor = .white
        }
    }
}
