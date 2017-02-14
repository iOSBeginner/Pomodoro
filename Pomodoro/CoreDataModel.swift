//
//  CoreDataModel.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/2/4.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataModel {
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Public Method
    
    class func saveWorkRecord() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WorkTime", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        let startTime = UserDefaults.standard.value(forKey: "StartCountingTime") as! Date
        managedObj.setValue(startTime, forKey: "startTime")
        managedObj.setValue(Date(), forKey: "endTime")

        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    class func readTodayWorkTime() -> Int {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 00
        components.minute = 00
        components.second = 00
        let today = calendar.date(from: components)!
        
        let predicate = NSPredicate(format: "startTime >= %@", argumentArray: [today])
        fetchRequest.predicate = predicate
        
        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            var totalWorkTime: TimeInterval = 0
            
            for oneWorkUnit in fetchResult as [NSManagedObject] {
                guard oneWorkUnit.value(forKey: "endTime") != nil else {
                    continue
                }
                
                let startTime = oneWorkUnit.value(forKey: "startTime") as! Date
                let endTime = oneWorkUnit.value(forKey: "endTime") as! Date
                totalWorkTime = totalWorkTime + endTime.timeIntervalSince(startTime)
            }
            
            return Int(totalWorkTime)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    class func getAllWorkTimeData() -> [WorkTime] {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        var workData: [WorkTime] = []

        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            
            for oneWorkUnit in fetchResult as [WorkTime] {
                workData.append(oneWorkUnit)
            }
            
            return workData
        } catch {
            print(error.localizedDescription)
            return workData
        }
    }
    
    class func deleteWorkRecord(row: Int) {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            context.delete(fetchResult[row])
            
            do {
                try context.save()
            } catch {
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
