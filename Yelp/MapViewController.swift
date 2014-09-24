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
        mapView.delegate = self
        
        // Add the cancel button on the left
        let listButton = YelpButton(text: "List")
        listButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        let listBarButton = UIBarButtonItem(customView: listButton)
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        mapViewNavigationItem.setRightBarButtonItems([negativeSpacer, listBarButton], animated: false)
        
        var upper: CLLocationCoordinate2D?
        var lower: CLLocationCoordinate2D?
        var index = 0
        for business in businessesArray!  {
        
            let location = business.location
            let coordinate = location.coordinate
            index += 1
            
            if coordinate != nil {
                if upper == nil {
                    upper = CLLocationCoordinate2DMake(coordinate!.lat, coordinate!.long)
                    lower = CLLocationCoordinate2DMake(coordinate!.lat, coordinate!.long)
                }
                //let pin = MKPointAnnotation()
                let pin = MapAnnotation(markerText: String(index), title: business.name, coordinate: CLLocationCoordinate2D(latitude: coordinate!.lat, longitude: coordinate!.long))
                //pin.coordinate = CLLocationCoordinate2D(latitude: coordinate!.lat, longitude: coordinate!.long)
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
                let span = MKCoordinateSpan(latitudeDelta: upper!.latitude-lower!.latitude+0.05, longitudeDelta: upper!.longitude-lower!.longitude+0.05)
                let center = CLLocationCoordinate2D(latitude: (upper!.latitude+lower!.latitude)/2, longitude: (upper!.longitude+lower!.longitude)/2)
                let region = MKCoordinateRegion(center: center, span: span)
                mapView.region = mapView.regionThatFits(region)
            }
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation.isKindOfClass(MapAnnotation)) {
            let marker = annotation as MapAnnotation
            var markerView = mapView.dequeueReusableAnnotationViewWithIdentifier("YelpAnnotation")
            
            if markerView == nil {
                markerView = marker.annotationView
            }
            else {
                markerView.annotation = annotation
            }
            return markerView
        }
        return nil
    }
    
    func backAction() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Dismissing the map view")
            //FilterSettings.cancel()
        })
    }
}
