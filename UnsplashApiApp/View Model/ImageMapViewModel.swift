//
//  ImageMapViewModel.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 27/04/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation

final class ImageMapViewModel {
    private var images: [ImageFull] = []
    var imageviewStateCompleted: ((Result<ImageViewState, Error>) -> ())?
    
    //TODO: Do this better later on
    func fetchImages(_ searchParameters: SearchParameters, completion: @escaping (Result<[ImageViewModel], Error>) -> ()) {
        let request = APIRequest.listImagesRequest(searchParameters: searchParameters)
        let resource = Resource<Pagination>(get: request)
        Dependencies.enviroment.mainSession.load(resource) { result in
            switch result {
            case .success(let pagination):
                pagination.results.forEach{ self.fetchImage($0.id) }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func fetchImage(_ imageID: String) {
        let request = APIRequest.imageRequest(imageId: imageID)
        let resource = Resource<ImageFull>(get: request)
        Dependencies.enviroment.mainSession.load(resource) { result in
            switch result {
            case .success(let image):
                self.images.append(image)
                let viewState = ImageViewState(image: image)
                self.imageviewStateCompleted?(.success(viewState))
            case .failure: break
            }
        }
    }
}
