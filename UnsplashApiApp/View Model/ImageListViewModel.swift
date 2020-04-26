//
//  ImageListViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 19/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation
import UIKit

final class ImageListViewModel {
    private var images: [ImageViewModel] = []
    var imageFinishedDownloading: ((Result<ImageViewState, Error>) -> ())?
    
    var currentCount: Int {
        return images.count
    }
    
    func image(at index: Int) -> ImageViewModel {
        return images[index]
    }
    
    func fetchNextPage(_ searchParameters: SearchParameters, completion: @escaping (Result<[IndexPath], Error>) -> ()) {
        fetchImageList(searchParameters: searchParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                self.images += images
                images.forEach(self.fetchImages(_:))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func fetchNewQuery(_ searchParameters: SearchParameters, completion: @escaping (Result<[IndexPath], Error>) -> ()) {
        fetchImageList(searchParameters: searchParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                self.images = images
                images.forEach(self.fetchImages(_:))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func fetchImageList(searchParameters: SearchParameters, completion: @escaping (Result<[ImageViewModel], Error>) -> ()) {
        let request = APIRequest.imageRequest(searchParameters: searchParameters)
        let resource = Resource<Pagination>(get: request)
        Dependencies.enviroment.mainSession.load(resource) { result in
            switch result {
            case .success(let pagination):
                let images = pagination.results.map(ImageViewModel.init(image:))
                completion(.success(images))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func fetchImages(_ image: ImageViewModel) {
        image.fetchImage(ofSize: .small) { [weak self] result in
            //TODO: Error handeling, retry the image
            self?.imageFinishedDownloading?(result)
        }
    }
}

private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}
