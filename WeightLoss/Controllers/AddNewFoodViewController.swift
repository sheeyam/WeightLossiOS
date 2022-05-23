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
        // Do any additional setup after loading the view.
    }
    
    func setValues(){
        mealTimeLbl.text = consumptionItem?.foodType ?? mealTime
        foodNameTextField.text = consumptionItem?.foodName ?? ""
        foodCalTextField.text = String(consumptionItem?.foodCalorie ?? 0)
        foodCountTextField.text = String(consumptionItem?.foodCount ?? 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        if(operation == "add") {
            let CalCount: Int = Int((foodCountTextField?.text)!)! * Int((foodCalTextField?.text)!)!
            self.saveFood(foodName: (foodNameTextField?.text)!,
                      foodCalorie: Double(CalCount),
                      foodType: consumptionItem?.foodType ?? mealTime,
                      foodDate: Date(),
                      foodCount: Int16((foodCountTextField?.text)!)!,
                      foodICalorie: Double(Int((foodCalTextField?.text)!)!))
        } else {
            let detail = self.consumptionItem
            let CalCount: Int = Int((foodCountTextField?.text)!)! * Int((foodCalTextField?.text)!)!
            self.updateConsumption(consumptionItem: detail!,
                               foodName: (foodNameTextField?.text)!,
                               foodCalorie: Double(CalCount),
                               foodICalorie: Double(Int((foodCalTextField?.text)!)!),
                               foodCount: Int16((foodCountTextField?.text)!)!)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        callback?(false)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewFoodViewController {
    func saveFood(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodCount: Int16, foodICalorie: Double) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.entities.food, in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodName, forKeyPath: Constants.entities.keys.name)
        foodItem.setValue(foodDate, forKeyPath: Constants.entities.keys.date)
        foodItem.setValue(foodCalorie, forKeyPath: Constants.entities.keys.calorie)
        foodItem.setValue(foodType, forKeyPath: Constants.entities.keys.type)
        
        do {
            try managedContext.save()
            food.append(foodItem)
            self.saveConsumption(foodName: foodName,
                                 foodCalorie: foodCalorie,
                                 foodType: foodType,
                                 foodDate: foodDate,
                                 foodCount: foodCount,
                                 foodICalorie: foodICalorie)
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }
    
    func updateConsumption(consumptionItem: FoodModel, foodName: String, foodCalorie: Double, foodICalorie: Double, foodCount: Int16) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entities.consume)
        do{
            let results = try managedContext.fetch(fetchRequest)
            consumption = results as! [NSManagedObject]
            consumption.first?.setValue(consumptionItem.foodName, forKeyPath: Constants.entities.keys.name)
            consumption.first?.setValue(consumptionItem.foodCalorie, forKeyPath: Constants.entities.keys.calorie)
            consumption.first?.setValue(consumptionItem.foodICalorie, forKeyPath: Constants.entities.keys.icalorie)
            consumption.first?.setValue(consumptionItem.foodCount, forKeyPath: Constants.entities.keys.count)
            
            try managedContext.save()
            callback?(true)
            self.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            print("\(error), \(error.userInfo)")
        }
    }
    
    
    func saveConsumption(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodCount: Int16, foodICalorie: Double) {
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
        foodItem.setValue(foodICalorie, forKeyPath: Constants.entities.keys.icalorie)
        foodItem.setValue(foodType, forKeyPath: Constants.entities.keys.type)
        foodItem.setValue(foodCount, forKeyPath: Constants.entities.keys.count)
        food.append(foodItem)
        
        do {
            try managedContext.save()
            callback?(true)
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
