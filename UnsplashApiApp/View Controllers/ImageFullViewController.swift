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
        viewModel.delegate = self
        viewModel.fetchImage(ofSize: .regular)
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
}

extension ImageFullViewController: ImageDelegate {
    func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {
        imageView.downloadButton(isLoading: false)
        guard let error = error else {
            return
        }
        //TODO: Error handeling
        print("error while saving image \(error)")
    }
    
    func imageState(_ state: ImageState) {
        switch state {
        case .loading:
            break
            //TODO: Placeholder
        case .image(let imageViewState): self.imageView.bind(imageViewState)
        case .error:
            break
            //TODO: Error handeling
        }
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
