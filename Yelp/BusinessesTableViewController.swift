//
//  BusinessesTableViewController.swift
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

let YELP_RED = UIColor(red: 0.87, green: 0.08, blue: 0, alpha: 1.0)
let PADDING = CGFloat(10)
let DEFAULT_LOCATION = "San Francisco"
let LIMIT = 20

class BusinessesTableViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, FilterDelegate {

    @IBOutlet weak var businessesTableView: UITableView!
    var searchBar = UISearchBar()
    
    var client = YelpClient()
    var businessesArray = [Business]()
    var searchParameters = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Skin the navigation bar
        self.navigationController?.navigationBar.barTintColor = YELP_RED
        
        // Add the filter button on the left
        let filterButton = YelpButton(text: "Filter")
        filterButton.addTarget(self, action: "showFilterView", forControlEvents: UIControlEvents.TouchUpInside)
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        self.navigationItem.setLeftBarButtonItems([negativeSpacer, filterBarButton], animated: false)
    
        // Add the map button on the right
        let mapButton = YelpButton(text: "Map")
        mapButton.addTarget(self, action: "showMapView", forControlEvents: UIControlEvents.TouchUpInside)
        let mapBarButton = UIBarButtonItem(customView: mapButton)
        self.navigationItem.setRightBarButtonItems([negativeSpacer, mapBarButton], animated: false)
        
        // Setting up the table view and table cells
        let businessCellNib = UINib(nibName: "BusinessTableViewCell", bundle: nil);
        businessesTableView.registerNib(businessCellNib, forCellReuseIdentifier: "businessCell")
        businessesTableView.estimatedRowHeight = 75
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.separatorStyle = .None
        
        // Set up the last progress bar cell
        let progressCellNib = UINib(nibName: "ProgressTableViewCell", bundle: nil);
        businessesTableView.registerNib(progressCellNib, forCellReuseIdentifier: "progressCell")
        
        // Set up the search bar
        self.navigationItem.titleView = searchBar;
        searchBar.delegate = self
        searchYelp("restaurant")
        searchBar.text = "restaurant"
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
        return businessesArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Check to see if we're hitting the end of the list
        if (businessesArray.count == 0) {
            return UITableViewCell(style: .Default, reuseIdentifier: nil)
        }
        else if (indexPath.row == businessesArray.count) {
            println("At the end of the list")
            let cell = tableView.dequeueReusableCellWithIdentifier("progressCell", forIndexPath: indexPath) as ProgressTableViewCell
            cell.progressIndicator.startAnimating()
            loadMoreResults()
            
            if (businessesArray.count == 0) {
                cell.progressIndicator.hidden = true
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as BusinessTableViewCell
        let business = businessesArray[indexPath.row]
        
        cell.setBusinessName(indexPath.row+1, name: business.name)
        cell.setImage(business.imageURL)
        cell.setRatingImage(business.ratingImageURL)
        
        cell.setReviewCount(business.reviewCount)
        cell.setAddress(business.location.address, neighborhoods: business.location.neighborhoods)
        cell.setCategories(business.categories)
        
        cell.distanceLabel.text = "0.3mi"
        cell.distanceLabel.sizeToFit()
        
        return cell
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchYelp(searchBar.text)
    }
    func showFilterView() {
        NSLog("Tapped on filter")
        let filterViewController = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterViewController.filterDelegate = self
        
        self.navigationController?.presentViewController(filterViewController, animated: true, completion: { () -> Void in
            
            NSLog("Successfully pushed the filter view")
        })
    }
    func showMapView() {
        NSLog("Tapped on Map")
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        mapViewController.businessesArray = businessesArray
        //mapViewController.filterDelegate = self
        
        mapViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.navigationController?.presentViewController(mapViewController, animated: true, completion: { () -> Void in
            NSLog("Successfully pushed the map view")
        })
    }
    func loadMoreResults() {
        // Take the current search parameters and add more to the businesses array
        var parameters = ["limit": LIMIT, "offset":businessesArray.count, "term": "restaurants", "location": "San Francisco"]
        searchYelp(parameters, newQuery: false)
    }
    
    func searchYelp(parameters: NSDictionary, newQuery: Bool) {
        
        let progressControl = UIActivityIndicatorView()

        // Clear the business list array if it's a brand new query
        if newQuery {
            businessesArray = [Business]()
            self.businessesTableView.reloadData()
            NSLog("Tableview cleared")
            
            // Show a progress spinner
            self.view.addSubview(progressControl)
            progressControl.hidden = false
            progressControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            progressControl.color = UIColor.lightGrayColor()
            progressControl.frame = CGRectMake(self.view.frame.width/2-PADDING, self.view.frame.height/2-PADDING, 2*PADDING, 2*PADDING)
            progressControl.startAnimating()
        }
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = YelpClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
    
        let term = parameters.valueForKey("term") as String
        NSLog("Searching for...\(term)")
        
        self.client.searchWithDictionary(parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let resultsArray = response["businesses"] as [NSDictionary]? {
                    for result in resultsArray {
                        self.businessesArray.append(Business(dictionary: result))
                        //println(self.businessesArray.count)
                    }
                    NSLog ("Search DONE")
                    progressControl.removeFromSuperview()
                    self.businessesTableView.reloadData()
                }
            }) { (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
                NSLog("error: \(error.description)");
                progressControl.removeFromSuperview()
        }
    }
    
    func searchYelp(query: String) {
        var parameters = ["term":query, "location":DEFAULT_LOCATION]
        searchYelp(parameters, newQuery: true)
    }
    func printBusinessesArray(businesses: [Business]) {
        for business in businesses {
            NSLog(business.description)
        }
    }
    func colorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func applyFilter() {
        var parameters = ["term":searchBar.text, "location":DEFAULT_LOCATION] as NSMutableDictionary

        parameters.addEntriesFromDictionary(FilterSettings.getParameters())
        NSLog("Search query: \(parameters)")
        searchParameters = parameters
        searchYelp(parameters, newQuery: true)
    }
}

protocol FilterDelegate {
    func applyFilter()
}
