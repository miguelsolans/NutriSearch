//
//  BaseViewController.swift
//  NutriSearch
//
//  Created by Miguel Solans on 04/03/2025.
//

import UIKit

class BaseViewController: UIViewController {
    private let loadingBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        
        return view
    }();
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.hidesWhenStopped = true
        
        return indicator
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingView()
    }
    
    fileprivate func setupLoadingView() {
        self.loadingBackgroundView.frame = view.bounds
        self.loadingBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(loadingBackgroundView)
        
        self.activityIndicator.center = loadingBackgroundView.center
        self.loadingBackgroundView.addSubview(activityIndicator)
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.loadingBackgroundView.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingBackgroundView.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
}
