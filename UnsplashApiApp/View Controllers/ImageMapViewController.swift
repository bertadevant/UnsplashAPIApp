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
    private var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        setupMap()
    }
    
    private func setupMap() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.pinToSuperviewEdges()
    }
}

extension ImageMapViewController: MKMapViewDelegate {
    
    
}

extension ImageMapViewController: CLLocationManagerDelegate {
    
}
