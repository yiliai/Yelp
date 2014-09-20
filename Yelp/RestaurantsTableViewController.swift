//
//  RestaurantsTableViewController.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/17/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let kYelpConsumerKey = NSString(string: "vxKwwcR_NMQ7WaEiQBK_CA")
let kYelpConsumerSecret = NSString(string: "33QCvh5bIF5jIHR5klQr7RtBDhQ")
let kYelpToken = NSString(string: "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV")
let kYelpTokenSecret = NSString(string: "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y")

class RestaurantsTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var restaurantsTableView: UITableView!
    var client = YelpClient()
    var restaurantsArray = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let restaurantCellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil);
        restaurantsTableView.registerNib(restaurantCellNib, forCellReuseIdentifier: "restaurantCell")
        
        restaurantsTableView.estimatedRowHeight = 200
        restaurantsTableView.rowHeight = UITableViewAutomaticDimension
        restaurantsTableView.separatorStyle = .None
        
        loadYelpData()
        
        NSLog("hello!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return restaurantsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as RestaurantTableViewCell
        let restaurant = restaurantsArray[indexPath.row]
        
        cell.restaurantNameLabel.text = String(indexPath.row+1) + ". " + restaurant.name
        cell.restaurantNameLabel.sizeToFit()
        fadeInImageFromURL(cell.restaurantImage, url: restaurant.imageURL)
        cell.setRatingImage(restaurant.ratingImageURL)
        
        cell.setReviewCount(restaurant.reviewCount)
        cell.setAddress(restaurant.location.address, neighborhoods: restaurant.location.neighborhoods)
        cell.setCategories(restaurant.categories)
        
        cell.distanceLabel.frame = CGRectMake (100,0,50,50)
        cell.distanceLabel.text = "0.3mi"
        cell.distanceLabel.sizeToFit()
        cell.distanceLabel.hidden = false
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    func loadYelpData() {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = YelpClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
        
        self.client.searchWithTerm("restaurant",
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
                if let resultsArray = response["businesses"] as [NSDictionary]? {
                    for result in resultsArray {
                        self.restaurantsArray.append(Restaurant(dictionary: result))
                    }
                    //self.printRestaurantsArray(self.restaurantsArray)
                    NSLog ("Data loaded...")
                    self.restaurantsTableView.reloadData()
                }
            }) { (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                NSLog("error: \(error.description)");
        }
    }
    
    func printRestaurantsArray(restaurants: [Restaurant]) {
        for restaurant in restaurants {
            NSLog(restaurant.description)
        }
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
