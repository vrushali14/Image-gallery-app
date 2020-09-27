//
//  PhotoSize.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct PhotoSize : Codable {
    
    let label : String?
    let source : String?
    
    enum CodingKeys : String, CodingKey {
        case label
        case source
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        source = try values.decodeIfPresent(String.self, forKey: .source)
    }
    
}
