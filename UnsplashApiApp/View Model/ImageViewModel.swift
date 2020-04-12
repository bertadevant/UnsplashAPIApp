//
//  ImageViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

class ImageViewModel {
    let image: Image
    var imageDelegate: ((ImageState) -> ())?
    var imageViewState: ImageViewState?
    
    init(image: Image) {
        self.image = image
    }
    
    func requestImage() {
        imageDelegate?(.loading)
        fetchImage(image) { imageViewState in
            self.imageViewState = imageViewState
            self.imageDelegate?(.image(imageViewState))
        }
    }
    
    private func fetchImage(_ image: Image, completion: @escaping (ImageViewState) -> ()) {
        let request = APIRequest.loadRequest(imageURL: image.urls.small)
        let resource = Resource<Data>(get: request)
        Dependencies.enviroment.session.download(resource) { imageData, _ in
            let imageSmall = imageData.map(UIImage.init(data:))!!
            completion(ImageViewState(image: image, downloadedImage: imageSmall))
        }
    }
    
    func sizeFor(collectionWidth: CGFloat, cellStyle: CellStyle) -> CGSize {
        let padding: CGFloat = cellStyle.insets.left + cellStyle.insets.right
        let width = collectionWidth / cellStyle.itemsPerRow
        let imageAspect = width /  CGFloat(image.width)
        let height = CGFloat(image.height) * imageAspect
        return CGSize(width: width - padding, height: height - padding)
    }
}
