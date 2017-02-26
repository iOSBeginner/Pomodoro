//
//  HistoryTableViewController.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/2/6.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    private var workData: [[WorkTime]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        workData = CoreDataModel.getAllWorkTimeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let q = DispatchQueue.init(label: "getAllWorkTimeData", qos: .userInteractive)
        q.async {
            let newWorkData = CoreDataModel.getAllWorkTimeData()
            
            if newWorkData?[0].count != self.workData?[0].count {
                self.workData = newWorkData
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return workData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workData?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let oneWorkUnit = workData?[indexPath.section][indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTimeString = dateFormatter.string(from: oneWorkUnit?.startTime! as! Date)
        let endTimeString = dateFormatter.string(from: oneWorkUnit?.endTime! as! Date)
        
        cell.textLabel?.text = "\(startTimeString) ~ \(endTimeString)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard (workData?.count)! > 0 && (workData?[section].count)! > 0 else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM/dd EEE"
        let date = dateFormatter.string(from: workData?[section][0].startTime as! Date)
        return date
    }
    
    // MARK: - Delegation
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataModel.deleteWorkRecord(date: workData?[indexPath.section][indexPath.row].startTime as! Date)
            workData?[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
