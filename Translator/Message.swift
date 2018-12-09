//
//  Message.swift
//  Translator
//
//  Created by Евгений on 08/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import Foundation

struct Message {
    var text: String?
    var language: String?
    var date: Date
    
    
    
    init(text: String?, language: String?, date: Date){
        self.text = text
        self.language = language
        self.date = date
    }
}

extension Message: Decodable {
    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //let text: String? = try? container.decode(String.self, forKey: .text)
        let language: String? = try? container.decode(String.self, forKey: .language)
        let date = Date.init()
        
        var textContainer = try container.nestedUnkeyedContainer(forKey: .text)
        let text = try? textContainer.decode(String.self)
        self.init(text: text, language: language, date: date)
    }
}
struct TranslationResponse {
    var Translation: [Message]
    
    
}
