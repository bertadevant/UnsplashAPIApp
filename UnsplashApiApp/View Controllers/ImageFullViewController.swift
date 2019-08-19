//
//  ImageFullViewController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 14/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

class ImageFullViewController: UIViewController {
    private let imageView = ImageFullScreenView()
    private var imageModel: ImageViewModel?
    
    init(image: Image) {
        super.init(nibName: nil, bundle: nil)
        let actions: [Actions] = [
            Actions(type: .button, name: "shareAction", handler: { [weak self] in
                self?.shareImage(image)
            }),
            Actions(type: .button, name: "downloadAction", handler: { [weak self] in
                self?.download(image)
            }),
            Actions(type: .button, name: "closeAction", handler: { [weak self] in
                self?.dismiss()
            })
        ]
        self.imageModel = ImageViewModel(image: image, actions: actions)
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.pinToSuperviewEdges()
        guard let image = imageModel else {
            return
        }
        imageView.bind(image)
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.pinToSuperviewEdges()
    }
    
    func shareImage(_ image: Image) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func download(_ image: Image) {
        downloadImageFile(image)
        sendDownloadEndPointToAPI(image)
    }
    
    private func downloadImageFile(_ image: Image) {
        let imageRequest = LoadAPIRequest(imageURL: image.urls.full)
        let imageResource = Resource<Data>(get: imageRequest)
        Dependencies.dependencies.session.download(imageResource) { [weak self] imageData in
            guard let data = imageData,
                let imageFile = UIImage(data: data) else {
                    return
            }
            UIImageWriteToSavedPhotosAlbum(imageFile, self, #selector(self?.imageSaved), nil)
        }
    }
    
    @objc private func imageSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        guard let error = error else {
            return
        }
        print("error while saving image \(error)")
    }
    
    private func sendDownloadEndPointToAPI(_ image: Image) {
        let downloadRequest = DownloadAPIRequest(imageID: image.id)
        let downloadResource = Resource<Data>(get: downloadRequest)
        Dependencies.dependencies.session.download(downloadResource) { _ in }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
