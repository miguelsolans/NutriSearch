//
//  ViewController.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel: ProfessionalSearchViewModel?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let viewModel = ProfessionalSearchViewModel();
        
        let _ = ProfessionalSearchInput(limit: 4,
                                offset: 0,
                                sortBy: .bestMatch);
        
        viewModel.searchProfessionals(withSort: .bestMatch)
        
        // viewModel.searchProfessionals(withInput: input);
    }


}
