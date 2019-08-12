//
//  ImageCollectionViewCell.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return "ImageCell"
    }
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = Fonts.regular
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This view is not designed to be used with xib or storyboard files")
    }
    
    func update(with image: ImageViewModel) {
        imageView.imageFromServerURL(image.imageSmall, placeHolder: #imageLiteral(resourceName: "placeholder-square"))
        backgroundColor = image.color ?? .white
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(authorLabel)
        setupLayout()
        backgroundColor = .white
    }
    
    private func setupLayout() {
        imageView.pinToSuperviewEdges()
    }
}
