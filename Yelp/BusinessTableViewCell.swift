//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/17/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    let GRAY_TEXT_COLOR = UIColor(white: 0.53, alpha: 1.0)
    let SEPARATOR_COLOR = UIColor(white: 0.8, alpha: 0.5)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.distanceLabel.textColor = GRAY_TEXT_COLOR
        self.priceLabel.textColor = GRAY_TEXT_COLOR
        self.reviewCountLabel.textColor = GRAY_TEXT_COLOR
        self.categoriesLabel.textColor = GRAY_TEXT_COLOR
        self.separator.backgroundColor = SEPARATOR_COLOR

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
    
    func setImage(imageURL: NSURL) {
        self.businessImage?.layer.cornerRadius = 4
        self.businessImage?.layer.masksToBounds = true
        fadeInImageFromURL(self.businessImage, url: imageURL)
    }
    
    func setRatingImage(ratingImageURL: NSURL) {
        ratingImage.setImageWithURL(ratingImageURL)
    }
    
    func setBusinessName(number: Int, name: String) {
        self.businessNameLabel.text =  String(number) + ". " + name
        self.businessNameLabel.numberOfLines = 0
        self.businessNameLabel.sizeToFit()
    }
    func fadeInImageFromURL(imageView :UIImageView, url: NSURL) {
        let request = NSURLRequest(URL: url)
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            if (response == nil) {
                imageView.image = image
                return
            }
            imageView.alpha = 0.0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                imageView.image = image
                imageView.alpha = 1.0
            })
            }, failure: nil)
    }
}
