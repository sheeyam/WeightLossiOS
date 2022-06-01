//
//  AddNewFoodViewController+DBLogics.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 6/1/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
