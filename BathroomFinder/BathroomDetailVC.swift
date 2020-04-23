//
//  BathroomDetailVC.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/19/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import UIKit


import MapKit

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
    @IBOutlet var minimap : MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let bathroom = bathroom {
            let id = bathroom.id ?? 0
            name.text = bathroom.name ?? "Bathroom # \(id)"
            
            if let dis = bathroom.distance {
                let roundedDis = round((dis)*100)/100
                distance.text = "\(roundedDis) miles away"
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
                accessibleImage.isHighlighted = false
            }
            
            if let unisex = bathroom.unisex {
                //print("unisex is: \(unisex)")
                if (unisex) { unisexImage.tintColor = .systemIndigo
                } else { unisexImage.tintColor = .systemGray }
                unisexImage.isHighlighted = unisex
            } else {
                unisexImage.isHighlighted = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minimap.delegate = self
        centerOnMap()
    }
    
    func centerOnMap() {
        let lat : Double?  =  bathroom.latitude
        let lng : Double? = bathroom.longitude
        guard let mlat = lat else {return}
        guard let mlng = lng else {return}
        let location = CLLocationCoordinate2D(latitude: mlat, longitude: mlng)
        let regionRadius : CLLocationDistance = 100
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        minimap.setRegion(region, animated: false)
    }
}

extension BathroomDetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "BathroomAnnotationIdentifier"
        guard let brAnnotation = annotation as? BathroomAnnocatation else { return nil }
        
        var annotationView : MKAnnotationView?
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
            annotationView?.annotation = brAnnotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named:"brIcon")
        }
        return annotationView
    }
}
