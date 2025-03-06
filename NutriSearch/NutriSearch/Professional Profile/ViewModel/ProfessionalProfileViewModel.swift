//
//  ProfessionalProfileViewModel.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

protocol ProfessionalProfileViewModelDelegate: AnyObject {
    func professionalProfileOutputDidChange(viewModel: ProfessionalProfileViewModel);
    func professionalProfileErrorDidChange(viewModel: ProfessionalProfileViewModel);
}

class ProfessionalProfileViewModel: NSObject {
    
    weak var viewDelegate: ProfessionalProfileViewModelDelegate?
    
    fileprivate lazy var client: ProfessionalProfileInteractor = {
        
        let configuration = ApiClientConfiguration();
        
        guard let baseEndpoint = Bundle.main.object(forInfoDictionaryKey: NConstants.kBaseEndpoint) as? String
        else { fatalError("not found") }
        
        let client = ProfessionalProfileInteractor(baseURL: baseEndpoint, configuration: configuration)
        
        return client;
        
    }();

    // MARK: - Service outputs
    
    public var professionalProfileOutput: ProfessionalOutput? {
        didSet {
            self.viewDelegate?.professionalProfileOutputDidChange(viewModel: self);
        }
    }
    
    public var professionalErrorError: Error? {
        didSet {
            self.viewDelegate?.professionalProfileErrorDidChange(viewModel: self);
        }
    }
    
    // MARK: - Computed properties
    
    var formattedLanguages: NSAttributedString {
        guard let professional = self.professionalProfileOutput else {
            return NSAttributedString();
        }
        
        return ProfessionalFormatter.formattedLanguages(for: professional);
    }
    
    var formattedRating: NSAttributedString {
        guard let professional = self.professionalProfileOutput else {
            return NSAttributedString();
        }
        
        return ProfessionalFormatter.formattedRating(for: professional);
    }
    
}

extension ProfessionalProfileViewModel {
    func getProfessionalProfile(withId id: Int) {
        let identifier = String(id);
        
        self.client.getProfile(withID: identifier) { result in
            switch result {
            case .success(let data):
                self.professionalProfileOutput = data
            case .failure(let error):
                self.professionalErrorError = error
            }
        }
    }
    
    func loadImage(completion: @escaping(Result<UIImage, ApiError>) -> Void) {
        
        guard let professional = self.professionalProfileOutput else {
            completion(.failure(.noData));
            
            return;
        }
        
        self.client.getImageWithPath(professional.profilePictureURL, completion: completion);
    }
}
