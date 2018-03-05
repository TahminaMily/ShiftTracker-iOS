//
//  UIViewController+Extensions.swift
//  ShiftTracker
//
//  Created by Tahmina Khanam on 5/3/18.
//  Copyright © 2018 Deputy. All rights reserved.
//

import UIKit

// helper method to show alert on viewcontroller
extension UIViewController {
    private enum Constants {
        static let spinnerTag = 9999
    }

    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func show(error:Error) {
        alert(message: error.localizedDescription)
    }

    func showSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.tag = Constants.spinnerTag
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
    }

    func hideSpinner() {
        view.viewWithTag(Constants.spinnerTag)?.removeFromSuperview()
    }
}
