//
//  ViewController.swift
//  Translator
//
//  Created by Евгений on 05/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var ruButton: UIButton!
    @IBOutlet weak var enButton: UIButton!
    @IBOutlet weak var enConstraint: NSLayoutConstraint!
    @IBOutlet weak var ruConstraint: NSLayoutConstraint!
    
    
    @IBAction func clearInput(_ sender: UIButton) {
        inputField.text = nil
    }
    
    var translations: [Translation] = []
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var chosenLanguageFrom: String = "en"
    var chosenLanguageTo: String {
        return chosenLanguageFrom == "en" ? "ru" : "en"
    }
    
    var queryLang: String {
        return "\(chosenLanguageFrom)-\(chosenLanguageTo)"
    }
    @IBOutlet weak var inputField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.inputField.frame.height))
        inputField.leftView = paddingView
        inputField.leftViewMode = UITextField.ViewMode.always

        adjustViewsForLanguage()
     
        chatView.delegate=self
        chatView.dataSource=self
        chatView.transform = CGAffineTransform(scaleX: 1, y: -1)
        chatView.register(TranslatorCollectionViewCell.self, forCellWithReuseIdentifier: "custom")
        
        loadData()
    }
    
    
    
    @IBOutlet weak var chatView: UICollectionView!
    @IBAction func sendButtonPress(_ sender: UIButton) {
        let key = "trnsl.1.1.20181206T055317Z.85da48f152017968.c654d68a5e6f9d84366a3b6c00f92f2c5ef838bc"
        var components = URLComponents.init(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
        
        if let text = inputField?.text {
            inputField.text = nil
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
                                
                                self.loadData()
                               
                            }
                           
                        }
                    }
                }.resume()
            }
        }
    }
    
    func loadData (){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<Translation>(entityName: "Translation")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            translations = try! context.fetch(fetchRequest)
            chatView.reloadData()
        }
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        chosenLanguageFrom = chosenLanguageFrom == "en" ? "ru" : "en"
        adjustViewsForLanguage()
    }
    
    func adjustViewsForLanguage () {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if self.chosenLanguageFrom == "en" {
                self.inputField.backgroundColor = UIColor.init(red: 0, green: 124/255, blue: 233/255, alpha: 1)
                self.inputField.placeholder = "Английский"
                
                self.ruConstraint.constant = 12
                self.enConstraint.constant = 3
                self.view.bringSubviewToFront(self.enButton)
                self.view.layoutIfNeeded()
            } else {
                self.inputField.backgroundColor = UIColor.init(red: 237/255, green: 76/255, blue: 92/255, alpha: 1)
                self.inputField.placeholder = "Русский"
                self.ruConstraint.constant = 3
                self.enConstraint.constant = 12
                self.view.bringSubviewToFront(self.ruButton)
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return translations.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath)
        if let customCell = cell as? TranslatorCollectionViewCell {
            
            customCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    
            customCell.originalText.text = translations[indexPath.row].originalText
            customCell.translatedText.text = translations[indexPath.row].translatedText
            
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedOriginalFrame = NSString(string: customCell.originalText.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: customCell.originalText.font!], context: nil)
            let estimatedTranslatedFrame = NSString(string: customCell.translatedText.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: customCell.translatedText.font!], context: nil)
            
            if translations[indexPath.row].languageFrom == "en" {
                let width = max(estimatedOriginalFrame.width, estimatedTranslatedFrame.width) + 26
                let height = estimatedOriginalFrame.height + estimatedTranslatedFrame.height + 30
                
                customCell.originalText.frame = CGRect(x: 0, y: 0, width: estimatedOriginalFrame.width + 16, height: estimatedOriginalFrame.height + 10)
                customCell.translatedText.frame = CGRect(x: 0, y: customCell.originalText.frame.height - 5, width: estimatedTranslatedFrame.width + 16, height: estimatedTranslatedFrame.height + 10)
                
                customCell.bubble.frame = CGRect(x: 0, y: 0, width: width, height: height)
                customCell.bubble.backgroundColor = UIColor.init(red: 0, green: 124/255, blue: 233/255, alpha: 1)
            } else {
                let width = max(estimatedOriginalFrame.width, estimatedTranslatedFrame.width) + 26
                let height = estimatedOriginalFrame.height + estimatedTranslatedFrame.height + 30
                
                customCell.originalText.frame = CGRect(x: chatView.frame.width - width, y: 0, width: estimatedOriginalFrame.width + 16, height: estimatedOriginalFrame.height + 10)
                customCell.translatedText.frame = CGRect(x: chatView.frame.width - width, y: customCell.originalText.frame.height - 5, width: estimatedTranslatedFrame.width + 16, height: estimatedTranslatedFrame.height + 10)
                
                customCell.bubble.frame = CGRect(x: chatView.frame.width - width, y: 0, width: width, height: height)
                customCell.bubble.backgroundColor = UIColor.init(red: 237/255, green: 76/255, blue: 92/255, alpha: 1)
            }
            
            return customCell
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let originalText = translations[indexPath.row].originalText, let translatedText = translations[indexPath.row].translatedText {
            let originalSize = CGSize(width: 250, height: 1000)
            let originalOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let originalEstimatedFrame = NSString(string: originalText).boundingRect(with: originalSize, options: originalOptions, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let translatedSize = CGSize(width: 250, height: 1000)
            let translatedOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let translatedEstimatedFrame = NSString(string: translatedText).boundingRect(with: translatedSize, options: translatedOptions, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: chatView.frame.width, height: originalEstimatedFrame.height + translatedEstimatedFrame.height + 30)
        }
        

        
        return CGSize(width: view.frame.width - 10, height: 100)

    }
    
    
    
}


