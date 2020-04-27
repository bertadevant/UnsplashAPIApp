//
//  ImageMapViewController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 26/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ImageMapViewController: UIViewController {
    private var mapView = ImageMapView()
    private let locationManager = CLLocationManager()
    private let regionRadius: Double = 10000
    private let viewModel = ImageMapViewModel()
    private var searchParameters: SearchParameters = .initialParameters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        setupMap()
        checkLocationServices()
        viewModel.fetchImages(searchParameters, completion: {_ in })
        viewModel.imageviewStateCompleted = addNotationToMap
    }
    
    private func setupMap() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.pinToSuperviewEdges()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
        //This is the first level of permissions, user has location phone wide on
        guard CLLocationManager.locationServicesEnabled() else {
            //TODO: show alert to enable location services
            return
        }
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        //This checks second level of authorizations which are pertinent to our app
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            //TODO: nothing we can do, send alert to go to settings
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //App could be restrictred due to parent control
            //TODO: Show alert about restrictions
            break
        default: break
        }
    }
    
    private func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    private func addNotationToMap(_ result: Result<ImageViewState, Error>) {
        //check for the locations
        switch result {
        case .success(let image): mapView.setUpPin(with: image)
        default:
            break
        }
    }
}

extension ImageMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    //MapView works similary to tableView, this will get called every time an annotation is added to the map
    //Here we can return our own "cell" which would be a MKAnnotationView for a specific annotation type
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ImagePin else { return nil }
        //we check if we can use a reusable View instead of creating a new one of the same identifier
        if let dequequeView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier) as? MKMarkerAnnotationView {
            dequequeView.annotation = annotation
            return dequequeView
        }
        //TODO: Create our own MKMarkerAnnotationView to handle this and show images
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return view
    }
}

extension ImageMapViewController: CLLocationManagerDelegate {
    //every time location of user updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //We do not do anything if last location is not known
//        guard let location = locations.last else { return }
//        //2D location of the last known user location
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        mapView.centerAtLocation(center, regionRadius: regionRadius)
    }
    
    //every times user updates auth
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
