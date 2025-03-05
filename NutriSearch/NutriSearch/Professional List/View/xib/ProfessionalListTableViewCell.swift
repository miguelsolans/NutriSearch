//
//  ProfessionalListTableViewCell.swift
//  NutriSearch
//
//  Created by Miguel Solans on 03/03/2025.
//

import UIKit

class ProfessionalListTableViewCell: UITableViewCell {

    @IBOutlet weak var professionalAvatarImageView: UIImageView!
    @IBOutlet weak var professionalNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var expertiseStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupWithProfessional(_ professional: ProfessionalOutput, viewModel: ProfessionalSearchViewModel) {
        
        self.professionalAvatarImageView.image = UIImage(systemName: STCoreUIImages.ProfileDefault);
        
        viewModel.loadImage(for: professional) { result in
            switch result {
            case .success(let image):
                self.professionalAvatarImageView.image = image;
                break;
            case .failure(_):
                break;
            }
        }
        
        self.professionalNameLabel.font = UIFont.boldSystemFont(ofSize: STCoreUIFont.NameTitleSize);
        self.professionalNameLabel.text = professional.name;
        
        self.ratingLabel.attributedText = viewModel.formattedRatingFor(professional: professional);
        self.ratingLabel.font = UIFont.systemFont(ofSize: STCoreUIFont.RatingSize);
        
        self.languageLabel.attributedText = viewModel.formattedLanguagesFor(professional: professional);
        self.languageLabel.font = UIFont.systemFont(ofSize: STCoreUIFont.LanguageSize);
        
        if(professional.expertise.isEmpty) {
            return;
        }
        
        for expertise in professional.expertise {
            
            let label = UILabel();
            
            label.font = UIFont.systemFont(ofSize: STCoreUIFont.ExpertiseSize)
            
            label.text = expertise;
            
            self.expertiseStackView.addArrangedSubview(label);
        }
        
    }
    
}
