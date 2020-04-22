//
//  ImageListViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 19/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

protocol ImageListViewModelDelegate: class {
    func onFetchCompleted(reloadIndexPaths: [IndexPath]?)
    func onFetchFailed(error: String)
}

final class ImageListViewModel {
    weak var delegate: ImageListViewModelDelegate?
    private var images: [ImageViewModel] = []
    private var loading: Bool = false
    
    var currentCount: Int {
        return images.count
    }
    
    var isFetchingResults: Bool {
        return loading
    }
    
    func image(at index: Int) -> ImageViewModel {
        return images[index]
    }
    
    func fetchNextPage(_ searchParameters: SearchParameters) {
        fetchImageList(searchParameters: searchParameters) { [weak self] images in
            self?.images += images
            self?.delegate?.onFetchCompleted(reloadIndexPaths: [])
        }
    }
    
    func fetchNewQuery(_ searchParameters: SearchParameters) {
        fetchImageList(searchParameters: searchParameters) { [weak self] images in
            self?.images = images
            self?.delegate?.onFetchCompleted(reloadIndexPaths: [])
        }
    }
    
    private func fetchImageList(searchParameters: SearchParameters, completion: @escaping ([ImageViewModel]) -> ()) {
        let request = APIRequest.imageRequest(searchParameters: searchParameters)
        let resource = Resource<Pagination>(get: request)
        loading = true
        Dependencies.enviroment.session.load(resource) { [weak self] response in
            self?.loading = false
            guard let response = response, !response.results.isEmpty else {
                self?.delegate?.onFetchFailed(error: "No response found")
                return
            }
            let images = response.results.map(ImageViewModel.init(image:))
            images.forEach{ $0.delegate = self }
            completion(images)
        }
    }
}

extension ImageListViewModel: ImageDelegate {
    func imageSaved(_ image: UIImage, _ error: Error?, _ context: UnsafeMutableRawPointer?) {}
    
    func imageState(_ state: ImageState) {
        switch state {
        case .loading: break
        case .image: delegate?.onFetchCompleted(reloadIndexPaths: [])
        //TODO: error handeling
        case .error: break
        }
    }
}


private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}
