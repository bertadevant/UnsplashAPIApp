//
//  Get.swift
//  UnsplashApiApp
//
//  Created by Berta Devant on 01/05/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//

import Foundation

//If this app was modular this would be private and not seen outside of Network module
//If we wanted to use a pod, this would be substitute but NetworkSession would remain the same
class Fetcher {
    private let urlSession: URLSession = .shared
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func get(completion: @escaping (Data?, Error?) -> ()) {
        urlSession.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }
    
    func cancel() {
        urlSession.dataTask(with: request).cancel()
    }
}
