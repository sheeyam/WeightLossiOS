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
        //Authenticate User with Face ID
        AuthenticateUser()
    }
    
    func AuthenticateUser(){
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = Constants.alertStrings.faceIDReason
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, error in
                guard success,error == nil else {
                    //failed
                    return
                }
                self?.navigateToHomeViewController()
            }
        } else {
            navigateToHomeViewController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func navigateToHomeViewController(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Constants.segues.authToHome, sender: nil)
        }
    }
}
