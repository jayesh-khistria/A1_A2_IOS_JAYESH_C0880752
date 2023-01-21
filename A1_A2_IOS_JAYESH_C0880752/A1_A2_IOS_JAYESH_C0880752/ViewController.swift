//
//  ViewController.swift
//  A1_A2_IOS_JAYESH_C0880752
//
//  Created by Jayesh Khistria on 2023-01-20.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionBtn: UIButton!
    
    var routeLine: MKPolyline?
    var locationManager = CLLocationManager()
    var selectedLocationCount = 0
    var destination: CLLocationCoordinate2D!
    var cities = [City]()
    var touchPoints = [CGPoint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        touchAnnotation()
        

    }
    
    @objc func placeAnnotation(sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: mapView)
        let getCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()

        touchPoints.append(point)
        selectedLocationCount += 1
        
        
        if selectedLocationCount <= 3 {
            annotation.title = "Selected Location \(selectedLocationCount)"
            annotation.coordinate = getCoordinate
            mapView.addAnnotation(annotation)

            let locality = City(title: "Selected Location \(selectedLocationCount)", subtitle: "Selected Location \(selectedLocationCount)", coordinate: CLLocationCoordinate2DMake(getCoordinate.latitude, getCoordinate.longitude))
           cities.append(locality)
        }

        if (selectedLocationCount == 3) {
            cities.append(cities[0])
            addPolyline()
            addPolygon()
        }
    }
    
    func touchAnnotation() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(placeAnnotation))
        touch.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(touch)
    }
    
    func addPolyline() {
        let coordinates = cities.map {$0.coordinate}
        let polyline: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        }
    func addPolygon() {
        let coordinates = cities.map {$0.coordinate}
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon)
        }
    
    @IBAction func removeAllAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        removeOverlays()
    }
    
    func removeOverlays() {
        for polygon in mapView.overlays {
            mapView.removeOverlay(polygon)
        }
        recall()
    }
    
    func recall() {
        for polygon in mapView.overlays {
           touchAnnotation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        print(currentLocation)
        displayLocation(latitude: latitude, longitude: longitude)
    }
    
    func displayLocation(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees) {
        let latDelta: CLLocationDegrees = 0.07
        let lngDelta: CLLocationDegrees =  0.07
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.systemBrown
            rendrer.lineWidth = 3
            
            if routeLine != nil {
                rendrer.strokeColor = UIColor.systemYellow
                rendrer.lineWidth = 5
            }
            return rendrer
        } else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.brown.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.systemYellow
            rendrer.lineWidth = 2
            return rendrer
        }
        return MKOverlayRenderer()
    }
}


