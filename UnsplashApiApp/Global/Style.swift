//
//  Colors.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 20/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit
enum Font {
    static let regular = UIFont(name: "HelveticaNeue", size: 16)
}

enum Color {
    static var systemGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        } else {
            return .darkGray
        }
    }
    static var systemGray4: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray4
        } else {
            return .lightGray
        }
    }
    
    static var background: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    static var label: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    
    static var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .white
        }
    }
    
    static var systemGray6: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray6
        } else {
            return .darkGray
        }
    }
}
