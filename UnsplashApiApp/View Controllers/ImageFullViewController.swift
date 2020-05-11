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
        viewModel.fetchImage(ofSize: .regular){ [weak self] result in
            //TODO: this logic should be on Coordinator
            switch result {
            case .success(let viewState):
                self?.imageView.bind(viewState)
            case .failure: break //TODO: ERROR handeling
            }
        }
        imageView.showLoadingState()
        //TODO: Coordinator logic and handeling
        viewModel.downloadImageSaved = { [weak self] _, error, _ in
            self?.imageFinishedDownloading(error)
        }
    }
    
    private func imageFinishedDownloading(_ error: Error?) {
        //TODO: Take this presentation out of the VC -> Coordinator
        //presentation should be on navigation Controller
        imageView.downloadButtonState(isLoading: false)
        var alert: UIAlertController
        if let error = error {
            alert = UIAlertController(error: error, handler: nil)
        } else {
            alert = UIAlertController(message: "Download completed successful", title: "Download Completed", handler: nil)
        }
        present(alert, animated: true, completion: nil)
    }
}

extension ImageFullViewController: ImageActionsDelegate {
    func shareImage() {
        viewModel.share() { [weak self] result in
            guard let self = self else { return }
            //TODO: this logic shoudl be on Coordinator, presentation should be on Navigation Controller
            switch result {
            case .success(let image):
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.imageView.shareButton
                self.present(activityViewController, animated: true, completion: nil)
            case .failure: break //TODO: Error handeling
            }
        }
    }
    
    func download() {
        viewModel.download() { [weak self] _ in
            guard let self = self else { return }
            //TODO: Error Handeling
        }
        imageView.downloadButtonState(isLoading: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
