//
//  BathroomDetailVC.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/19/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import UIKit

//
//let id : Int?
//let name : String?
//let street : String?
//let city : String?
//let state : String?
//let accessible : Bool?
//let unisex : Bool?
//let directions : String?
//let latitude : Double?
//let longitude : Double?
//let distance : Double?

class BathroomDetailVC : UIViewController {
    
    var bathroom : Bathroom!
    @IBOutlet var name : UILabel!
    @IBOutlet var distance : UILabel!
    @IBOutlet var address : UILabel!
    @IBOutlet var upvotes : UILabel!
    @IBOutlet var direction : UILabel!
    @IBOutlet var comment : UILabel!
    @IBOutlet var accessibleImage : UIImageView!
    @IBOutlet var unisexImage : UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let bathroom = bathroom {
            name.text = bathroom.name ?? "Untitled"
            if let dis = bathroom.distance {
                let roundedDis = round((dis)*100)/100
                distance.text = String(roundedDis)
            } else {
                distance.text = ""
            }
            let addr = "\(bathroom.street ?? " ") \(bathroom.city ?? " ") \(bathroom.state ?? " ") "
            address.text = addr
            
            upvotes.text = String(bathroom.upvote ?? 0)
            
            direction.text = bathroom.directions
            comment.text = bathroom.comment ?? "There are no comments for this bathroom"
            
            if let acc = bathroom.accessible {
                //print("acc is: \(acc)")
                if (acc) { accessibleImage.tintColor = .systemIndigo
                } else { accessibleImage.tintColor = .systemGray }
                accessibleImage.isHighlighted = acc
            } else {
                accessibleImage.isHighlighted = false;
                //accessibleImage.image = UIImage(named: "xmark.circle")
            }
            
            if let unisex = bathroom.unisex {
                //print("unisex is: \(unisex)")
                if (unisex) { unisexImage.tintColor = .systemIndigo
                } else { unisexImage.tintColor = .systemGray }
                unisexImage.isHighlighted = unisex
            } else {
                unisexImage.isHighlighted = false;
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
