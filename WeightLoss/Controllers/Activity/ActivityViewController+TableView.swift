//
//  ActivityViewController+TableView.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import UIKit

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if activityData.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = activityTableView.dequeueReusableCell(withIdentifier: HistoryViewCell.identifier, for: indexPath) as! HistoryViewCell
        cell.configureCell(activityData: activityData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.activityTableView.reloadData()
        }
    }
}
