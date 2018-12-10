//
//  DetectionResponse.swift
//  Translator
//
//  Created by Евгений on 10/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import Foundation

struct DetectionResponse {
    var detectedLanguage: String?
    var code: Int?
    
    init(detectedLanguage: String?, code: Int?){
        self.detectedLanguage = detectedLanguage
        self.code=code
    }
}

extension DetectionResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case detectedLanguage = "lang"
        case code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let detectedLanguage: String? = try? container.decode(String.self, forKey: .detectedLanguage)
        let code: Int? = try? container.decode(Int.self, forKey: .code)
        self.init(detectedLanguage: detectedLanguage, code: code)
    }
}
