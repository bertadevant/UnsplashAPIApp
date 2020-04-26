//
//  TabBarViewController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 26/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var imageListItem: UITabBarItem = {
        let item = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "unsplash-icon"), tag: 1)
        return item
    }()
    
    private var mapItem: UITabBarItem = {
        let item = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "map-icon"), tag: 2)
        return item
    }()
    
    private let imageListNavigationController = ImageListViewController()
    private let mapNavigationController = ImageMapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [imageListNavigationController, mapNavigationController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageListNavigationController.tabBarItem = imageListItem
        mapNavigationController.tabBarItem = mapItem
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
}
