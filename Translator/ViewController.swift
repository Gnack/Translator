//
//  ViewController.swift
//  Translator
//
//  Created by Евгений on 05/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    var translations: [Translation] = []
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var chosenLanguageFrom: String = "en"
    var chosenLanguageTo: String = "ru"
    
    var queryLang: String {
        return "\(chosenLanguageFrom)-\(chosenLanguageTo)"
    }
    @IBOutlet weak var inputField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate=self
        table.dataSource=self
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        table.register(TranslatorTableViewCell.self, forCellReuseIdentifier: "custom")
        
    }
    
    
    @IBOutlet weak var table: UITableView!
   
    @IBAction func sendButtonPress(_ sender: UIButton) {
        let key = "trnsl.1.1.20181206T055317Z.85da48f152017968.c654d68a5e6f9d84366a3b6c00f92f2c5ef838bc"
        
        var components = URLComponents.init(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
        
        if let text = inputField?.text {
            
            
            components?.query="key=\(key)&text=\(text)&lang=\(queryLang)"
            
            if let url = components?.url {
                defaultSession.dataTask(with: url) { data, response, error in
                   DispatchQueue.main.async {
                        if let data = data, let translationResponse = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            if let context = appDelegate?.persistentContainer.viewContext {
                                let entity = NSEntityDescription.entity(forEntityName: "Translation", in: context)
                                let translation = Translation.init(entity: entity!, insertInto: context)
                                
                                translation.originalText=text
                                translation.languageFrom=self.chosenLanguageFrom
                                translation.languageTo=self.chosenLanguageTo
                                translation.translatedText = translationResponse.translatedText
                                translation.date = Date.init()
                                do {
                                    try context.save()
                                } catch let err {
                                    print(err)
                                }
                                
                                self.loadData(appDelegate: appDelegate!, context: context)
                                //self.translations.insert(translation, at: 0)
                            }
                           
                        }
                    }
                }.resume()
            }
        }
    }
    
    func loadData (appDelegate: AppDelegate, context: NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<Translation>(entityName: "Translation")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        translations = try! context.fetch(fetchRequest)
        table.reloadData()
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Out", for: indexPath)
//        cell.textLabel?.text = translations[indexPath.row].translatedText
//        cell.detailTextLabel?.text = translations[indexPath.row].originalText
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath)
        if let customCell = cell as? TranslatorTableViewCell {
            customCell.translatedText?.text = translations[indexPath.row].translatedText
            
            customCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            return customCell
        }

        return cell
    }
}


