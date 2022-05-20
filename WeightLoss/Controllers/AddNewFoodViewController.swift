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
    var operation : String = ""
    var consumptionItem: FoodModel? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        mealTimeLbl.text = consumptionItem?.foodType
        // Do any additional setup after loading the view.
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
                      foodType: consumptionItem?.foodType ?? "",
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureView(){
        if let item = self.consumptionItem {
            self.foodNameTextField.text = item.foodName
            self.foodCalTextField.text = String(item.foodCalorie)
            self.foodCountTextField.text = String(item.foodCount)
            self.mealTimeLbl.text = item.foodType
        }
    }
}

extension AddNewFoodViewController {
    func saveFood(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodCount: Int16, foodICalorie: Double) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Food",in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodName, forKeyPath: "name")
        foodItem.setValue(foodDate, forKeyPath: "date")
        foodItem.setValue(foodICalorie, forKeyPath: "calorie")
        foodItem.setValue(foodType, forKeyPath: "type")
        
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
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateConsumption(consumptionItem: FoodModel, foodName: String, foodCalorie: Double, foodICalorie: Double, foodCount: Int16) {
        print("Inside Update Food... ")
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Consume")
        do{
            let results = try managedContext.fetch(fetchRequest)
            consumption = results as! [NSManagedObject]
            consumption.first?.setValue(consumptionItem.foodName, forKeyPath: "name")
            consumption.first?.setValue(consumptionItem.foodCalorie, forKeyPath: "calorie")
            consumption.first?.setValue(consumptionItem.foodICalorie, forKeyPath: "icalorie")
            consumption.first?.setValue(consumptionItem.foodCount, forKeyPath: "count")
            
            try managedContext.save()
            self.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            print("Couldnot fetch errror \(error), \(error.userInfo)")
        }
    }
    
    
    func saveConsumption(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date, foodCount: Int16, foodICalorie: Double) {
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
        foodItem.setValue(foodICalorie, forKeyPath: "icalorie")
        foodItem.setValue(foodType, forKeyPath: "type")
        foodItem.setValue(foodCount, forKeyPath: "count")
        
        do {
            try managedContext.save()
            food.append(foodItem)
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
