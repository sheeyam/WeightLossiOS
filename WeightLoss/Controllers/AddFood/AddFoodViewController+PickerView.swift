//
//  AddFoodViewController+PickerView.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import UIKit

extension AddFoodViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consumptionData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return consumptionData[row].foodName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setDefaultValuesOnLbls(row: row)
    }
    
    func setDefaultValuesOnLbls(row: Int){
        foodNameTextField.text = consumptionData[row].foodName
        foodCalTextField.text = String(consumptionData[row].foodCalorie)
        foodCountTextField.text = "1"
        foodPickerView.isHidden = true
    }
}
