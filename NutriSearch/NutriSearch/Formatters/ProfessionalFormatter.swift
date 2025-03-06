//
//  ProfessionalFormatter.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

class ProfessionalFormatter: NSObject {
    static func formattedLanguages(for professional: ProfessionalOutput) -> NSAttributedString {
        return professional.formattedLanguages.addSymbolAndConvertToAttributedString(withSymbol: "globe")
    }
    
    static func formattedRating(for professional: ProfessionalOutput) -> NSAttributedString {
        let maxStars = 5
        let rating = max(0, min(professional.rating, maxStars))
        
        let attributedString = NSMutableAttributedString()
        
        for i in 0..<maxStars {
            let imageName = i < rating ? STCoreUIImages.StarFill : STCoreUIImages.Star
            attributedString.addSymbolAttachment(sfSymbol: imageName)
        }
        
        let ratingString = NSAttributedString(string: "\(professional.rating)/5 (\(professional.ratingCount))")
        attributedString.append(ratingString)
        
        return attributedString
    }
    
    static func formattedExpertises(for professional: ProfessionalOutput) -> NSAttributedString {
        
        guard !professional.expertise.isEmpty else {
            return NSAttributedString()
        }
        
        let whiteAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        let grayBackgroundAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: STCoreUIFont.ExpertiseSize)
        ]
        
        let clearSpaceAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.clear
        ]
        
        let result = NSMutableAttributedString()
        
        for (index, expertise) in professional.expertise.enumerated() {
            let attributedText = NSMutableAttributedString(string: expertise, attributes: whiteAttributes)
            attributedText.addAttributes(grayBackgroundAttributes, range: NSRange(location: 0, length: expertise.count))
            result.append(attributedText)
            
            if index < professional.expertise.count - 1 {
                let space = NSAttributedString(string: " ", attributes: clearSpaceAttributes)
                result.append(space)
            }
        }
        
        return result
    }
}
