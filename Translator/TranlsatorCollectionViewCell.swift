//
//  TransatorTableViewCell.swift
//  Translator
//
//  Created by Евгений on 11/12/2018.
//  Copyright © 2018 Evgenii. All rights reserved.
//

import UIKit

class TranslatorCollectionViewCell: UICollectionViewCell {
    
    let translatedText: UITextView = {
        let view = UITextView()
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor.white
        view.backgroundColor = UIColor.clear
        view.isEditable = false
        return view
    }()
    
    let originalText: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.white
        view.backgroundColor = UIColor.clear
        view.isEditable = false
        return view
    }()
    
    let bubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bubble)
        contentView.addSubview(originalText)
        contentView.addSubview(translatedText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
