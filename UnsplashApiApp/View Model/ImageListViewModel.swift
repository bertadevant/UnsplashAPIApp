//
//  ImageListViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 19/08/2019.
//  Copyright © 2019 Berta Devant. All rights reserved.
//

import Foundation

protocol ImageListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class ImageListViewModel {
    weak var delegate: ImageListViewModelDelegate?
    private var pagination: Pagination = .initalResults
    private var searchParameters: SearchParameters = .initialParameters
    private var currentPage: Int = 0
    private var isFetchInProgress = false
    
    var currentCount: Int {
        return pagination.results.count
    }
    
    func image(at index: Int) -> ImageViewState {
        return pagination.results[index].viewState()
    }
    
    func fetchNextPage() {
        let searchParameters = self.searchParameters.nextPage()
        let currentImages = pagination.results
        fetchImageList(searchParameters: searchParameters) { [weak self] response in
            self?.pagination = Pagination(total_pages: response.total_pages,
                                          total: response.total,
                                          results: currentImages + response.results)
            self?.delegate?.onFetchCompleted(with: [])
        }
    }
    
    func fetchImageList(query: String) {
        let parameters = SearchParameters(query: query)
        self.searchParameters = parameters
        fetchImageList(searchParameters: parameters) { [weak self] response in
            self?.pagination = response
            self?.delegate?.onFetchCompleted(with: [])
        }
    }

    private func fetchImageList(searchParameters: SearchParameters, completion: @escaping (Pagination) -> ()) {
        let request = ImageAPIRequest(search: searchParameters)
        let resource = Resource<Pagination>(get: request)
        Dependencies.dependencies.session.load(resource) { [weak self] response in
            guard let response = response,
                !response.results.isEmpty else {
                self?.delegate?.onFetchFailed(with: "No response found")
                return
            }
            completion(response)
        }
    }
}

private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}

private extension SearchParameters {
    static var initialParameters: SearchParameters {
        return SearchParameters(searchType: .photos,
                                query: "barcelona",
                                page: 1)
    }
}
