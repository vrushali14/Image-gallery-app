//
//  ImageGalleryTests.swift
//  ImageGalleryTests
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import XCTest
@testable import ImageGallery

class ImageGalleryTests: XCTestCase {

    var session: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        session = URLSession(configuration: .default)
    }

    func testAPICallSearchPhotos() {
        
        let urlString = "\(baseURL)?method=flickr.photos.search&api_key=\(API_KEY)&tags=kitten&page=1&format=json&nojsoncallback=1"
        
        let promise = expectation(description: "Status code: 200")
        
        if let url = URL(string: urlString) {
            session.dataTask(with : url) { data, res, err in
                
                if let err = err {
                    XCTFail("Error: \(err.localizedDescription)")
                    return
                } else if let statusCode = (res as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        promise.fulfill()
                    } else {
                        XCTFail("Status code: \(statusCode)")
                    }
                }
            }.resume()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func testAPICallGetPhotoURL() {
        
        let urlString = "\(baseURL)?method=flickr.photos.getSizes&api_key=\(API_KEY)&photo_id=50371661108&format=json&nojsoncallback=1"
        
        let promise = expectation(description: "Status code: 200")
        
        if let url = URL(string: urlString) {
            session.dataTask(with : url) { data, res, err in
                
                if let err = err {
                    XCTFail("Error: \(err.localizedDescription)")
                    return
                } else if let statusCode = (res as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        promise.fulfill()
                    } else {
                        XCTFail("Status code: \(statusCode)")
                    }
                }
            }.resume()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        session = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
