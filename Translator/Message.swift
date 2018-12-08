//
//  Message.swift
//  Translator
//
//  Created by Евгений on 08/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import Foundation

struct Message: Codable {
    var text: String
    var language: String
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case text
        case language = "lang"
    }
}
