//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/20/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleSwitch(sender: AnyObject) {
        if indexPath == nil {
            return
        }
        if let option = FilterSettings.filterSections[indexPath!.section].optionsArray[indexPath!.row] as? OnOffOption {
            option.onOffState = !option.onOffState
        }
    }
}
