//
//  ImageSaver.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 15/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    private let imageSavedClosure: (_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) -> ()
    
    init(imageSavedClosure: @escaping (_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) -> ()) {
        self.imageSavedClosure = imageSavedClosure
    }
    
    func download(_ image: Image) {
        downloadImageFile(image)
        sendDownloadEndPointToAPI(image)
    }
    
    private func downloadImageFile(_ image: Image) {
        let imageRequest = LoadAPIRequest(imageURL: image.urls.full)
        let imageResource = Resource<Data>(get: imageRequest)
        Dependencies.dependencies.session.download(imageResource) { imageData, error in
            guard let data = imageData,
                let imageFile = UIImage(data: data) else {
                    return
            }
            UIImageWriteToSavedPhotosAlbum(imageFile, self, #selector(self.imageSaved), nil)
        }
    }
    
    @objc private func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {
        self.imageSavedClosure(image, error, context)
    }
    
    private func sendDownloadEndPointToAPI(_ image: Image) {
        let downloadRequest = DownloadAPIRequest(imageID: image.id)
        let downloadResource = Resource<Data>(get: downloadRequest)
        Dependencies.dependencies.session.download(downloadResource) { _, _ in }
    }
}
