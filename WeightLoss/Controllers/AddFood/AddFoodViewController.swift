//
//  AddFoodViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 10/24/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreData

class AddFoodViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mealTimeLbl: UILabel!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var foodCalTextField: UITextField!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodPickerView: UIPickerView!
    
    var consumption: [NSManagedObject] = []
    var consumptionData: [ConsumptionModel] = []
    var pickerData: [String] = [String]()
    var mealTime: String = ""
    var callback: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
    }
    
    func setupInitialData(){
        mealTimeLbl.text = mealTime
        fillArrays()
        foodNameTextField.delegate = self
        foodCalTextField.delegate = self
        foodPickerView.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func goBack(_ sender: Any) {
        callback?(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveFood(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodICalorie: Double, foodCount: Int16) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.entities.consume, in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodName, forKeyPath: Constants.entities.keys.name)
        foodItem.setValue(foodDate, forKeyPath: Constants.entities.keys.date)
        foodItem.setValue(foodCalorie, forKeyPath: Constants.entities.keys.calorie)
        foodItem.setValue(foodType, forKeyPath: Constants.entities.keys.type)
        foodItem.setValue(foodICalorie, forKeyPath: Constants.entities.keys.icalorie)
        foodItem.setValue(foodCount, forKeyPath: Constants.entities.keys.count)
        
        do {
            try managedContext.save()
            consumption.append(foodItem)
            fillArrays()
            callback?(true)
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }
    
    func resetData() {
        consumptionData.removeAll()
    }
    
    func fillArrays(){
        
        resetData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entities.food)
        
        do {
            let results = try context.fetch(fetchRequest)
            let foods = results as! [Food]
            
            for _food in foods {
                let consumption = ConsumptionModel(foodName: _food.name!, foodCalorie: Int(_food.calorie), foodType: _food.type!)
                consumptionData.append(consumption)
                foodPickerView.reloadAllComponents()
                
                var totalSum = 0
                for con in consumptionData {
                    totalSum += con.foodCalorie
                }
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func AddFoodConsumption(_ sender: Any) {
        if let foodCount = foodCountTextField?.text, let foodCalories = foodCalTextField?.text {
            let CalCount: Int = Int(foodCount)! * Int(foodCalories)!
            self.saveFood(foodName: (foodNameTextField?.text)!,
                      foodCalorie: Double(CalCount),
                      foodType: mealTime,
                      foodDate: Date(),
                      foodICalorie: Double(Int(foodCount)!),
                      foodCount: Int16(foodCalories)!)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        foodPickerView.isHidden = false
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
