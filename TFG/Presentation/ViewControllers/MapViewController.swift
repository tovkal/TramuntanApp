//
//  MapViewController.swift
//  TFG
//
//  Created by Andrés Pizá on 19/4/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    // MARK: Map
    
    /// Map view outlet
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    /// Only want to center map over user location once, ignore further location updates
    private var mapCentered = false
    
    // MARK: RangeView
    private var rangeViewContainer: UIView?
    private var rangeViewController: RangeViewController?
    
    // MARK: -
    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMountainsToMap()
        
        setupRangeView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addChildViewController(self.rangeViewController!)
        self.rangeViewContainer?.addSubview(self.rangeViewController!.view)
        self.rangeViewController?.didMoveToParentViewController(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.rangeViewController?.willMoveToParentViewController(nil)
        self.rangeViewController?.view.removeFromSuperview()
        self.rangeViewController?.removeFromParentViewController()
    }
    
    private func setupRangeView() {
        
        self.rangeViewController = RangeViewController()
        
        let rangeView = self.rangeViewController!.view
        
        self.rangeViewContainer = UIView(frame: rangeView.frame)
        self.rangeViewContainer?.opaque = false
        self.rangeViewContainer?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addSubview(self.rangeViewContainer!)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.rangeViewContainer!.frame.size.width))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.rangeViewContainer!.frame.size.height))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: -5))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: -10))
    }
    
    // MARK: - MKMapView delegate methods
    
    /**
    Update map region after user location update, to center map above the location
    
    :param: mapView      the map view
    :param: userLocation the new user location
    */
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if !self.mapCentered {
            
            var mapRegion = MKCoordinateRegion()
            mapRegion.center = mapView.userLocation.coordinate
            mapRegion.span.latitudeDelta = 1
            mapRegion.span.longitudeDelta = 1
            
            self.mapView.setRegion(mapRegion, animated: true)
            
            self.mapCentered = true
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if !annotation.isKindOfClass(MountainPin) {
            return nil
        }
        
        if !mapView.isEqual(self.mapView) {
            return nil
        }
        
        let senderAnnotation = annotation as! MountainPin
        
        let reusableIdentifier = "mountainPin"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusableIdentifier)
            annotationView.image = UIImage(named: "mountain_pin")
            annotationView.canShowCallout = true
        }
        
        if !senderAnnotation.url.isEmpty && senderAnnotation.url != "NULL" {
            let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            let buttonImage = UIImage(named: "wikipedia")!
            button.setImage(buttonImage, forState: UIControlState.Normal)
            button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)
            annotationView.rightCalloutAccessoryView = button
        } else {
            annotationView.rightCalloutAccessoryView = nil
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if let annotation = view.annotation as? MountainPin {
            UIApplication.sharedApplication().openURL(NSURL(string: annotation.url)!)
        }
    }
    
    // MARK: - Pin data
    
    /**
    Adds mountain pints to the map
    */
    private func addMountainsToMap() {
        
        let mountains = DataParser.sharedParser().mountains as NSMutableArray
        
        for mountain in mountains {
            if let
                name = mountain.valueForKey("name") as? String,
                lat = (mountain.valueForKey("lat") as? String)?.doubleValue(),
                lon = (mountain.valueForKey("lon") as? String)?.doubleValue(),
                ele = mountain.valueForKey("ele") as? String,
                url = mountain.valueForKey("wikipedia") as? String
            {
                
                let mountainPin = MountainPin(coordinate: CLLocationCoordinate2DMake(lat, lon), title: name, subtitle: "Elevation: \(ele) m.", url: url)
                
                self.mapView.addAnnotation(mountainPin)
            }
        }
    }
}
