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

class BusinessesTableViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var businessesTableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var searchBar = UISearchBar()
    
    var client = YelpClient()
    var businessesArray = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // Skin the navigation bar
        self.navigationController?.navigationBar.barTintColor = YELP_RED
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        filterButton.target = self
        filterButton.action = "showFilterView"
        
        // Setting up the table view and table cells
        let businessCellNib = UINib(nibName: "BusinessTableViewCell", bundle: nil);
        businessesTableView.registerNib(businessCellNib, forCellReuseIdentifier: "businessCell")
        businessesTableView.estimatedRowHeight = 200
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.separatorStyle = .None
        
        // Set up the search bar
        self.navigationItem.titleView = searchBar;
        searchBar.delegate = self
        
       /* NSDictionary* barButtonItemAttributes =
        {NSFontAttributeName:
            UIFont   (fontWithName:@"Georgia" size:20.0f],
            NSForegroundColorAttributeName:
            [UIColor colorWithRed:141.0/255.0 green:209.0/255.0 blue:205.0/255.0 alpha:1.0]
        }
        
        filterButton.setTitleTextAttributes(attributes: [NSDictionary dictionar AnyObject]!, forState: <#UIControlState#>)
        
        
        [buttonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [UIFont fontWithName:@"Helvetica-Bold" size:26.0], NSFontAttributeName,
            [UIColor greenColor], NSForegroundColorAttributeName,
            nil]
            forState:UIControlStateNormal];*/

        // Initial search term
        searchYelp("restaurant")
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
        return businessesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
        self.navigationController?.presentViewController(filterViewController, animated: true, completion: { () -> Void in
            NSLog("Successfully pushed the filter view")
        })
    }
    func searchYelp(query: String) {
        // Clear the business list array
        self.businessesArray = [Business]()
        self.businessesTableView.reloadData()
        
        // Show a progress spinner
        let progressControl = UIActivityIndicatorView()
        self.view.addSubview(progressControl)
        progressControl.hidden = false
        progressControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        progressControl.color = UIColor.lightGrayColor()
        progressControl.frame = CGRectMake(self.view.frame.width/2-PADDING, self.view.frame.height/2-PADDING, 2*PADDING, 2*PADDING)
        progressControl.startAnimating()
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = YelpClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
        NSLog("Searching for...\(query)")
        self.client.searchWithTerm(query,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let resultsArray = response["businesses"] as [NSDictionary]? {
                    for result in resultsArray {
                        self.businessesArray.append(Business(dictionary: result))
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
}
