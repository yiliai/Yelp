//
//  YelpButton.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/22/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let YELP_FONT = UIFont(name: "HelveticaNeue-Medium", size: 13.0)

class YelpButton: UIButton {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    init(text: String) {
        super.init(frame: CGRectMake(0,0,55,30))
        self.setBackgroundImage(UIImage(named: "button_bg"), forState: .Normal)
        let attributedTitle = NSMutableAttributedString(string: text)        
        let range = NSMakeRange(0, attributedTitle.length)
        attributedTitle.addAttribute(NSFontAttributeName, value: YELP_FONT, range: range)
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: range)
        self.setAttributedTitle(attributedTitle, forState: .Normal)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
