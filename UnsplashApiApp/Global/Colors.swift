//
//  Colors.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 20/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

struct Color {
    static var darkGray: UIColor {
        if #available(iOS 13.0, *) {
            return .systemGray
        } else {
            return .darkGray
        }
    }
    static var lightGray: UIColor {
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
            return .white
        }
    }
    
    static var secondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .white
        }
    }
}
