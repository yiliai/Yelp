//
//  MapViewController.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/23/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewNavigationItem: UINavigationItem!
    
    var businessesArray: [Business]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = YELP_RED
        navigationBar.tintColor = UIColor.whiteColor()
        
        // Add the cancel button on the left
        let cancelButton = YelpButton(text: "Back")
        cancelButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        mapViewNavigationItem.setLeftBarButtonItems([negativeSpacer, cancelBarButton], animated: false)
        
        //declare latitude and longitude of map center
        //let center = CLLocationCoordinate2D(latitude: 37.8074698812357, longitude: -122.417274713516)
  
        //declare span of map (height and width in degrees)
        //let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.01)
        
        //add center and span to a region,
        //adjust the region to fit in the mapview
        //and assign to mapview region
        //let region = MKCoordinateRegion(center: center, span: span)
        //mapView.region = mapView.regionThatFits(region)
        
        
        var upper: CLLocationCoordinate2D?
        var lower: CLLocationCoordinate2D?
        
        for business in businessesArray!  {
            
            let location = business.location
            let coordinate = location.coordinate
            
            if coordinate != nil {
                if upper == nil {
                    upper = CLLocationCoordinate2DMake(coordinate!.lat, coordinate!.long)
                    lower = CLLocationCoordinate2DMake(coordinate!.lat, coordinate!.long)
                }
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: coordinate!.lat, longitude: coordinate!.long)
                mapView.addAnnotation(pin)
                if coordinate!.lat > upper!.latitude {
                    upper!.latitude = coordinate!.lat
                }
                if coordinate!.lat < lower!.latitude {
                    lower!.latitude = coordinate!.lat
                }
                if coordinate!.long > upper!.longitude {
                    upper!.longitude = coordinate!.long
                }
                if coordinate!.long < lower!.longitude {
                    lower!.longitude = coordinate!.long
            }
            println("PIN: \(business.name) \(pin.coordinate.latitude) \(pin.coordinate.longitude)")
            println("Upper: \(upper?.latitude) \(upper?.longitude)")
            println("Lower: \(lower?.latitude) \(lower?.longitude)")
            }
            if upper != nil {
                let span2 = MKCoordinateSpan(latitudeDelta: upper!.latitude-lower!.latitude+0.05, longitudeDelta: upper!.longitude-lower!.longitude+0.05)
                let center2 = CLLocationCoordinate2D(latitude: (upper!.latitude+lower!.latitude)/2, longitude: (upper!.longitude+lower!.longitude)/2)
                let region2 = MKCoordinateRegion(center: center2, span: span2)
                mapView.region = mapView.regionThatFits(region2)
            }
        }
        // Do any additional setup after loading the view.
        // mapView.showsUserLocation = true;

    }

    func backAction() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Dismissing the map view")
            FilterSettings.cancel()
        })
    }

    
    
    
}
