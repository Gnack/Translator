//
//  Translation.swift
//  Translator
//
//  Created by Евгений on 10/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import Foundation
struct Translation {
    var translatedText: String?
    var originalText: String?
    var languageFrom: Language?
    var languageTo: Language?
    var date: Date?
    
    enum Language: String {
        case russian = "ru"
        case english = "en"
    }
}
