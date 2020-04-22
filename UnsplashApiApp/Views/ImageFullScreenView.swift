//
//  ImageFullScreenView.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

class ImageFullScreenView: UIView {
    private var image: ImageViewState?
    weak var delegate: ImageActionsDelegate?
    
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
    
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = Color.darkGray
        view.hidesWhenStopped = true
        return view
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Fonts.regular
        label.textColor = Color.darkGray
        label.lineBreakMode = .byTruncatingHead
        label.textAlignment = .left
        return label
    }()
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.65
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.alpha = 0.35
        return view
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "share-icon"), for: .normal)
        button.tintColor = Color.darkGray
        button.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close-icon"), for: .normal)
        button.alpha = 0.35
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private var downloadButton = LoadingButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }
    
    func bind(_ image: ImageViewState) {
        loadingView.stopAnimating()
        self.image = image
        imageView.image = image.image
        backgroundColor = image.colors.textColor
        backgroundView.backgroundColor = image.colors.imageColor
        containerView.backgroundColor = image.colors.containerColor
        authorLabel.textColor = image.colors.textColor
        authorLabel.text = image.author.name
        shareButton.tintColor = image.colors.textColor
        downloadButton.tintColor = image.colors.textColor
        closeButton.tintColor = image.colors.textColor
    }
    
    func loading() {
        loadingView.startAnimating()
    }
    
    func downloadButton(isLoading: Bool) {
        downloadButton.load(isLoading)
    }
    
    private func setup() {
        addSubview(backgroundView)
        addSubview(loadingView)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        imageView.addGestureRecognizer(pinch)
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        addSubview(closeButton)
        containerView.addSubview(authorLabel)
        containerView.addSubview(shareButton)
        containerView.addSubview(downloadButton)
        downloadButton.downloadButtonAction = { [weak self] in
            self?.delegate?.download()
        }
        addSubview(containerView)
        setupLayout()
    }
    
    private func setupLayout() {
        backgroundView.pinToSuperviewEdges()
        loadingView.pinToSuperviewEdges()
        imageView.pinToSuperview(edges: [.left, .right])
        containerView.pinToSuperview(edges: [.left, .right, .bottom])
        containerView.addHeightConstraint(with: 50 + screenSafeAreaInsets.bottom)
        imageView.pin(edge: .bottom, to: .top, of: containerView)
        if #available(iOS 13.0, *) {
            setupiOS13Layout()
        } else {
            setupiOS12Layout()
        }
        setupContainerViewChildren()
    }
    
    private func setupiOS13Layout() {
        closeButton.isHidden = true
        imageView.pinToSuperview(edges: [.top], constant: 8)
    }
    
    private func setupiOS12Layout() {
        //FOR iOS 12 under the push is full screen and we need screen safe area insets
        imageView.pinToSuperview(edges: [.top], constant: 8 + screenSafeAreaInsets.top)
        
        closeButton.pinToSuperviewTop(constant: 8 + screenSafeAreaInsets.top)
        closeButton.pinToSuperviewRight()
        closeButton.addWidthConstraint(with: 35)
        closeButton.addHeightConstraint(with: 35)
    }
    
    private func setupContainerViewChildren() {
        authorLabel.pinToSuperviewLeft(constant: 16)
        authorLabel.pinToSuperviewTop(constant: 8)
        authorLabel.pin(edge: .right, to: .left, of: downloadButton, constant: 16, relatedBy: .greaterThanOrEqual)
        
        shareButton.pinToSuperview(edges: [.top], constant: 8)
        shareButton.pinToSuperviewRight(constant: -8)
        shareButton.addHeightConstraint(with: 35)
        shareButton.addWidthConstraint(with: 35)
        
        downloadButton.pinToSuperview(edges: [.top], constant: 8)
        downloadButton.pin(edge: .right, to: .left, of: shareButton, constant: -16)
        downloadButton.addHeightConstraint(with: 35)
        downloadButton.addWidthConstraint(with: 35)
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareImage()
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) ?? CGAffineTransform(scaleX: 1, y: 1)
        sender.scale = 1.0
    }
}
