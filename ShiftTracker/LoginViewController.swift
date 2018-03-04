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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIRouter.sessionManager.request(APIRouter.business).responseObject { [weak self] (response: DataResponse<Business>) in
            DispatchQueue.main.async {
                guard let this = self, let business = response.value else { return }
                this.logoImageView.kf.setImage(with: business.logo)
                this.businessNameLabel.text = business.name
            }
        }
    }
    
    @IBAction func didTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        
        guard LoginManager.shared.login(username: username) else { return }
        
        APIRouter.sessionManager.adapter = DeputyAuthAdapter(username: username)
        
        if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            self.present(tabBarController, animated: true)
        }
    }
    


}

