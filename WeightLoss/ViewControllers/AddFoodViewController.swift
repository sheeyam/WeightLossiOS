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
    
    var foodB: [String] = []
    var foodBC: [Int] = []
    
    var foodL: [String] = []
    var foodLC: [Int] = []
    
    var foodD: [String] = []
    var foodDC: [Int] = []
    
    var foodS: [String] = []
    var foodSC: [Int] = []
    
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
        foodPickerView.isHidden = true;
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
        foodB.removeAll()
        foodL.removeAll()
        foodD.removeAll()
        foodS.removeAll()
        foodBC.removeAll()
        foodLC.removeAll()
        foodDC.removeAll()
        foodSC.removeAll()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        
        do {
            let results = try context.fetch(fetchRequest)
            let foods = results as! [Food]
            
            for _food in foods {
                print(_food.name!)
                print(_food.calorie)
                print(_food.type!)
                
                if _food.type == "Breakfast" {
                    foodB.append(_food.name!)
                    foodBC.append(Int(_food.calorie))
                } else if _food.type == "Lunch" {
                    foodL.append(_food.name!)
                    foodLC.append(Int(_food.calorie))
                } else if _food.type == "Dinner" {
                    foodD.append(_food.name!)
                    foodDC.append(Int(_food.calorie))
                } else if _food.type == "Snacks" {
                    foodS.append(_food.name!)
                    foodSC.append(Int(_food.calorie))
                } else {
                    //Do nothing
                }
                foodPickerView.reloadAllComponents()
                
                let sumBC = foodBC.reduce(0, +)
                let sumLC = foodLC.reduce(0, +)
                let sumDC = foodDC.reduce(0, +)
                let sumSC = foodSC.reduce(0, +)
                let totalSum = sumBC + sumLC + sumDC + sumSC
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
        if mealTime == "Breakfast" {
            return foodB.count
        } else if mealTime == "Lunch" {
            return foodL.count
        } else if mealTime == "Dinner" {
            return foodD.count
        } else {
            return foodS.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if mealTime == "Breakfast" {
            return foodB[row]
        } else if mealTime == "Lunch" {
            return foodL[row]
        } else if mealTime == "Dinner" {
            return foodD[row]
        } else {
            return foodS[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if mealTime == "Breakfast" {
            foodNameTextField.text = foodB[row]
            foodCalTextField.text = String(foodBC[row])
            foodCountTextField.text = "1";
        } else if mealTime == "Lunch" {
            foodNameTextField.text = foodL[row]
            foodCalTextField.text = String(foodLC[row])
            foodCountTextField.text = "1";
        } else if mealTime == "Dinner" {
            foodNameTextField.text = foodD[row]
            foodCalTextField.text = String(foodDC[row])
            foodCountTextField.text = "1";
        } else {
            foodNameTextField.text = foodS[row]
            foodCalTextField.text = String(foodSC[row])
            foodCountTextField.text = "1";
        }
        foodPickerView.isHidden = true;
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
