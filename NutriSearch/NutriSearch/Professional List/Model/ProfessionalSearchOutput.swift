//
//  ProfessionalSearchOutput.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import Foundation

struct ProfessionalsSearchOutput: Codable {
    let count: Int
    let limit: Int
    let offset: Int
    let professionals: [ProfessionalOutput]
}

struct ProfessionalOutput: Codable {
    let aboutMe: String?
    let expertise: [String]
    let id: Int
    let languages: [String]
    let name: String
    let profilePictureURL: String
    let rating: Int
    let ratingCount: Int

    enum CodingKeys: String, CodingKey {
        case aboutMe = "about_me"
        case expertise
        case id
        case languages
        case name
        case profilePictureURL = "profile_picture_url"
        case rating
        case ratingCount = "rating_count"
    }
    
    var formattedLanguages: String {
        return self.languages.joined(separator: ", ");
    }
}
