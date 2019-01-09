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
    var food: [NSManagedObject] = []
    var consumption: [NSManagedObject] = []
    let date = Date()
    
    @IBOutlet weak var mealTimeLbl: UILabel!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodCalTextField: UITextField!
    @IBOutlet weak var foodCountTextField: UITextField!
    
    var mealTime: String = ""
    var operation : String = ""
    
    var foodtype : String = ""
    var foodName : String = ""
    var calorie : String = ""
    var icalorie : String = ""
    var quanti : String = ""
    
    var consumptionItem : AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        NSLog(mealTime, mealTime)
        mealTimeLbl.text = mealTime
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewFood(_ sender: Any) {
        
        if foodCountTextField?.text == "" ||
            foodCalTextField?.text == "" ||
            foodNameTextField?.text == "" {
        } else {
            if(operation == "add") {
                let CalCount: Int = Int((foodCountTextField?.text)!)! * Int((foodCalTextField?.text)!)!
                self.saveFood(foodName: (foodNameTextField?.text)!,
                          foodCalorie: Double(CalCount),
                          foodType: mealTime,
                          foodDate: self.date,
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
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureView(){
        print("configureView...")
        //mealTimeLbl.text = mealTime
        if let detail = self.consumptionItem {
            if let labelFName = self.foodNameTextField {
                labelFName.text = (detail.value(forKey:"name")! as AnyObject).description
            }
            
            if let labelCalorie = self.foodCalTextField {
                /* TO DO Check for Null Value*/
                labelCalorie.text = ((detail.value(forKeyPath: "icalorie") as? NSNumber)!).stringValue
            }
            
            if let labelQuantity = self.foodCountTextField {
                /* TO DO Check for Null Value*/
                labelQuantity.text =  ((detail.value(forKeyPath: "count") as? NSNumber)!).stringValue
            }
            
            if let labelType = self.mealTimeLbl {
                labelType.text = (detail.value(forKey: "type")! as! AnyObject).description
            }
        }
    }
    
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
            //self.dismiss(animated: true, completion: nil)
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
    
    func updateConsumption(consumptionItem: AnyObject, foodName: String, foodCalorie: Double, foodICalorie: Double, foodCount: Int16) {
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
            let foodItem = consumptionItem
            //managedObject.setValue(foodName, forKey:"name")
            //managedObject.setValue(quanti, forKey:"count")
            //managedObject.setValue(calorie, forKey:"calorie")
            
            foodItem.setValue(foodName, forKeyPath: "name")
            //foodItem.setValue(foodDate, forKeyPath: "date")
            foodItem.setValue(foodCalorie, forKeyPath: "calorie")
            foodItem.setValue(foodICalorie, forKeyPath: "icalorie")
            //foodItem.setValue(foodType, forKeyPath: "type")
            foodItem.setValue(foodCount, forKeyPath: "count")
            
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
