//
//  ImageFullScreenView.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

class ImageFullScreenView: UIView {
    
    private var image: ImageViewModel?
    
    private var screenSafeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ??
            UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
    }
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Fonts.regular
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingHead
        label.textAlignment = .left
        return label
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.alpha = 0.40
        view.backgroundColor = .clear
        return view
    }()
    
    private var backgroundColorView: UIView = {
        let view = UIView()
        view.alpha = 0.5
        view.backgroundColor = .white
        return view
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share-icon"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "download-icon"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close-icon"), for: .normal)
        button.tintColor = .gray
        button.alpha = 0.40
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }
    
    func bind(_ image: ImageViewModel) {
        self.image = image
        imageView.imageFromServerURL(image.imageRegular, placeHolder: #imageLiteral(resourceName: "placeholder-square"))
        backgroundColor = image.colors.imageColor
        authorLabel.textColor = image.colors.textColor
        authorLabel.text = image.author.name
        shareButton.tintColor = image.colors.textColor
        downloadButton.tintColor = image.colors.textColor
        closeButton.tintColor = image.colors.textColor
    }
    
    private func setup() {
        shareButton.setImage(#imageLiteral(resourceName: "share-icon"), for: .normal)
        addSubview(imageView)
        addSubview(closeButton)
        containerView.addSubview(backgroundColorView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(shareButton)
        containerView.addSubview(downloadButton)
        addSubview(containerView)
        setupLayout()
    }
    
    private func setupLayout() {
        imageView.pinToSuperviewLeft(constant: 8)
        imageView.pinToSuperviewRight(constant: -8)
        
        closeButton.pinToSuperviewTop(constant: 16 + screenSafeAreaInsets.top)
        closeButton.pinToSuperviewLeft(constant: 16)
        closeButton.addWidthConstraint(with: 35)
        closeButton.addHeightConstraint(with: 35)
        
        backgroundColorView.pinToSuperviewEdges()
        
        containerView.pinToSuperview(edges: [.left, .right, .bottom])
        containerView.addHeightConstraint(with: 35 + screenSafeAreaInsets.bottom)
        
        authorLabel.pinToSuperviewLeft(constant: 16)
        authorLabel.pinToSuperviewTop(constant: 8)
        authorLabel.pin(edge: .right, to: .left, of: downloadButton, constant: 16, relatedBy: .greaterThanOrEqual)
        
        shareButton.pinToSuperviewTop(constant: 8)
        shareButton.pinToSuperviewRight(constant: -16)
        shareButton.addHeightConstraint(with: 35)
        shareButton.addWidthConstraint(with: 35)
        
        downloadButton.pinToSuperviewTop(constant: 8)
        downloadButton.pin(edge: .right, to: .left, of: shareButton, constant: -16)
        downloadButton.addHeightConstraint(with: 35)
        downloadButton.addWidthConstraint(with: 35)
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        let actions = image?.actions?.filter{ $0.name == "shareAction" }
        guard let shareAction = actions?.first else {
            return
        }
        shareAction.handler()
    }
    
    @objc func downloadButtonTapped(_ sender: UIButton) {
        let actions = image?.actions?.filter{ $0.name == "downloadAction" }
        guard let downloadAction = actions?.first else {
            return
        }
        downloadAction.handler()
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        let actions = image?.actions?.filter{ $0.name == "closeAction" }
        guard let closeAction = actions?.first else {
            return
        }
        closeAction.handler()
    }
}
