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
    let date = Date()
    var consumption: [NSManagedObject] = []
    var consumptionData: [ConsumptionModel] = []

    @IBOutlet weak var mealTimeLbl: UILabel!
    @IBOutlet weak var foodCountTextField: UITextField!
    @IBOutlet weak var foodCalTextField: UITextField!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodPickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    var mealTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog(mealTime, mealTime)
        mealTimeLbl.text = mealTime
        fillArrays()
        foodNameTextField.delegate=self
        foodCalTextField.delegate=self
        foodPickerView.isHidden = true
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveFood(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodICalorie: Double, foodCount: Int16) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Consume",in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodName, forKeyPath: "name")
        foodItem.setValue(foodDate, forKeyPath: "date")
        foodItem.setValue(foodCalorie, forKeyPath: "calorie")
        foodItem.setValue(foodType, forKeyPath: "type")
        foodItem.setValue(foodICalorie, forKeyPath: "icalorie")
        foodItem.setValue(foodCount, forKeyPath: "count")
        
        do {
            try managedContext.save()
            consumption.append(foodItem)
            //getFood(index: 0)
            fillArrays()
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fillArrays(){
        
        consumptionData.removeAll()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        do {
            let results = try context.fetch(fetchRequest)
            let foods = results as! [Food]
            
            for _food in foods {
                print(_food.name!)
                print(_food.calorie)
                print(_food.type!)
                
                let consumption = ConsumptionModel(foodName: _food.name!, foodCalorie: Int(_food.calorie), foodType: _food.type!)
                consumptionData.append(consumption)
                foodPickerView.reloadAllComponents()
                
                var totalSum = 0
                for con in consumptionData {
                    totalSum += con.foodCalorie
                }
                print(totalSum)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func AddFoodConsumption(_ sender: Any) {
        if foodCountTextField?.text == "" ||
            foodCalTextField?.text == "" ||
            foodNameTextField?.text == "" {
        } else {
            let CalCount: Int = Int((foodCountTextField?.text)!)! * Int((foodCalTextField?.text)!)!
            self.saveFood(foodName: (foodNameTextField?.text)!,
                      foodCalorie: Double(CalCount),
                      foodType: mealTime,
                      foodDate: self.date,
                      foodICalorie: Double(Int((foodCalTextField?.text)!)!),
                      foodCount: Int16((foodCountTextField?.text)!)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consumptionData.filter({$0.foodType.uppercased() == mealTime.uppercased()}).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return consumptionData[row].foodName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        foodNameTextField.text = consumptionData[row].foodName
        foodCalTextField.text = String(consumptionData[row].foodCalorie)
        foodCountTextField.text = "1"
        foodPickerView.isHidden = true
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
