//
//  DropdownCollapsedTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/21/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class DropdownTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
