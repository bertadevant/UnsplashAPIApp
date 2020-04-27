//
//  ImageMapView.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 27/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit
import MapKit

class ImageMapView: MKMapView {
    private var imagePins: [ImagePin] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsUserLocation = true
        showsPointsOfInterest = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }
    
    func setUpPin(with image: ImageViewState) {
        if let pin = ImagePin(image: image) {
            print("Notation added \(image.location)")
            addAnnotation(pin)
        }
    }
        
    func centerAtLocation(_ center: CLLocationCoordinate2D, regionRadius: Double) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(region, animated: true)
    }
}

class ImagePin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    private let image: ImageViewState
    
    var title: String? {
        return image.location?.title
    }
    
    var subtitle: String? {
        return image.description
    }
    
    init?(image: ImageViewState) {
        guard let location = image.location else { return nil }
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitud, longitude: location.longitud)
        self.image = image
        super.init()
    }

}
