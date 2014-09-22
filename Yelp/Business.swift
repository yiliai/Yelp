//
//  Business.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/17/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

class Business {

    var dictionaryReference = NSDictionary()
    
    var categories = [(displayName: String(), id: String())]
    var displayPhone = String()
    //var id = String()
    var imageURL = NSURL()
    var location = BusinessLocation()
    var name = String()
    var rating = Int()
    var ratingImageURL = NSURL()
    var reviewCount = Int()
    
    init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.dictionaryReference = dictionary
        // Get categories from dictionary
        if let categories = dictionary["categories"] as NSArray? {
            for category in categories {
                if let categoryArray = category as? NSArray {
                    let name = categoryArray[0] as String
                    let id = categoryArray[1] as String
                    self.categories += [(displayName: name, id: id)]
                }
            }
        }
        // Get the phone number
        if let displayPhone = dictionary["diplay_phone"] as NSString? {
            self.displayPhone = String(displayPhone)
        }
        // Get the image URL
        if let imageURL = dictionary["image_url"] as NSString? {
            self.imageURL = NSURL(string: imageURL)
        }
        // Get the location
        if let locationDictionary = dictionary["location"] as NSDictionary? {
            self.location = BusinessLocation(dictionary: locationDictionary)
        }
        // Get the name
        if let name = dictionary["name"] as NSString? {
            self.name = String(name)
        }
        // Get the rating
        if let rating = dictionary["rating"] as NSNumber? {
            self.rating = rating
        }
        // Get the rating image URL
        if let ratingImageURL = dictionary["rating_img_url_large"] as NSString? {
            self.ratingImageURL = NSURL(string: ratingImageURL)
        }
        // Get the review count
        if let reviewCount = dictionary["review_count"] as NSNumber? {
            self.reviewCount = reviewCount
            reviewCount.description
        }
    }
    
    var description: String {
        get {
            return self.name
        }
    }
    
    
}