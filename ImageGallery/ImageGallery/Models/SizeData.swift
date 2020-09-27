//
//  SizeData.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct SizeData : Codable {
    
    let photoSizes : [PhotoSize]?
    
    enum CodingKeys : String, CodingKey {
        case photoSizes = "size"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photoSizes = try values.decodeIfPresent([PhotoSize].self, forKey: .photoSizes)
    }
    
}
