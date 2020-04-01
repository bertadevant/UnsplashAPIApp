//
//  TestSpy.swift
//  UnsplashApiAppTests
//
//  Created by Berta Devant on 30/03/2020.
//  Copyright © 2020 Berta Devant. All rights reserved.
//
import XCTest

protocol TestSpy: class {
    associatedtype Method: Equatable
    var recordedMethods: [Method] { get set }
    var recordedParameters: [AnyHashable] { get set }
}

// MARK: Record
extension TestSpy {
    func record(_ method: Method) {
        recordedMethods.append(method)
    }
    func recordParameters(_ parameter: AnyHashable) {
        recordedParameters.append(parameter)
    }
}

// MARK: Assertions
extension TestSpy {
    func assertEmpty(file: StaticString = #file,
                     line: UInt = #line) {
        guard recordedMethods.count == 0 else {
            XCTFail("Spy was expected empty, but found: \(recordedMethods) ",
                file: file,
                line: line)
            return
        }
    }

    func assertEqual(_ method: Method...,
                     file: StaticString = #file,
                     line: UInt = #line) {
        guard recordedMethods == method else {
            XCTFail("Spy was expecting \(method) but found: \(recordedMethods) ",
                file: file,
                line: line)
            return
        }
        recordedMethods.removeAll()
    }
    
    func assertContains(_ method: Method...,
                        file: StaticString = #file,
                        line: UInt = #line) {
        guard recordedMethods.count > 0 else {
            XCTFail("Spy should contains \(method) but nothing has been recorded",
                file: file,
                line: line)
            return
        }

        guard recordedMethods == method else {
            XCTFail("Spy was expecting \(method) but found: \(recordedMethods)",
                file: file,
                line: line)
            return
        }
        recordedMethods.removeAll()
    }

    func assertDoesNotContains(_ method: Method...,
                               file: StaticString = #file,
                               line: UInt = #line) {
        guard recordedMethods.count > 0 else {
            XCTFail("Spy should contains \(method) but nothing has been recorded",
                file: file,
                line: line)
            return
        }
        guard recordedMethods != method else {
            XCTFail("Spy should not record \(method) but found: \(recordedMethods)",
                file: file,
                line: line)
            return
        }
    }
    
    func assertParameterEqual(_ parameter: AnyHashable,
                              file: StaticString = #file,
                              line: UInt = #line) {
        guard recordedParameters == [parameter] else {
            XCTFail("Spy was expecting \(parameter) but found: \(recordedParameters) ",
                file: file,
                line: line)
            return
        }
        recordedParameters.removeAll()
    }
}

