//
//  ImageFullViewController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 14/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

protocol ImageActionsDelegate: class {
    func shareImage()
    func download()
    func dismiss()
}

class ImageFullViewController: UIViewController {
    private let imageView = ImageFullScreenView()
    private let viewModel: ImageViewModel
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: Image) {
        self.viewModel = ImageViewModel(image: image)
        super.init(nibName: nil, bundle: nil)
        setupImageView()
        setupImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.pinToSuperviewEdges()
    }
    
    private func setupImageView() {
        imageView.delegate = self
        view.addSubview(imageView)
        imageView.pinToSuperviewEdges()
    }
    
    private func setupImage() {
        viewModel.fetchImage(ofSize: .regular){ [weak self] state in
            switch state {
            case .image(let viewState):
                self?.imageView.bind(viewState)
            case .error: break //TODO: ERROR handeling
            }
        }
        imageView.showLoadingState()
        viewModel.downloadImageSaved = { [weak self] _, error, _ in
            self?.imageFinishedDownloading(error)
        }
    }
    
    private func imageFinishedDownloading(_ error: Error?) {
        imageView.downloadButton(isLoading: false)
        var alert: AlertController
        if let error = error {
            alert = AlertController(error: error, handler: nil)
        } else {
            alert = AlertController(message: "Download completed successful", title: "Download Completed", handler: nil)
        }
        present(alert.actionAlert, animated: true, completion: nil)
    }
}

extension ImageFullViewController: ImageActionsDelegate {
    func shareImage() {
        viewModel.share() { image, _ in
            guard let image = image else {
                return
            }
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.imageView.shareButton
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func download() {
        viewModel.download()
        imageView.downloadButton(isLoading: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
