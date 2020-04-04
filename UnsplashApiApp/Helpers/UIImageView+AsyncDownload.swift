//
//  UIImageView+AsyncDownload.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit
import Foundation

extension UIImageView {
    func setImage(fromURL imageURL: String, placeHolder: UIImage?) {
        self.image = nil
        let request = LoadAPIRequest(imageURL: imageURL)
        let resource = Resource<Data>(get: request)
        let indicator = addLoadingIndicator()
        Dependencies.enviroment.session.download(resource) { imageData, _ in
            let image = imageData.map(UIImage.init(data:))
            DispatchQueue.main.async {
                self.image = image ?? placeHolder
                indicator.removeFromSuperview()
            }
        }
    }

    private func addLoadingIndicator() -> UIView {
        let roundedSquare = UIView()
        roundedSquare.backgroundColor = Colors.darkGray.withAlphaComponent(0.3)
        roundedSquare.layer.cornerRadius = 20.0
        roundedSquare.layer.masksToBounds = true
        self.addSubview(roundedSquare)
        roundedSquare.addWidthConstraint(with: 80)
        roundedSquare.addHeightConstraint(with: 80)
        roundedSquare.centerXToSuperview()
        roundedSquare.centerYToSuperview()

        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        roundedSquare.addSubview(indicator)
        indicator.sizeToFit()
        indicator.centerXToSuperview()
        indicator.centerYToSuperview()

        indicator.startAnimating()

        return roundedSquare
    }
}


