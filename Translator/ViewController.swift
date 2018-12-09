//
//  ViewController.swift
//  Translator
//
//  Created by Евгений on 05/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    
    
    var messages: [Message] = []
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLayoutSubviews() {
        table.delegate=self
        table.dataSource=self
        
        var components = URLComponents.init(string: "https://translate.yandex.net/api/v1.5/tr.json/translate")
        
        let key = "trnsl.1.1.20181206T055317Z.85da48f152017968.c654d68a5e6f9d84366a3b6c00f92f2c5ef838bc"
        
        let text = "queue"
        
        let lang = "en-ru"
        
        components?.query="key=\(key)&text=\(text)&lang=\(lang)"
        if let url = components?.url {
            defaultSession.dataTask(with: url) { data, response, error in
                //if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                DispatchQueue.main.async {
                    if let data = data, let message=try? JSONDecoder().decode(Message.self, from: data) {
                        self.messages.append(message)
                    }
                    self.table.reloadData()
                }
                
                }.resume()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Out", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].text
            
        return cell
    }
}


