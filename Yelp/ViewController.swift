//
//  ViewController.swift
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

class ViewController: UIViewController {

    var client = YelpClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = YelpClient(consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret, accessToken: kYelpToken, accessSecret: kYelpTokenSecret)
            
        self.client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            NSLog("response: \(response)");
            }) { (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
            NSLog("error: \(error.description)");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

