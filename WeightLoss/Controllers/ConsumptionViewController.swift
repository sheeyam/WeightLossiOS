//
//  ConsumptionViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/16/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreData

class ConsumptionViewController: UIViewController {
    
    var food: [NSManagedObject] = []
    var consumption: [NSManagedObject] = []
    var foodData: [FoodModel] = []
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mealSegmentCtl: UISegmentedControl!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var consumedCalorieLbl: UILabel!
    
    var mealTime: String = ""
    let date = Date()
    let formatter = DateFormatter()
    
    var index: Int = -1
    var op: String = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mealTime = Constants.meals.breakfast
        formatter.dateFormat = Constants.commonDF
        let currentDate = formatter.string(from: date)
        dateLbl.text = currentDate
        
        //Fill Arrays OnLoad
        fillArrays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        // Do any additional setup after loading the view.
        let currentDate = formatter.string(from: date)
        dateLbl.text = currentDate
        mealTime = Constants.meals.breakfast
        //Fill Arrays OnLoad
        fillArrays()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFoodConsumption(_ sender: Any) {
        showAddFoodConsumptionAlert()
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch mealSegmentCtl.selectedSegmentIndex
        {
        case 0:
            mealTime = Constants.meals.breakfast
        case 1:
            mealTime = Constants.meals.lunch
        case 2:
            mealTime = Constants.meals.dinner
        case 3:
            mealTime = Constants.meals.snacks
        default:
            break
        }
        foodTableView.reloadData()
    }
    
    func showAddFoodConsumptionAlert(){
        // Create the alert controller
        let alertController = UIAlertController(title: Constants.alertStrings.addConsumptionTitle, message: Constants.alertStrings.addConsumptionMsg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: Constants.alertStrings.add, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.goToAddNewFoodVC()
        }
        let chooseAction = UIAlertAction(title: Constants.alertStrings.choose, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.goToNewFoodVC()
        }
        
        let cancelAction = UIAlertAction(title: Constants.alertStrings.cancel, style: UIAlertAction.Style.default)
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(chooseAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToAddNewFoodVC() {
        op = "add"
        self.performSegue(withIdentifier: Constants.segues.consumptionToAddnew, sender: self)
    }
    
    func goToNewFoodVC() {
        self.performSegue(withIdentifier: Constants.segues.consumptionToAdd, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.consumptionToAddnew{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AddNewFoodViewController
            if op == "add" {
                targetController.operation = op
                targetController.mealTime = mealTime
            } else {
                targetController.operation = op
                targetController.mealTime = mealTime
                targetController.consumptionItem = foodData[index]
            }
        } else if segue.identifier == Constants.segues.consumptionToAdd {
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AddFoodViewController
            targetController.mealTime = mealTime
        } else {
            //Do Nothing
        }
    }
    
    func fillAndReload(){
        fillArrays()
        foodTableView.reloadData()
    }
    
    func saveFood(foodData: FoodModel) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.entities.food, in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodData.foodName, forKeyPath: Constants.entities.keys.name)
        foodItem.setValue(foodData.foodDate, forKeyPath: Constants.entities.keys.date)
        foodItem.setValue(foodData.foodCalorie, forKeyPath: Constants.entities.keys.calorie)
        foodItem.setValue(foodData.foodType, forKeyPath: Constants.entities.keys.type)
        
        do {
            try managedContext.save()
            food.append(foodItem)
            fillArrays()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
    }
    
    func getFood (index: Int) {
        let foodVal = food[index]
        foodData[index].foodName = (foodVal.value(forKeyPath: Constants.entities.keys.name) as? String)!
        foodTableView.reloadData()
    }
    
    func deleteData (name : String){
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Consume> = Consume.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "name= %@", name)
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save() // <- remember to put this :)
            print("Consumption Deleted ")
            fillArrays()
        } catch {
            // Do something... fatalerror
        }
    }
    
    func fillArrays(){
        foodData.removeAll()
        
        let currentDate = self.formatter.string(from: (self.date))
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entities.consume)
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time
        
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        fetchRequest.predicate = datePredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            let consumptions = results as! [Consume]
            
            for _consumption in consumptions {
                let food = FoodModel(foodName: _consumption.name!, foodType: _consumption.type!, foodDate: "", foodCount: Int(_consumption.count), foodCalorie: Int(_consumption.calorie), foodICalorie: Int(_consumption.icalorie))
                foodData.append(food)
            }
            
            var totalSum = 0
            for food in foodData {
                totalSum += food.foodCalorie
            }
            print(totalSum)
            consumedCalorieLbl.text = String(totalSum) + " Cal"
            UserDefaults.standard.set(String(totalSum), forKey: Constants.userDefaultKeys.consumed + currentDate)
            print(foodData)
            foodTableView.reloadData()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}

extension ConsumptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ foodTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodData.filter({$0.foodType.uppercased() == mealTime.uppercased()}).count
    }
    
    func tableView(_ foodTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        let data = foodData.filter({$0.foodType.uppercased() == mealTime.uppercased()})
        let cell:CustomConsumeCell = foodTableView.dequeueReusableCell(withIdentifier: CustomConsumeCell.identifier, for: indexPath) as! CustomConsumeCell
        cell.configureCell(foodData: data[indexPath.row])
        return cell
    }
    
    func tableView(_ foodTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        index = indexPath.row
        //  print(index)
        op = "update"
        performSegue(withIdentifier: Constants.segues.consumptionToAddnew, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            let index = indexPath.row
            let foodToBeDeleted = foodData[index]
            self.deleteData(name:foodToBeDeleted.foodName)
            foodData.remove(at: index)
            self.fillAndReload()
        }
    }
}
