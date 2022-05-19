//
//  ConsumptionViewController.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 9/16/18.
//  Copyright © 2018 Sheeyam Shellvacumar. All rights reserved.
//

import UIKit
import CoreData

class ConsumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var food: [NSManagedObject] = []
    var consumption: [NSManagedObject] = []
    
    var foodDictionary = Dictionary<String, Array<NSManagedObject>>()
    
    var foodB: [String] = []
    var foodBC: [Int] = []
    var foodBIC: [Int] = []
    var foodBQ: [Int16] = []
    
    var foodL: [String] = []
    var foodLC: [Int] = []
    var foodLIC: [Int] = []
    var foodLQ: [Int16] = []
    
    var foodD: [String] = []
    var foodDC: [Int] = []
    var foodDIC: [Int] = []
    var foodDQ: [Int16] = []
    
    var foodS: [String] = []
    var foodSC: [Int] = []
    var foodSIC: [Int] = []
    var foodSQ: [Int16] = []
    
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
        mealTime = "Breakfast";
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = formatter.string(from: date)
        dateLbl.text = currentDate
        
        //Fill Arrays OnLoad
        fillArrays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        // Do any additional setup after loading the view.
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = formatter.string(from: date)
        dateLbl.text = currentDate
        
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
            mealTime = "Breakfast";
        case 1:
            mealTime = "Lunch";
        case 2:
            mealTime = "Dinner";
        case 3:
            mealTime = "Snacks";
        default:
            break
        }
        foodTableView.reloadData()
    }
    
    func tableView(_ foodTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mealTime == "Breakfast" {
            return foodB.count
        } else if mealTime == "Lunch" {
            return foodL.count
        } else if mealTime == "Dinner" {
            return foodD.count
        } else if mealTime == "Snacks" {
            return foodS.count
        } else {
            return foodB.count
        }
    }
    
    func tableView(_ foodTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        let cell:CustomConsumeCell = foodTableView.dequeueReusableCell(withIdentifier: "foodcell", for: indexPath) as! CustomConsumeCell
        //let cell = foodTableView.dequeueReusableCell(withIdentifier: "foodcell", for: indexPath)
        if mealTime == "Breakfast" {
            cell.foodLbl?.text = foodB[indexPath.row]
            cell.calLbl?.text = String(foodBC[indexPath.row]) + " Cals"
        } else if mealTime == "Lunch" {
            cell.foodLbl?.text = foodL[indexPath.row]
            cell.calLbl?.text = String(foodLC[indexPath.row]) + " Cals"
        } else if mealTime == "Dinner" {
            cell.foodLbl?.text = foodD[indexPath.row]
            cell.calLbl?.text = String(foodDC[indexPath.row]) + " Cals"
        } else if mealTime == "Snacks" {
            cell.foodLbl?.text = foodS[indexPath.row]
            cell.calLbl?.text = String(foodSC[indexPath.row]) + " Cals"
        } else {
            cell.foodLbl?.text = foodB[indexPath.row]
            cell.calLbl?.text = String(foodBC[indexPath.row]) + " Cals"
        }
        return cell
    }
    
    func tableView(_ foodTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        index = indexPath.row;
        //  print(index)
        op = "update"
        performSegue(withIdentifier: "consumption2addnew", sender: nil)
    }
    
    func showAddFoodConsumptionAlert(){
        // Create the alert controller
        let alertController = UIAlertController(title: "Add Consumption", message: "Add New/Choose Consumption", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Add Food Pressed")
            self.goToAddNewFoodVC()
        }
        let chooseAction = UIAlertAction(title: "Choose", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Choose Food Pressed")
            self.goToNewFoodVC()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Cancel Alert Box")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(chooseAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func goToAddNewFoodVC() {
        op = "add"
        self.performSegue(withIdentifier: "consumption2addnew", sender: self)
    }
    
    func goToNewFoodVC() {
        self.performSegue(withIdentifier: "consumption2add", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("prepareForSegue", "prepareForSegue")
        if segue.identifier == "consumption2addnew"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! AddNewFoodViewController
            targetController.mealTime = mealTime
            if(op == "add"){
                targetController.operation = op
            } else if (op == "update" && !(foodDictionary[mealTime])!.isEmpty){
                let consumptionItem = (foodDictionary[mealTime]!)[index]
                print((foodDictionary[mealTime]!))
                targetController.operation = op
                targetController.consumptionItem = consumptionItem as AnyObject
            }
        } else if segue.identifier == "consumption2add"{
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
        print("Data Reloaded")
        
    }
    
    func saveFood(foodName: String, foodCalorie: Double, foodType: String, foodDate: Date) {
        guard let appDelegate = UIApplication.shared.delegate
            as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Food",in: managedContext)!
        let foodItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        foodItem.setValue(foodName, forKeyPath: "name")
        foodItem.setValue(foodDate, forKeyPath: "date")
        foodItem.setValue(foodCalorie, forKeyPath: "calorie")
        foodItem.setValue(foodType, forKeyPath: "type")
        
        do {
            try managedContext.save()
            food.append(foodItem)
            //getFood(index: 0)
            fillArrays()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getFood (index: Int) {
        let x = food[index]
        let type = x.value(forKeyPath: "type") as? String
        
        if type == "Breakfast" {
            foodB.append((x.value(forKeyPath: "name") as? String)!)
        } else if type == "Lunch" {
            foodL.append((x.value(forKeyPath: "name") as? String)!)
        } else if type == "Dinner" {
            foodD.append((x.value(forKeyPath: "name") as? String)!)
        } else if type == "Snacks" {
            foodS.append((x.value(forKeyPath: "name") as? String)!)
        } else {
            //Do nothing
        }
        foodTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            let index = indexPath.row
            if (!(foodDictionary[mealTime])!.isEmpty){
                if mealTime == "Breakfast" {
                    foodB.remove(at: index)
                } else if mealTime == "Lunch" {
                    foodL.remove(at: index)
                } else if mealTime == "Dinner" {
                    foodD.remove(at: index)
                } else if mealTime == "Snacks" {
                    foodS.remove(at: index)
                }
                let foodList : [NSManagedObject] = foodDictionary[mealTime]!
                let foodToBeDeleted = foodList[index]
                print(foodList)
                //TODO check for null entity.
                self.deleteData(name: (foodToBeDeleted.value(forKey:"name")! as AnyObject).description)
                self.fillAndReload()
            }
        }
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
        foodB.removeAll()
        foodL.removeAll()
        foodD.removeAll()
        foodS.removeAll()
        
        foodBC.removeAll()
        foodLC.removeAll()
        foodDC.removeAll()
        foodSC.removeAll()
        
        foodBQ.removeAll()
        foodLQ.removeAll()
        foodDQ.removeAll()
        foodSQ.removeAll()
        
        foodDictionary.removeAll()
        
        formatter.dateFormat = "MM.dd.yyyy"
        let currentDate = self.formatter.string(from: (self.date))
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Consume")
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        print(dateFrom)
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
                
                if (foodDictionary[_consumption.type!] == nil) {
                    // now val is not nil and the Optional has been unwrapped, so use it
                    foodDictionary[_consumption.type!] = Array<NSManagedObject>()
                }
                foodDictionary[_consumption.type!]?.append(_consumption)
                
                if _consumption.type == "Breakfast" {
                    foodB.append(_consumption.name!)
                    foodBC.append(Int(_consumption.calorie))
                    foodBIC.append(Int(_consumption.icalorie))
                    foodBQ.append(_consumption.count)
                } else if _consumption.type == "Lunch" {
                    foodL.append(_consumption.name!)
                    foodLC.append(Int(_consumption.calorie))
                    foodLIC.append(Int(_consumption.icalorie))
                    foodLQ.append(_consumption.count)
                } else if _consumption.type == "Dinner" {
                    foodD.append(_consumption.name!)
                    foodDC.append(Int(_consumption.calorie))
                    foodDIC.append(Int(_consumption.icalorie))
                    foodDQ.append(_consumption.count)
                } else if _consumption.type == "Snacks" {
                    foodS.append(_consumption.name!)
                    foodSC.append(Int(_consumption.calorie))
                    foodSIC.append(Int(_consumption.icalorie))
                    foodSQ.append(_consumption.count)
                } else {
                    //Do nothing
                }
                foodTableView.reloadData()
            }
            let sumBC = foodBC.reduce(0, +)
            let sumLC = foodLC.reduce(0, +)
            let sumDC = foodDC.reduce(0, +)
            let sumSC = foodSC.reduce(0, +)
            let totalSum = sumBC + sumLC + sumDC + sumSC
            print(totalSum)
            consumedCalorieLbl.text = String(totalSum) + " Cal"
            
            UserDefaults.standard.set(String(totalSum), forKey: "ConsumedCal_" + currentDate)  //Integer
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}
