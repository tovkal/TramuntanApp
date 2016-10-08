//
//  MapViewController.swift
//  TramuntanApp
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
    fileprivate var mapCentered = false
    
    // MARK: RangeView
    fileprivate var rangeViewContainer: UIView?
    fileprivate var rangeViewController: RangeViewController?
    
    // MARK: -
    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMountainsToMap()
        
        setupRangeView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.updateRangeSetting(_:)), name: NSNotification.Name.range, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addChildViewController(self.rangeViewController!)
        self.rangeViewContainer?.addSubview(self.rangeViewController!.view)
        self.rangeViewController?.didMove(toParentViewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.rangeViewController?.willMove(toParentViewController: nil)
        self.rangeViewController?.view.removeFromSuperview()
        self.rangeViewController?.removeFromParentViewController()
    }
    
    fileprivate func setupRangeView() {
        
        self.rangeViewController = RangeViewController()
        
        let rangeView = self.rangeViewController!.view
        
        self.rangeViewContainer = UIView(frame: (rangeView?.frame)!)
        self.rangeViewContainer?.isOpaque = false
        self.rangeViewContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.rangeViewContainer!)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.rangeViewContainer!.frame.size.width))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.rangeViewContainer!.frame.size.height))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: -5))
        self.view.addConstraint(NSLayoutConstraint(item: self.rangeViewContainer!, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -10))
    }
    
    // MARK: - MKMapView delegate methods
    
    /**
    Update map region after user location update, to center map above the location
    
    - parameter mapView:      the map view
    - parameter userLocation: the new user location
    */
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if !self.mapCentered {
            
            var mapRegion = MKCoordinateRegion()
            mapRegion.center = mapView.userLocation.coordinate
            mapRegion.span.latitudeDelta = 1
            mapRegion.span.longitudeDelta = 1
            
            self.mapView.setRegion(mapRegion, animated: true)
            
            self.mapCentered = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !annotation.isKind(of: MountainPin.self) {
            return nil
        }
        
        if !mapView.isEqual(self.mapView) {
            return nil
        }
        
        let senderAnnotation = annotation as! MountainPin
        
        let reusableIdentifier = "mountainPin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusableIdentifier)
            annotationView!.image = UIImage(named: "mountain_pin")
            annotationView!.canShowCallout = true
        }
        
        if !senderAnnotation.url.isEmpty && senderAnnotation.url != "NULL" {
            let button = UIButton(type: UIButtonType.custom)
            let buttonImage = UIImage(named: "wikipedia")!
            button.setImage(buttonImage, for: UIControlState())
            button.frame = CGRect(x: 0, y: 0, width: buttonImage.size.width, height: buttonImage.size.height)
            annotationView!.rightCalloutAccessoryView = button
        } else {
            annotationView!.rightCalloutAccessoryView = nil
        }
        
        annotationView!.isHidden = senderAnnotation.distance > (Utils.sharedInstance().getRadiusInMeters()) ? true : false
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let annotation = view.annotation as? MountainPin {
            UIApplication.shared.openURL(URL(string: annotation.url)!)
        }
    }
    
    // MARK: - Pin data
    
    /**
    Adds mountain pints to the map
    */
    fileprivate func addMountainsToMap() {
        
        if let pointsOfInterest = Store.sharedInstance().getPointsOfInterest() {
            for element in pointsOfInterest {
                if let mountain = element as? Mountain {
                    self.mapView.addAnnotation(MountainPin(coordinate: mountain.location.coordinate, title: mountain.name, subtitle: NSString(format: "Elevation: %.2f m", mountain.elevation) as String, url: mountain.wikiUrl, distance: mountain.distance))
                }
            }
        }
    }
    
    // MARK: - Range setting handler
    @objc fileprivate func updateRangeSetting(_ notification: Notification) {
        
        let annotations = self.mapView.annotations
        for element in annotations {
            if let annotation = element as? MountainPin, let annotationView = self.mapView.view(for: annotation) {
                annotationView.isHidden = annotation.distance > Utils.sharedInstance().getRadiusInMeters() ? true : false
            }
        }
    }
}
