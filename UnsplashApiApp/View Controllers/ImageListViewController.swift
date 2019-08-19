//
//  ImageListViewController.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 12/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var imageList: ImageList?
    private var imageCellStyle: CellStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        imageCellStyle = CellStyle(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), defaultSize: CGSize(width: view.bounds.width, height: 300))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchImageList(search: SearchParameters.initialParameters)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
    }
    
    private func fetchImageList(search: SearchParameters) {
        let request = ImageAPIRequest(search: search)
        let resource = Resource<Pagination>(get: request)
        Dependencies.dependencies.session.load(resource, completion: { [weak self] response in
            self?.imageList = response?.results
            self?.reloadData()
        })
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath)
        }
        guard let image = imageList?[indexPath.row] else {
            return cell
        }
        let viewModel = ImageViewModel(image: image, actions: nil)
        cell.update(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = imageList?[indexPath.row] else {
            return
        }
        let imageFullController = ImageFullViewController(image: image)
        present(imageFullController, animated: true, completion: nil)
    }
}

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = imageList?[indexPath.row] else {
            return imageCellStyle?.defaultSize ?? .zero
        }
        return image.sizeFor(collectionWidth: collectionView.bounds.width, insets: imageCellStyle?.insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return imageCellStyle?.insets ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return imageCellStyle?.insets.left ?? 0
    }
}

private extension SearchParameters {
    static var initialParameters: SearchParameters {
        return SearchParameters(searchType: .photos,
                                query: "barcelona",
                                page: 1)
    }
}
