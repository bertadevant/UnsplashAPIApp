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
        print("👾 download")
    }
    
    func dismiss() {
        print("👾 dismiss")
        self.dismiss(animated: true, completion: nil)
    }
}
