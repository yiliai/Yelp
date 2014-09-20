//
//  RestaurantTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/17/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setReviewCount(count: Int) {
        if (count <= 0) {
            self.reviewCountLabel.text = "No Reviews"
        }
        else if (count == 1) {
            self.reviewCountLabel.text = "1 Review"
        }
        else {
            self.reviewCountLabel.text = String(count) + " Reviews"
        }
    }
    
    func setAddress(address: [String], neighborhoods: [String]) {
        var displayAddress = ""
        for line in address {
            if (displayAddress != "") {
                displayAddress += ", "
            }
            displayAddress += line
        }
        // Add the first neighborhood in the list
        if neighborhoods.count != 0 {
            if (displayAddress != "") {
                displayAddress += ", "
            }
            displayAddress += neighborhoods[0] + " "
        }
        self.addressLabel.text = displayAddress
    }
    
    func setCategories(categories: [(displayName: String, id: String)]) {
        var displayCategories = ""
        for category in categories {
            if (displayCategories != "") {
                displayCategories += ", "
            }
            displayCategories += category.displayName
        }
        self.categoriesLabel.text = displayCategories
    }
    
    func setRatingImage(ratingImageURL: NSURL) {
        var ratingImage = UIImageView()
        ratingImage.setImageWithURL(ratingImageURL)
        ratingView.addSubview(ratingImage)
    }
}
