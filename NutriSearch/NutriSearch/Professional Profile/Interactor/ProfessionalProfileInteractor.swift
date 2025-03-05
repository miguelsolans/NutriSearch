//
//  ProfessionalProfileInteractor.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

class ProfessionalProfileInteractor: BaseApiClient {
    
    func getProfile(withID id: String, completion: @escaping(Result<ProfessionalOutput, ApiError>) -> Void) {
        self.request(endpoint: "/professionals/\(id)", method: .get, parameters:nil, completion: completion);
    }
    
    func getImageWithPath(_ path: String, completion: @escaping(Result<UIImage, ApiError>) -> Void) {
        
        self.loadImage(for: path, completion: completion);
    }
}
