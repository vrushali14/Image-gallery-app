//
//  PhotoModel.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//


import Foundation

struct PhotoModel : Codable {
    
    let uniqueId : String?
    let title : String?
    
    enum CodingKeys : String, CodingKey {
        case uniqueId = "id"
        case title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uniqueId = try values.decodeIfPresent(String.self, forKey: .uniqueId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
}
