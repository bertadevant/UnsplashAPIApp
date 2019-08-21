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
    static var regular = UIFont(name: "HelveticaNeue", size: 16)
}

extension ImageViewState {
    func sizeFor(collectionWidth: CGFloat, insets: UIEdgeInsets?) -> CGSize {
        let padding: CGFloat = (insets?.left ?? 16 ) * 2
        let imageAspect = collectionWidth /  self.size.width
        let height = self.size.height * imageAspect - padding
        return CGSize(width: collectionWidth - padding, height: height)
    }
}
