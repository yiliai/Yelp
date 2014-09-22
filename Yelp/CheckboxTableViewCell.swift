//
//  DropdownExpandedTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/21/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var checkboxImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /*if selected {
            println("Set Selected on \(optionLabel.text) as \(selected)")
            checkboxImage.image = UIImage(named: "checked")
        }*/
    }
    
    func toggleState(state: CheckboxState) {
        //println("TOGGLE STATE")
        switch state {
        case .Collapsed:
            checkboxImage.image = UIImage(named: "dropdown")
        case .Checked:
            checkboxImage.image = UIImage(named: "checked")
        case .Unchecked:
            checkboxImage.image = UIImage(named: "unchecked")
        }
    }
}

enum CheckboxState {
    case Collapsed, Checked, Unchecked
}