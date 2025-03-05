//
//  ProfessionalSearchInput.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import Foundation

public enum SortBy: String, Encodable {
    case bestMatch = "best_match"
    case rating = "rating"
    case mostPopular  = "most_popular";
    
    var displayName: String {
        switch self {
        case .bestMatch: return "Best for You"
        case .rating: return "Rating"
        case .mostPopular: return "Most Popular"
        }
    }
    
    init(from rawValue: String) {
        self = SortBy(rawValue: rawValue) ?? .bestMatch
    }
}

struct ProfessionalSearchInput: Encodable {
    
    let limit: Int
    let offset: Int
    let sortBy: SortBy
    
    
    func toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            let data = try encoder.encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            return nil
        }
    }
}
