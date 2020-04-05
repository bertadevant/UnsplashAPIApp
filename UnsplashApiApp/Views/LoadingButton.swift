//
//  LoadingButton.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 05/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    private var isLoading: Bool = false
    private var loadingIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(loadingIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonHeight = self.bounds.size.height
        let buttonWidth = self.bounds.size.width
        loadingIndicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
    }
    
    func load(_ load: Bool) {
        guard !isLoading else {
            stopLoading()
            return
        }
        startLoading()
      }
    
    private func startLoading() {
        isEnabled = false
        alpha = 0.5
        loadingIndicator.startAnimating()
    }
    
    private func stopLoading() {
        isEnabled = true
        alpha = 1.0
        loadingIndicator.stopAnimating()
    }
}
