//
//  TransatorTableViewCell.swift
//  Translator
//
//  Created by Евгений on 11/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit

class TranslatorTableViewCell: UITableViewCell {
    
    var translatedText: UITextView?
    
    var originalText: UITextView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        originalText = UITextView()
        originalText?.font = UIFont.systemFont(ofSize: 10)
        
        translatedText = UITextView()
        translatedText?.font = UIFont.systemFont(ofSize: 18)
        
        contentView.addSubview(originalText!)
        contentView.addSubview(translatedText!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}
