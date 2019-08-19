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
    private var imageCellStyle: CellStyle?
    private let viewModel = ImageListViewModel()
    private var searchParameters: SearchParameters = .initialParameters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupCollectionView()
        imageCellStyle = CellStyle(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), defaultSize: CGSize(width: view.bounds.width, height: 300))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchImageList(searchParameters: searchParameters)
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
    
    private func reloadData(on pathsToReload: [IndexPath]?) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath)
        }
        let image = viewModel.image(at: indexPath.row)
        let viewModel = ImageViewState(image: image, actions: nil)
        cell.update(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.image(at: indexPath.row)
        let imageFullController = ImageFullViewController(image: image)
        present(imageFullController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView.isNearBottomEdge(padding: 50) else {
            return
        }
        print("👾 isNearBottomEdge")
        self.searchParameters = searchParameters.nextPage()
        viewModel.fetchImageList(searchParameters: searchParameters)
    }
}

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = viewModel.image(at: indexPath.row)
        return image.sizeFor(collectionWidth: collectionView.bounds.width, insets: imageCellStyle?.insets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return imageCellStyle?.insets ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return imageCellStyle?.insets.left ?? 0
    }
}

extension ImageListViewController: ImageListViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        reloadData(on: newIndexPathsToReload)
    }
    
    func onFetchFailed(with reason: String) { }
    
    
}

private extension SearchParameters {
    static var initialParameters: SearchParameters {
        return SearchParameters(searchType: .photos,
                                query: "barcelona",
                                page: 1)
    }
}

private extension UICollectionView {
    func isNearBottomEdge(padding: CGFloat) -> Bool {
        return self.contentOffset.y >= (self.contentSize.height - self.frame.height - padding)
    }
}
