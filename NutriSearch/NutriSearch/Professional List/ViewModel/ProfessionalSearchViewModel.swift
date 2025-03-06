//
//  ProfessionalSearchViewModel.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import UIKit


protocol ProfessionalViewModelDelegate: AnyObject {
    func professionalSearchOutputDidChange(viewModel: ProfessionalSearchViewModel);
    func professionalSearchErrorDidChange(viewModel: ProfessionalSearchViewModel);
}

class ProfessionalSearchViewModel: NSObject {
    
    weak var viewDelegate: ProfessionalViewModelDelegate?
    
    /// Client
    fileprivate lazy var client: ProfessionalSearchInteractor = {
        
        let configuration = ApiClientConfiguration();
        
        guard let baseEndpoint = Bundle.main.object(forInfoDictionaryKey: NConstants.kBaseEndpoint) as? String
        else { fatalError("not found") }
        
        let client = ProfessionalSearchInteractor(baseURL: baseEndpoint, configuration: configuration)
        
        return client;
    }();
    
    // MARK: UI
    
    public lazy var searchOptions: [STPickerOption] = {
        let bestMatchOption = STPickerOption(id: SortBy.bestMatch.rawValue,
                                             label: SortBy.bestMatch.displayName,
                                             subLabel: "");
        
        let ratingOption = STPickerOption(id: SortBy.rating.rawValue,
                                          label: SortBy.rating.displayName,
                                          subLabel: "");
        
        let mostPopularOption = STPickerOption(id: SortBy.mostPopular.rawValue,
                                               label: SortBy.mostPopular.displayName,
                                               subLabel: "");
        
        let options: [STPickerOption] = [
            bestMatchOption,
            ratingOption,
            mostPopularOption
        ];
        
        return options
    }();
    
    public lazy var searchPickerModel: STPickerModel = {
        let model = STPickerModel(title: "",
                                  options: self.searchOptions,
                                  placeholder: "Select to apply filter",
                                  search: false,
                                  pickerStyle: .singleLabel);
        
        return model;
    }();
    
    // MARK: - Properties
    
    public var professionalSearchOutput: ProfessionalsSearchOutput? {
        didSet {
            self.viewDelegate?.professionalSearchOutputDidChange(viewModel: self);
        }
    }
    
    public var professionalSearchError: Error? {
        didSet {
            self.viewDelegate?.professionalSearchErrorDidChange(viewModel: self);
        }
    }
    
    fileprivate let pageSize: Int = 10;
    fileprivate let offSet: Int = 0;
}

extension ProfessionalSearchViewModel {
    
    func searchProfessionals(withSort sort: SortBy = .bestMatch) {
        
        let input = ProfessionalSearchInput(limit: pageSize,
                                            offset: offSet,
                                            sortBy: sort);
        
        self.client.searchProfessionals(withInput: input) { result in
            switch(result) {
            case .success(let data):
                self.professionalSearchOutput = data;
                break;
            case .failure(let error):
                self.professionalSearchError = error;
                break;
            }
        }
        
    }
    
    func loadImage(for professional: ProfessionalOutput, completion: @escaping(Result<UIImage, ApiError>) -> Void) {
        self.client.getImageWithPath(professional.profilePictureURL, completion: completion);
    }
}

extension ProfessionalSearchViewModel {
    public func formattedLanguagesFor(professional: ProfessionalOutput) -> NSAttributedString {
        return ProfessionalFormatter.formattedLanguages(for: professional);
    }
    
    public func formattedRatingFor(professional: ProfessionalOutput) -> NSAttributedString {
        return ProfessionalFormatter.formattedRating(for: professional);
    }
}

