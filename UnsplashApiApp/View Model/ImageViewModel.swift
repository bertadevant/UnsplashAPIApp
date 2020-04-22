//
//  ImageViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDelegate: class {
    func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?)
    func imageState(_ state: ImageState)
}

enum ImageSize {
    case small
    case regular
    case full
}

class ImageViewModel {
    let image: Image
    var imageViewState: ImageViewState?
    var delegate: ImageDelegate?
    
    init(image: Image) {
        self.image = image
    }
    
    func fetchImage(ofSize size: ImageSize) {
        let imageURL = (size == .small) ? image.urls.small : image.urls.regular
        delegate?.imageState(.loading)
        fetchImage(imageURL) { [weak self] uiimage in
            guard let self = self else { return }
            let viewState = ImageViewState(image: self.image, downloadedImage: uiimage)
            self.imageViewState = viewState
            self.delegate?.imageState(.image(viewState))
        }
    }
    
    func download() {
        downloadImageFile() { image, error in
            guard let image = image else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved), nil)
        }
        sendDownloadEndPointToAPI()
    }
    
    func share(completion: @escaping (UIImage?, Error?) -> ()) {
        downloadImageFile(){ image, error in
            completion(image, error)
        }
    }
    
    func sizeFor(collectionWidth: CGFloat, cellStyle: CellStyle) -> CGSize {
        let padding: CGFloat = cellStyle.insets.left + cellStyle.insets.right
        let width = collectionWidth / cellStyle.itemsPerRow
        let imageAspect = width /  CGFloat(image.width)
        let height = CGFloat(image.height) * imageAspect
        return CGSize(width: width - padding, height: height - padding)
    }
    
    private func downloadImageFile(completion: @escaping (UIImage?, Error?) -> ()) {
        let imageRequest = APIRequest.loadRequest(imageURL: image.urls.full)
        let imageResource = Resource<Data>(get: imageRequest)
        Dependencies.enviroment.mainSession.download(imageResource) { imageData, error in
            guard let data = imageData,
                let image = UIImage(data: data) else {
                    completion(nil, error)
                    return
            }
            completion(image, nil)
        }
    }
    
    @objc private func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {
        delegate?.imageSaved(image, error, context)
    }
    
    private func sendDownloadEndPointToAPI() {
        let downloadRequest = APIRequest.downloadRequest(imageID: image.id)
        let downloadResource = Resource<Data>(get: downloadRequest)
        Dependencies.enviroment.mainSession.download(downloadResource) { _, _ in }
    }
    
    private func fetchImage(_ imageURL: String, completion: @escaping (UIImage) -> ()) {
        let request = APIRequest.loadRequest(imageURL: imageURL)
        let resource = Resource<Data>(get: request)
        Dependencies.enviroment.mainSession.download(resource) { (data, _) in
            //TODO: Error handeling
            guard let imageData = data else { return }
            guard let image = UIImage(data: imageData) else { return }
            completion(image)
        }
    }
}
