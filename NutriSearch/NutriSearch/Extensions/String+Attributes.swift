//
//  String+Attributes.swift
//  NutriSearch
//
//  Created by Miguel Solans on 04/03/2025.
//

import Foundation
import UIKit

extension String {
    func addSymbolAndConvertToAttributedString(withSymbol symbolName: String) -> NSAttributedString {
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(systemName: symbolName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
        
        let attachmentAttrString = NSAttributedString(attachment: textAttachment)
        
        let textAttrString = NSAttributedString(string: "\(self)", attributes: [
            .font: UIFont.systemFont(ofSize: 16)
        ]);
        
        let combinedAttrString = NSMutableAttributedString();
        
        combinedAttrString.append(attachmentAttrString);
        combinedAttrString.append(textAttrString);
        
        return combinedAttrString;
    }
}


