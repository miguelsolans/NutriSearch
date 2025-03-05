//
//  ProfessionalListViewController.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import UIKit

class ProfessionalListViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIView!
    
    var filterPicker: STPicker!
    
    // MARK: - Properties
    let viewModel = ProfessionalSearchViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchProfessionals()
    }
    
    fileprivate func setupUI() {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "ProfessionalListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfessionalListTableViewCell");
        
        self.filterPicker = STPicker(model: self.viewModel.searchPickerModel);
        self.filterPicker.delegate = self;
        self.filterPicker.frame = self.pickerView.bounds;
        
        self.pickerView.addSubview(filterPicker);
    }
    
    
}

// MARK: - UITableView delegates & datasource

extension ProfessionalListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.professionalSearchOutput?.professionals.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalListTableViewCell") as? ProfessionalListTableViewCell else {
            return UITableViewCell();
        }
        
        guard let professional = self.viewModel.professionalSearchOutput?.professionals[indexPath.row] else {
            return cell;
        }
        
        cell.setupWithProfessional(professional, viewModel: self.viewModel);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        // Ideally navigation should be handled with Coordinator with dependency injection
        let storyboard = UIStoryboard(name: "ProfessionalProfile", bundle: nil);
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfessionalProfileViewController") as! ProfessionalProfileViewController;
        
        viewController.professional = self.viewModel.professionalSearchOutput?.professionals[indexPath.row];
        
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
}

// MARK: - Picker delegates
extension ProfessionalListViewController: STPickerDelegate {
    func didSelectPicker(_ pickerView: STPicker, withOption option: STPickerOption) {
        self.searchProfessionals();
    }
}

// MARK: ViewModel delegates
extension ProfessionalListViewController: ProfessionalViewModelDelegate {
    func professionalSearchOutputDidChange(viewModel: ProfessionalSearchViewModel) {
        self.stopLoading()
        
        self.tableView.reloadData();
    }
    
    func professionalSearchErrorDidChange(viewModel: ProfessionalSearchViewModel) {
        
        self.stopLoading();
        
        // Ideally this should be handled by a coordinator
        
        let alertController = UIAlertController(title: "Error fetching data", message: "There was an error fetching data. Please retry.", preferredStyle: .alert);
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.searchProfessionals();
        }
        
        alertController.addAction(retryAction);
        
        self.present(alertController, animated: true);
    }
    
    func searchProfessionals() {
        self.viewModel.viewDelegate = self;
        
        guard let option = self.filterPicker.model.selectedOption else {
            self.viewModel.searchProfessionals();
            
            return;
        }
        
        let sort = SortBy(from: option.id);
        
        self.viewModel.searchProfessionals(withSort: sort);
        
        self.startLoading();
    }
}
