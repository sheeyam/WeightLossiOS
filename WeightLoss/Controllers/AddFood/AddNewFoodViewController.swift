//
//  AddNewFoodViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 10/25/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreData

class AddNewFoodViewController: UIViewController {
    
    @IBOutlet weak var mealTimeLbl: UILabel!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodCalTextField: UITextField!
    @IBOutlet weak var foodCountTextField: UITextField!
    
    var food: [NSManagedObject] = []
    var consumption: [NSManagedObject] = []
    var mealTime : String = ""
    var operation : String = ""
    var consumptionItem: FoodModel?
    var callback: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
    }
    
    func setValues(){
        mealTimeLbl.text = consumptionItem?.foodType ?? mealTime
        foodNameTextField.text = consumptionItem?.foodName ?? ""
        foodCalTextField.text = String(consumptionItem?.foodCalorie ?? 0)
        foodCountTextField.text = String(consumptionItem?.foodCount ?? 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        if let foodCountStr = foodCountTextField?.text, let foodCalStr = foodCalTextField?.text, let foodCount = Int(foodCountStr), let foodCal = Int(foodCalStr){
            let CalCount = foodCount * foodCal
            
            if operation == Constants.operations.add {
                self.saveFood(foodName: foodNameTextField?.text ?? "",
                          foodCalorie: Double(CalCount),
                          foodType: consumptionItem?.foodType ?? mealTime,
                          foodDate: Date(),
                          foodCount: Int16(foodCount),
                          foodICalorie: Double(foodCal))
            } else {
                if let detail = self.consumptionItem {
                    self.updateConsumption(consumptionItem: detail,
                                       foodName: foodNameTextField?.text ?? "",
                                       foodCalorie: Double(CalCount),
                                       foodICalorie: Double(foodCal),
                                       foodCount: Int16(foodCount))
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        callback?(false)
        self.dismiss(animated: true, completion: nil)
    }
}
