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
    let insets: UIEdgeInsets
    let defaultSize: CGSize
}

struct Fonts {
    static var regular = UIFont(name: "HelveticaNeue", size: 14)
}

extension Image {
    func sizeFor(collectionWidth: CGFloat, insets: UIEdgeInsets?) -> CGSize {
        let padding: CGFloat = (insets?.left ?? 16 ) * 2
        let imageWidth = CGFloat(integerLiteral: self.width)
        let imageAspect = collectionWidth / imageWidth
        let height = CGFloat(integerLiteral: self.height) * imageAspect - padding
        return CGSize(width: collectionWidth - padding, height: height)
    }
}
