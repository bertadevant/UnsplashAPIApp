//
//  ImageViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

enum ImageSize {
    case small
    case regular
    case full
}

enum ImageError: String, Error {
    case imageCreationError = "There was a problem while creating UIImage"
}

class ImageViewModel: NSObject {
    let image: Image
    var imageViewState: ImageViewState?
    var downloadImageSaved: ((_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) -> ())?
    
    init(image: Image) {
        self.image = image
    }
    
    func fetchImage(ofSize size: ImageSize, completion: @escaping (Result<ImageViewState, Error>) -> Void) {
        let imageURL = (size == .small) ? image.urls.small : image.urls.regular
        fetchImage(imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                let viewState = ImageViewState(image: self.image, downloadedImage: image)
                self.imageViewState = viewState
                completion(.success(viewState))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func download(completion: @escaping (Error?) -> ()) {
        fetchImage(image.urls.full) { result in
            switch result {
            case .success(let image):
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved), nil)
                completion(nil)
            case .failure(let error): completion(error)
            }
        }
        sendDownloadEndPointToAPI()
    }
    
    func share(completion: @escaping (Result<UIImage, Error>) -> ()) {
        fetchImage(image.urls.full) { result in
            completion(result)
        }
    }
    
    func sizeFor(collectionWidth: CGFloat, cellStyle: CellStyle) -> CGSize {
        let padding: CGFloat = cellStyle.insets.left + cellStyle.insets.right
        let width = collectionWidth / cellStyle.itemsPerRow
        let imageAspect = width /  CGFloat(image.width)
        let height = CGFloat(image.height) * imageAspect
        return CGSize(width: width - padding, height: height - padding)
    }
    
    @objc private func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {
        downloadImageSaved?(image, error, context)
    }
    
    private func sendDownloadEndPointToAPI() {
        let downloadRequest = APIRequest.downloadRequest(imageID: image.id)
        let downloadResource = Resource<Data>(get: downloadRequest)
        Dependencies.enviroment.mainSession.download(downloadResource) { _ in }
    }
    
    private func fetchImage(_ imageURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        let request = APIRequest.loadRequest(imageURL: imageURL)
        let resource = Resource<Data>(get: request)
        Dependencies.enviroment.mainSession.download(resource) { result in
            switch result {
            case .success(let data):  guard let image = UIImage(data: data) else {
                completion(.failure(ImageError.imageCreationError))
                return
            }
            completion(.success(image))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
