//
//  BathroomAnnotation.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/17/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import MapKit

class BathroomAnnocatation : MKPointAnnotation {
    var id: Int
    init(coordinate: CLLocationCoordinate2D, id: Int) {
        self.id = id
        super.init()
        self.coordinate = coordinate
    }
}
