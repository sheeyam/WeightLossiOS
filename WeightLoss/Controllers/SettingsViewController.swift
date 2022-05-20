//
//  SettingsViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/18/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var enableDisableTouchIDSwitch: UISwitch!
    @IBOutlet weak var setNameTextField: UITextField!
    @IBOutlet weak var setTargetTextField: UITextField!
    @IBOutlet weak var setWeightTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = Constants.commonDF
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupInitialData()
    }
    
    func setupInitialData(){
        if(UserDefaults.standard.bool(forKey: Constants.userDefaultKeys.faceID)) {
            enableDisableTouchIDSwitch.setOn(true, animated: true)
        } else {
            enableDisableTouchIDSwitch.setOn(false, animated: false)
        }
        enableDisableTouchIDSwitch.addTarget(self, action: #selector(SettingsViewController.stateChanged(_:)), for: UIControl.Event.valueChanged)
        showData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showData()
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func stateChanged(_ sender: Any) {
        if enableDisableTouchIDSwitch.isOn {
            UserDefaults.standard.set(true, forKey: Constants.userDefaultKeys.faceID)
        } else {
            UserDefaults.standard.set(false, forKey: Constants.userDefaultKeys.faceID)
        }
    }
    
    func showData() {
        let currentDate = self.formatter.string(from: Date())
        setNameTextField.text = UserDefaults.standard.string(forKey: Constants.userDefaultKeys.name) ?? ""
        setWeightTextField.text = UserDefaults.standard.string(forKey: Constants.userDefaultKeys.weight) ?? ""
        setTargetTextField.text = UserDefaults.standard.string(forKey: Constants.userDefaultKeys.target + currentDate) ?? ""
    }
    
    
    @IBAction func saveSettingsData(_ sender: Any) {
        let currentDate = self.formatter.string(from: Date())
        UserDefaults.standard.set(setNameTextField?.text, forKey: Constants.userDefaultKeys.name)
        UserDefaults.standard.set(setWeightTextField?.text, forKey: Constants.userDefaultKeys.weight)
        UserDefaults.standard.set(setTargetTextField?.text, forKey: Constants.userDefaultKeys.target + currentDate)
    }
    
    @IBAction func logout(_ sender: Any) {
        //logout
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
