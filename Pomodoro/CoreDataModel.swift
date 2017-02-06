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
    
    class func saveStartTime() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "WorkTime", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(Date(), forKey: "startTime")
        
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    class func saveEndTime() {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            
            for oneWorkUnit in fetchResult as [NSManagedObject] {
                if oneWorkUnit.value(forKey: "endTime") == nil {
                    oneWorkUnit.setValue(Date(), forKey: "endTime")
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func deleteCurrentWork() {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            
            for oneWorkUnit in fetchResult as [NSManagedObject] {
                if oneWorkUnit.value(forKey: "endTime") == nil {
                    context.delete(oneWorkUnit)                    
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func readWorkTime() -> Int {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
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
    
    class func readAllWorkTime() -> Int {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        
        do {
            let context = getContext()
            let fetchResult = try context.fetch(fetchRequest)
            var totalWorkTime: TimeInterval = 0
            
            for oneWorkUnit in fetchResult as [WorkTime] {
                guard oneWorkUnit.value(forKey: "endTime") != nil else {
                    continue
                }
                
                let startTime = oneWorkUnit.startTime as! Date
                let endTime = oneWorkUnit.endTime as! Date
                totalWorkTime = totalWorkTime + endTime.timeIntervalSince(startTime)
            }
            
            return Int(totalWorkTime)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}
