//
//  DataManager.swift
//  BathroomFinder
//
//  Created by Kaiying on 4/22/20.
//  Copyright © 2020 Kaiying. All rights reserved.
//

import MapKit

class DataManger {
    
    static let shared : DataManger = DataManger()
    private var userCoord : CLLocation
    private var myBathrooms : [Bathroom]
    
    init() {
        userCoord = CLLocation(latitude: 0, longitude: 0);
        myBathrooms = []
    }
    
    func setUserCoord(_ location : CLLocation) {
        userCoord = location
    }
    
    func getUserCoord() -> CLLocation {
        return userCoord
    }
    
    func getBathrooms() -> [Bathroom] {
        return myBathrooms
    }
    
    func getBathroomCount() -> Int {
        return myBathrooms.count
    }
    
    func getBathroom(at index: Int) -> Bathroom {
        return myBathrooms[index]
    }
    
    func makeAPIRequest(at position: CLLocationCoordinate2D, accessible : Bool, unisex : Bool, limit : Int, calling: @escaping () -> ()) {
        let numPages = 1;
        let offset = 0;
        let lat : Double = position.latitude
        let lng : Double = position.longitude
        
        let urlString = "https://www.refugerestrooms.org/api/v1/restrooms/by_location?page=\(numPages)&per_page=\(limit)&offset=\(offset)&ada=\(accessible)&unisex=\(unisex)&lat=\(lat)&lng=\(lng)"
        
        guard let url = URL(string: urlString) else {return}
        //print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decodedResponse = try?
                    JSONDecoder().decode([Bathroom].self, from: data) {
                    //print(1)
                    //dump(decodedResponse)
                    self.myBathrooms = decodedResponse
                    DispatchQueue.main.async {
                        calling()
                    }
                } else {
                    print("failed trying to decode data")
                }
            }
        }
        task.resume();
    }
}
