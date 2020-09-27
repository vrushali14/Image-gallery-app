//
//  ResponseModel.swift
//  ImageGallery
//
//  Created by Jadhav, V. A. on 25/09/2020.
//  Copyright © 2020 Vrushali. All rights reserved.
//

import Foundation

struct ResponseModel : Codable {
    
    var data : DataModel?
    var stat : String?
    
    enum CodingKeys : String, CodingKey {
        case data = "photos"
        case stat
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(DataModel.self, forKey: .data)
        stat = try values.decodeIfPresent(String.self, forKey: .stat)
    }
}
