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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        translatedText = UITextView.init(frame: contentView.bounds)
        
        
        contentView.addSubview(translatedText!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}
