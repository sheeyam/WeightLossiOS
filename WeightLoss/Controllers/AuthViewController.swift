//
//  AuthViewController.swift
//  WeightLoss - CSCI 5737
//
//  Created by Sheeyam Shellvacumar on 9/16/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigateToHomeViewController()
        
        //TODO: Face ID
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func navigateToHomeViewController(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Constants.segues.authToHome, sender: nil)
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
