//
//  PomodoroTests.swift
//  PomodoroTests
//
//  Created by 蘇健豪1 on 2017/1/4.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import XCTest
@testable import Pomodoro

import CoreData

class PomodoroTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetAllWorkTimeData() {
        let fetchRequest: NSFetchRequest<WorkTime> = WorkTime.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            let fetchResult = try context.fetch(fetchRequest)
            
            let workData = CoreDataModel.getAllWorkTimeData()
            var dataCount = 0
            if workData != nil {
                for i in 0..<workData!.count {
                    dataCount += workData![i].count
                }
            }
            
            XCTAssert(dataCount == fetchResult.count)
        } catch {
            print(error.localizedDescription)
        }
    }
}
