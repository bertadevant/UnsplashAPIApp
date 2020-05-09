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
    private var pendingRequests: [APIRequest] = []
    private let session: Session = Dependencies.enviroment.mainSession
    
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
        stopPendingRequests()
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
        guard pendingRequests.isEmpty else { return }
        pendingRequests.append(request)
        fetchList(request: request, completion: completion)
    }
    
    private func fetchList(request: APIRequest, completion: @escaping (Result<[ImageViewModel], Error>) -> ()) {
        let resource = Resource<Pagination>(get: request)
        session.load(resource) { result in
            self.pendingRequests.remove(request)
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
    
    private func stopPendingRequests() {
        pendingRequests.forEach({ session.cancel($0.urlRequest)})
        pendingRequests.removeAll()
    }
}

private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}

private extension Array where Element == APIRequest {
    mutating func remove(_ request: APIRequest) {
        guard let index = firstIndex(of: request) else { return }
        remove(at: index)
    }
}
