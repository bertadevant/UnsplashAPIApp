//
//  ImageFullViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 21/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

class ImageFullViewModel: NSObject {
    
    let image: ImageViewState
    var imageSavedDelegate: ((_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) -> ())?
    
    init(image: ImageViewState) {
        self.image = image
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
    
    private func downloadImageFile(completion: @escaping (UIImage?, Error?) -> ()) {
        let imageRequest = APIRequest.loadRequest(imageURL: image.imageFull)
        let imageResource = Resource<Data>(get: imageRequest)
        Dependencies.enviroment.session.download(imageResource) { imageData, error in
            guard let data = imageData,
                let image = UIImage(data: data) else {
                    completion(nil, error)
                    return
            }
            completion(image, nil)
        }
    }
    
    @objc private func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {
        imageSavedDelegate?(image, error, context)
    }
    
    private func sendDownloadEndPointToAPI() {
        let downloadRequest = APIRequest.downloadRequest(imageID: image.id)
        let downloadResource = Resource<Data>(get: downloadRequest)
        Dependencies.enviroment.session.download(downloadResource) { _, _ in }
    }
}
