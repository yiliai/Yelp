//
//  FilterViewController.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = YELP_RED
        navigationBar.tintColor = UIColor.whiteColor()
        
        cancelButton.target = self
        cancelButton.action = "cancelAction"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Dismissing the filter view")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
