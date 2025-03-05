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
}
