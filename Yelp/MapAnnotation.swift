//
//  MapAnnotation.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/23/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D
    var markerText: String
    var title: String
    
    init(markerText: String, title: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.markerText = markerText
        self.title = title
    }
    
    var annotationView: MKAnnotationView {
        
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "YelpAnnotation")
        
        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "marker")
        
        let label = UILabel(frame: CGRectMake(0,0,30,22))
        label.text = markerText
        label.textAlignment = NSTextAlignment.Center
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        label.font = YELP_FONT
        label.textColor = UIColor.whiteColor()
        annotationView.addSubview(label)

        return annotationView
    }
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coordinate = newCoordinate
    }
    
    
}
