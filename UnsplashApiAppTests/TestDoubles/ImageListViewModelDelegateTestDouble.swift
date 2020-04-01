//
//  ImageListViewModelDelegateTestDouble.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 30/03/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//
import Foundation
@testable import UnsplashApiApp

class ImageListViewModelDelegateSpy: ImageListViewModelDelegate, TestSpy {
    
    enum Method {
        case onFetchCompleted
        case onFetchFailed
    }
    var recordedMethods: [ImageListViewModelDelegateSpy.Method] = []
    var recordedParameters: [AnyHashable] = []
    
    func onFetchCompleted(reloadIndexPaths newIndexPathsToReload: [IndexPath]?) {
        record(.onFetchCompleted)
        recordParameters(newIndexPathsToReload)
    }
    
    func onFetchFailed(error reason: String) {
        record(.onFetchFailed)
        recordParameters(reason)
    }
}
