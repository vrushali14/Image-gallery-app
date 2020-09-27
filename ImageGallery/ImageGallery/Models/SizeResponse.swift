//
//  SizeResponse.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct SizeResponse : Codable {
    
    var sizeData : SizeData?
    
    enum CodingKeys : String, CodingKey {
        case sizeData = "sizes"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sizeData = try values.decodeIfPresent(SizeData.self, forKey: .sizeData)
        
    }
}
