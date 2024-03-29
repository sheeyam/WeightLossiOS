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
    
    //Outlets
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var mealSegmentCtl: UISegmentedControl!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var consumedCalorieLbl: UILabel!
    
    //Constants and Variables
    let date = Date()
    let formatter = DateFormatter()
    var mealTime: String = Constants.meals.breakfast
    var food: [NSManagedObject] = []
    var consumption: [NSManagedObject] = []
    var foodData: [FoodModel] = []
    var index: Int = -1
    var operation: String = Constants.operations.add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
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
    
    func setupInitialData(){
        formatter.dateFormat = Constants.commonDF
        
        let currentDate = formatter.string(from: date)
        dateLbl.text = currentDate
        
        //Fill Arrays OnLoad
        fillArrays()
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
        reloadTable()
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
        operation = Constants.operations.add
        self.performSegue(withIdentifier: Constants.segues.consumptionToAddnew, sender: self)
    }
    
    func goToNewFoodVC() {
        self.performSegue(withIdentifier: Constants.segues.consumptionToAdd, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.consumptionToAddnew{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AddNewFoodViewController
            targetController.mealTime = mealTime
            targetController.operation = operation
            if operation == Constants.operations.update {
                targetController.consumptionItem = foodData[index]
            }
            targetController.callback = {
                action in
                if action {
                    self.fillArrays()
                }
            }
        } else if segue.identifier == Constants.segues.consumptionToAdd {
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AddFoodViewController
            targetController.mealTime = mealTime
            targetController.callback = {
                action in
                if action {
                    self.fillArrays()
                }
            }
        }
    }
    
    func fillAndReload(){
        fillArrays()
        reloadTable()
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.foodTableView.reloadData()
        }
    }
    
    func getFood (index: Int) {
        let foodVal = food[index]
        foodData[index].foodName = (foodVal.value(forKeyPath: Constants.entities.keys.name) as? String)!
        reloadTable()
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
            consumedCalorieLbl.text = String(totalSum) + " Cal"
            UserDefaults.standard.set(String(totalSum), forKey: Constants.userDefaultKeys.consumed + currentDate)
            reloadTable()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}

extension ConsumptionViewController {
    func deleteFood(idx: Int) {
        let foodToBeDeleted = foodData[idx]
        deleteData(name:foodToBeDeleted.foodName)
        var data = foodData.filter({$0.foodType.uppercased() == mealTime.uppercased()})
        data.remove(at: idx)
        self.fillAndReload()
    }
    
    func deleteData(name : String){
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
            try context.save()
        } catch let error as NSError{
            print("\(error), \(error.userInfo)")
        }
    }
}
