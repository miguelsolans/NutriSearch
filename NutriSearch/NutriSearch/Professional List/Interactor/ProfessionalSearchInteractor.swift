//
//  ProfessionalSearchInteractor.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import Foundation
import UIKit

class ProfessionalSearchInteractor: BaseApiClient {
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func searchProfessionals(withInput input: ProfessionalSearchInput, completion: @escaping(Result<ProfessionalsSearchOutput, ApiError>) -> Void) {
        self.request(endpoint: "/professionals/search", method: .get, parameters: input.toDictionary(), completion: completion);
    }
    
    func getImageWithPath(_ path: String, completion: @escaping(Result<UIImage, ApiError>) -> Void) {
        if let cachedImage = imageCache.object(forKey: path as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        self.loadImage(for: path) { [weak self] result in
            switch result {
            case .success(let image):
                self?.imageCache.setObject(image, forKey: path as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
