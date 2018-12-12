//
//  Message.swift
//  Translator
//
//  Created by Евгений on 08/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import Foundation

struct TranslationResponse {
    var translatedText: String?
    var language: String?
    var code: Int?
    
    init(translatedText: String?, language: String?, code: Int?){
        self.translatedText = translatedText
        self.language = language
        self.code=code
    }
}

extension TranslationResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case text, code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let language: String? = try? container.decode(String.self, forKey: .language)
        let code: Int? = try? container.decode(Int.self, forKey: .code)
        var textContainer = try container.nestedUnkeyedContainer(forKey: .text)
        let text = try? textContainer.decode(String.self)
        self.init(translatedText: text, language: language, code: code)
    }
}

