//
//  LoginViewController.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 4/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var businessNameLabel: UILabel!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    let datasource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showSpinner()
        datasource.fetchBusiness { [weak self] result in
            self?.hideSpinner()
            guard let this = self, let business = result.value else {
                self?.show(error: result.error ?? "Could not fetch business")
                return
            }
            this.logoImageView.kf.setImage(with: business.logo)
            this.businessNameLabel.text = business.name
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard AuthManager.shared.login(username: username) else { return }
        
        APIRouter.sessionManager.adapter = DeputyAuthAdapter(username: username)
        
        if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            self.present(tabBarController, animated: true)
        }
    }
}

