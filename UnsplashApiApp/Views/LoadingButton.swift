//
//  LoadingButton.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 05/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit

class LoadingButton: UIView {
    private var isLoading: Bool = false
    private let loadingIndicator = UIActivityIndicatorView()
    private var button: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "download-icon"), for: .normal)
        button.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    var downloadButtonAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        addSubview(loadingIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        loadingIndicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
        button.pinToSuperviewEdges()
    }
    
    func load(_ load: Bool) {
        guard load else {
            stopLoading()
            return
        }
        startLoading()
    }
    
    @objc func downloadButtonTapped(_ sender: UIButton) {
        downloadButtonAction?()
    }
    
    private func startLoading() {
        guard !isLoading else { return }
        button.isEnabled = false
        isLoading = true
        loadingIndicator.startAnimating()
    }
    
    private func stopLoading() {
        button.isEnabled = true
        isLoading = false
        loadingIndicator.stopAnimating()
    }
}
