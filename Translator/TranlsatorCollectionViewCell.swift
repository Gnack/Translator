//
//  TransatorTableViewCell.swift
//  Translator
//
//  Created by Евгений on 11/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit

class TranslatorCollectionViewCell: UICollectionViewCell {
    
    let translatedText: UITextView = UITextView()
    
    let originalText: UITextView = UITextView()
    
    let bubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatedText.font = UIFont.boldSystemFont(ofSize: 18)
        translatedText.textColor = UIColor.white
        translatedText.backgroundColor = UIColor.clear
        
        originalText.font = UIFont.systemFont(ofSize: 14)
        originalText.textColor = UIColor.white
        originalText.backgroundColor = UIColor.clear
        
        contentView.addSubview(bubble)
        contentView.addSubview(originalText)
        contentView.addSubview(translatedText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
