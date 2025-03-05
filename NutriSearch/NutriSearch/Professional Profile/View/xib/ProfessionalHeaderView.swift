//
//  ProfessionalHeaderView.swift
//  NutriSearch
//
//  Created by Miguel Solans on 05/03/2025.
//

import UIKit

class ProfessionalHeaderView: UIView {
    
    fileprivate let kNibName: String = "ProfessionalHeaderView";
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setupUI();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        self.setupUI();
    }

    fileprivate func setupUI() {
        guard let contentView = Bundle.main.loadNibNamed(kNibName, owner: self, options: nil)?.first as? UIView else {
            return;
        }
        
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .clear;
    }
    
    func configure(withViewModel viewModel: ProfessionalProfileViewModel) {
        self.avatarImageView.image = UIImage(systemName: STCoreUIImages.ProfileDefault);
        
        viewModel.loadImage() { result in
            switch result {
            case .success(let image):
                self.avatarImageView.image = image;
                break;
            case .failure(_):
                break;
            }
        }
        
        self.nameLabel.text = viewModel.professionalProfileOutput?.name;
        self.nameLabel.font = UIFont.systemFont(ofSize: STCoreUIFont.NameTitleSize);
        
        self.ratingLabel.attributedText = viewModel.formattedRating;
        self.ratingLabel.font = UIFont.systemFont(ofSize: STCoreUIFont.RatingSize);
    }

}
