//
//  AttributedString+Symbols.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

extension NSMutableAttributedString {
    func addSymbolAttachment(sfSymbol: String) {
        let image = UIImage(systemName: sfSymbol)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attrString = NSAttributedString(attachment: attachment);
        
        self.append(attrString);
    }
}
