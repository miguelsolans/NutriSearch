//
//  ProfessionalProfileViewController.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

class ProfessionalProfileViewController: BaseViewController {
    
    var professional: ProfessionalOutput?;
    
    // MARK: - Outlets
    @IBOutlet weak var professionalHeaderView: ProfessionalHeaderView!
    @IBOutlet weak var bioLabel: UILabel!
    
    // MARK: - Properties
    let viewModel = ProfessionalProfileViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupViewModel();
        self.setupUI();
    }
    
    func setupUI() {
        self.professionalHeaderView.configure(withViewModel: self.viewModel);
        
        self.bioLabel.text = self.viewModel.professionalProfileOutput?.aboutMe;
        self.bioLabel.textAlignment = .left;
        self.bioLabel.font = UIFont.systemFont(ofSize: STCoreUIFont.BioSize);
        
        self.view.backgroundColor = .white;
    }
    
    func setupViewModel() {
        self.viewModel.viewDelegate = self;
        self.getProfile();
    }
}

extension ProfessionalProfileViewController {
    func getProfile() {
        
        guard let professional = self.professional else {
            self.navigationController?.popViewController(animated: true);
            return;
        }
        
        self.startLoading();
        
        self.viewModel.getProfessionalProfile(withId: professional.id);
    }
}

// MARK: ViewModel observers
extension ProfessionalProfileViewController: ProfessionalProfileViewModelDelegate {
    func professionalProfileOutputDidChange(viewModel: ProfessionalProfileViewModel) {
        self.stopLoading();
        
        self.setupUI();
    }
    
    func professionalProfileErrorDidChange(viewModel: ProfessionalProfileViewModel) {
        self.stopLoading();
        
        self.navigationController?.popViewController(animated: true);
        
        let alertController = UIAlertController(title: "Error", message: "There was an error fetching selected profile", preferredStyle: .alert);
        
        let okAction = UIAlertAction(title: "Ok", style: .default);
        
        alertController.addAction(okAction);
        
        self.present(alertController, animated: true);
    }
}
