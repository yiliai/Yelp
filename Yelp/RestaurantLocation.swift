//
//  RestaurantLocation.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

class RestaurantLocation {
    
    var dictionaryReference = NSDictionary()

    var address = [String]()
    var city = String()
    var coordinate = (lat: String(), long: String())
    var neighborhoods = [String]()
    var postal_code = Int()
    var state_code = String()
    
    init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.dictionaryReference = dictionary
        
        // Get the address
        if let address = dictionary["address"] as [String]? {
            self.address = address
        }
        // Get the neighborhoods
        if let neighborhoods = dictionary["neighborhoods"] as [String]? {
            self.neighborhoods = neighborhoods
        }
    }
}