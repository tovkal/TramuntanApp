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
    
    /// Map view outlet
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    /// Only want to center map over user location once, ignore further location updates
    private var mapCentered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMountainsToMap()
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
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
        }
        
        annotationView?.pinColor = senderAnnotation.pinColor
        
        return annotationView
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
                ele = mountain.valueForKey("ele") as? String
            {
                
                let mountainPin = MountainPin(coordinate: CLLocationCoordinate2DMake(lat, lon), title: name, subtitle: "\(ele)")
                
                self.mapView.addAnnotation(mountainPin)
            }
        }
    }
}
