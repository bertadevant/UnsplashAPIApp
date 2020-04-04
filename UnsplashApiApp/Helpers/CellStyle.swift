//
//  CellStyle.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit


struct CellStyle {
    let reuseIdentifier: String
    let insets: UIEdgeInsets
    let itemsPerRow: CGFloat
}

extension CellStyle {
    static var iphone = CellStyle(reuseIdentifier: "ImageCell",
                                  insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
                                  itemsPerRow: 1)
    static var ipad = CellStyle(reuseIdentifier: "ImageCell",
                                insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
                                itemsPerRow: 2)
}

extension ImageViewState {
    func sizeFor(collectionWidth: CGFloat, cellStyle: CellStyle) -> CGSize {
        let padding: CGFloat = cellStyle.insets.left + cellStyle.insets.right
        let width = collectionWidth / cellStyle.itemsPerRow
        let imageAspect = width /  self.size.width
        let height = self.size.height * imageAspect
        return CGSize(width: width - padding, height: height - padding)
    }
}
