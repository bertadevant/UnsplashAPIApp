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
    private var results: Pagination = .initalResults
    private var currentPage: Int = 0
    private var isFetchInProgress = false
    
    var totalCount: Int {
        return results.total
    }
    
    var currentCount: Int {
        return results.results.count
    }
    
    func image(at index: Int) -> Image {
        return results.results[index]
    }

    func fetchImageList(searchParameters: SearchParameters) {
        let request = ImageAPIRequest(search: searchParameters)
        let resource = Resource<Pagination>(get: request)
        let currentImages = results.results
        Dependencies.dependencies.session.load(resource, completion: { [weak self] response in
            guard let response = response,
                !response.results.isEmpty else {
                self?.delegate?.onFetchFailed(with: "No response found")
                return
            }
            self?.results = Pagination(total_pages: response.total_pages,
                                       total: response.total,
                                       results: currentImages + response.results)
            self?.delegate?.onFetchCompleted(with: [])
        })
    }
}

private extension Pagination {
    static var initalResults = Pagination(total_pages: 1, total: 1, results: [])
}
