//
//  ImageFetchAPI.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

let baseURL = "https://api.flickr.com/services/rest/"
let API_KEY = "f9cc014fa76b098f9e82f1c288379ea1"

class ImageFetchAPI {
    
    let dispatchGroup = DispatchGroup()
    
    func searchImageByTag(tag: String, page: Int, completion : @escaping (ResponseModel, Error?) -> ()) {
        
        let urlString = "\(baseURL)?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(tag)&page=\(page)&format=json&nojsoncallback=1"
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with : url) { data, res, err in
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    if let response = try? decoder.decode(ResponseModel.self, from:data) {
                        completion(response, err)
                    }
                }
                
            }.resume()
        }
        
    }
    
    func callAsyncRequests(photoIdArray : [String], completion : @escaping ([SizeData]) -> ()) {
        
        var sizeDataArray: [SizeData] = []
        
        for id in photoIdArray {
            
            self.getImageURLFrom(photoId : id) { (res) in
                sizeDataArray.append(res.sizeData!)
                //print(res)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            //print("all finished")
            completion(sizeDataArray)
        }
    }
    
    func getImageURLFrom(photoId: String, completion : @escaping (SizeResponse) -> ()) {
        
        dispatchGroup.enter()
        let urlString = "\(baseURL)?method=flickr.photos.getSizes&api_key=\(API_KEY)&photo_id=\(photoId)&format=json&nojsoncallback=1"
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with : url) { data, res, err in
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    if let response = try? decoder.decode(SizeResponse.self, from:data) {
                        self.dispatchGroup.leave()
                        completion(response)
                    }
                }
                
            }.resume()
        }
    }
    
    
}
