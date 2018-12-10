//
//  ViewController.swift
//  Translator
//
//  Created by Евгений on 05/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    var translations: [Translation] = []
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var chosenLanguageFrom: Translation.Language = .english
    var chosenLanguageTo: Translation.Language = .russian
    
    @IBOutlet weak var inputField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate=self
        table.dataSource=self
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func sendButtonPress(_ sender: UIButton) {
        let key = "trnsl.1.1.20181206T055317Z.85da48f152017968.c654d68a5e6f9d84366a3b6c00f92f2c5ef838bc"
        
        var components = URLComponents.init(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
        
        if let text = inputField?.text {
            var translation = Translation()
            translation.originalText=text
            translation.languageFrom=chosenLanguageFrom
            translation.languageTo=chosenLanguageTo
            let queryLang = "\(chosenLanguageFrom.rawValue)-\(chosenLanguageTo.rawValue)"
            components?.query="key=\(key)&text=\(text)&lang=\(queryLang)"
            if let url = components?.url {
                defaultSession.dataTask(with: url) { data, response, error in
                    //if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    DispatchQueue.main.async {
                        if let data = data, let translationResponse = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                            translation.translatedText = translationResponse.translatedText
                            translation.date = Date.init()
                            self.translations.insert(translation, at: 0)
                            }
                        self.table.reloadData()
                    }
                }.resume()
            }
        }
        
        
        
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Out", for: indexPath)
        cell.textLabel?.text = translations[indexPath.row].translatedText
        cell.detailTextLabel?.text = translations[indexPath.row].originalText
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}


