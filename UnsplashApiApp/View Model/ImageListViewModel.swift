//
//  ImageListViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 19/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

protocol ImageListViewModelDelegate: class {
    func onFetchCompleted(reloadIndexPaths: [IndexPath]?)
    func onFetchFailed(error: String)
}

final class ImageListViewModel {
    weak var delegate: ImageListViewModelDelegate?
    private var response: Pagination = .initalResults
    private var loading: Bool = false
    
    var currentCount: Int {
        return response.results.count
    }
    
    var isFetchingResults: Bool {
        return loading
    }
    
    func image(at index: Int) -> ImageViewState {
        return response.results[index].viewState()
    }
    
    func fetchNextPage(_ searchParameters: SearchParameters) {
        fetchImageList(searchParameters: searchParameters) { [weak self] response in
            self?.response.results += response.results
            self?.delegate?.onFetchCompleted(reloadIndexPaths: [])
        }
    }
    
    func fetchNewQuery(_ searchParameters: SearchParameters) {
        fetchImageList(searchParameters: searchParameters) { [weak self] response in
            self?.response = response
            self?.delegate?.onFetchCompleted(reloadIndexPaths: [])
        }
    }
    
    private func fetchImageList(searchParameters: SearchParameters, completion: @escaping (Pagination) -> ()) {
        let request = ImageAPIRequest(search: searchParameters)
        let resource = Resource<Pagination>(get: request)
        loading = true
        Dependencies.enviroment.session.load(resource) { [weak self] response in
            self?.loading = false
            guard let response = response, !response.results.isEmpty else {
                    self?.delegate?.onFetchFailed(error: "No response found")
                    return
            }
            completion(response)
        }
    }
}

private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}
