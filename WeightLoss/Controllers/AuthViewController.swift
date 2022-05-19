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
    
    @IBOutlet weak var touchIDBtn: UIButton!
    @IBOutlet weak var goBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        touchIDBtn.isHidden = true
        goBtn.isHidden = true
        // Do any additional setup after loading the view.
        if(UserDefaults.standard.bool(forKey: "touchID")) {
            touchIDBtn.isHidden = false
            goBtn.isHidden = true
            showTouchIDAuth(true)
        } else {
            touchIDBtn.isHidden = true
            goBtn.isHidden = false
            showTouchIDAuth(false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        touchIDBtn.isHidden = true
        goBtn.isHidden = true
        // Do any additional setup after loading the view.
        if(UserDefaults.standard.bool(forKey: "touchID")) {
            touchIDBtn.isHidden = false
            goBtn.isHidden = true
        } else {
            touchIDBtn.isHidden = true
            goBtn.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(_ sender: Any) {
        //on success
        self.navigateToHomeViewController()
    }
    
    @IBAction func authTouchID(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "touchID")) {
            showTouchIDAuth(true)
        } else {
            showTouchIDAuth(false)
        }
    }
    
    func showTouchIDAuth (_ touchId: Bool) {
        if(touchId){
            // 1
            let context = LAContext()
            var error: NSError?
            
            // 2
            // check if Touch ID is available
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // 3
                let reason = "Authenticate with Touch ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                    {(succes, error) in
                        // 4
                        if succes {
                            //self.showAlertController("Touch ID Authentication Succeeded")
                            self.navigateToHomeViewController()
                        }
                        else {
                            self.showAlertController("Touch ID Authentication Failed")
                        }
                })
            }
                // 5
            else {
                showAlertController("Touch ID not available")
            }
        } else {
            self.navigateToHomeViewController()
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToHomeViewController(){
        DispatchQueue.main.async {
            //place your code to push viewController
            //let homevc = self.storyboard?.instantiateViewController(withIdentifier:"homeVC") as! HomeViewController
            //self.present(homevc, animated: true, completion: nil)
            self.performSegue(withIdentifier: "auth2home", sender: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
