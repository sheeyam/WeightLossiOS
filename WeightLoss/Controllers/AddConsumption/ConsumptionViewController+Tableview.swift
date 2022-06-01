//
//  ConsumptionViewController+Tableview.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 6/1/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import UIKit

extension ConsumptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ foodTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodData.filter({$0.foodType.uppercased() == mealTime.uppercased()}).count
    }
    
    func tableView(_ foodTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = foodData.filter({$0.foodType.uppercased() == mealTime.uppercased()})
        let cell:CustomConsumeCell = foodTableView.dequeueReusableCell(withIdentifier: CustomConsumeCell.identifier, for: indexPath) as! CustomConsumeCell
        cell.configureCell(foodData: data[indexPath.row])
        return cell
    }
    
    func tableView(_ foodTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        op = Constants.operations.update
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
