//
//  BathroomAnnotation.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/17/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import MapKit

class BathroomAnnocatation : MKPointAnnotation {
    let id: Int
    let bathroom : Bathroom
    
    init(coordinate: CLLocationCoordinate2D, id: Int, bathroom : Bathroom) {
        self.id = id
        self.bathroom = bathroom
        super.init()
        self.coordinate = coordinate
    }
}
