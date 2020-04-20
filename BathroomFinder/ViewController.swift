//
//  ViewController.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/13/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Bathroom : Codable {
    let id : Int?
    let name : String?
    let street : String?
    let city : String?
    let state : String?
    let accessible : Bool?
    let unisex : Bool?
    let directions : String?
    let comment : String?
    let latitude : Double?
    let longitude : Double?
    let distance : Double?
    let upvote : Int?
}

class ViewController: UIViewController {
    
    @IBOutlet var mapview : MKMapView!
    
    let locationManager = CLLocationManager()
    
    var apiReqLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var myBathrooms : [BathroomAnnocatation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        checkLocationServices()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // something
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch  CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Show user location on map
            mapview.showsUserLocation = true
            centerMapOnPerson()
            break
        case .denied:
            // Show alert instructing how to turn on permission
            break
        case .notDetermined:
            // Request permission
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func centerMapOnPerson() {
        if let location = locationManager.location?.coordinate {
            let regionRadius : CLLocationDistance = 1000
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapview.setRegion(region, animated: true)
            makeAPIRequest(at: location, accessible: false, unisex: false, limit: 20)

        }
    }
    
    func makeAPIRequest(at position: CLLocationCoordinate2D, accessible : Bool, unisex : Bool, limit : Int) {
        let numPages = 1;
        let offset = 0;
        let lat : Double = position.latitude
        let lng : Double = position.longitude
        
        let urlString = "https://www.refugerestrooms.org/api/v1/restrooms/by_location?page=\(numPages)&per_page=\(limit)&offset=\(offset)&ada=\(accessible)&unisex=\(unisex)&lat=\(lat)&lng=\(lng)"
        
        guard let url = URL(string: urlString) else {return}
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode([Bathroom].self, from: data) {
                    //print(1)
                    //dump(decodedResponse)
                    for br : Bathroom in decodedResponse {
                        if let lat = br.latitude, let lng = br.longitude, let brId = br.id {
                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            let newBr = BathroomAnnocatation(coordinate: coord, id: brId, bathroom: br)
                            self.myBathrooms.append(newBr)
                        }
                    }
                    // update APIreqLocation
                    self.apiReqLocation = position
                    DispatchQueue.main.async {
                        self.mapview.removeAnnotations(self.mapview.annotations)
                        self.mapview.addAnnotations(self.myBathrooms)
                    }
                } else {
                    print("failed trying to decode data")
                }
            }
        }
        task.resume();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BathroomDetailVC_Seg" {
            if let sender = sender as? MKAnnotationView {
                if let annotation = sender.annotation as? BathroomAnnocatation {
                    if let bathroomDetailVC = segue.destination as? BathroomDetailVC {
                        bathroomDetailVC.bathroom = annotation.bathroom;
                        print("yo1")
                    }
                }
            }
        }
    }
}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
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
            let label = UILabel()
            label.text = "Bathroom \(brAnnotation.id)"
            annotationView.detailCalloutAccessoryView = label
            annotationView.image = UIImage(named:"brIcon")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("yo3")
        self.performSegue(withIdentifier: "BathroomDetailVC_Seg", sender: view)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let regionRadius : CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapview.setRegion(region, animated: true)
        makeAPIRequest(at: center, accessible: false, unisex: false, limit: 20)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

