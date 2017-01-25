//
//  TimingModel.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/1/25.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import Foundation

class TimingModel {
    // MARK: - Timer
    private var timer : Timer?
    
    private var workTime : Int! = 300
    private var restTime : Int! = 900
    private var remainTime : Int! = 0
    
    @objc private func countDown() {
        remainTime = remainTime! + 1
        NotificationCenter.default.post(name: Notification.Name("updateTimeLabel"), object: nil)
    }
    
    //MARK: - public function
    func working() {
        getOneUnitWorkTime()
        remainTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func cancel() {
        timer?.invalidate()
    }
    
    func rest() {
        remainTime = getOneUnitRestTime()
    }
    
    func skipRestToWork() {
        
    }
    
    //MARK: - private function
    private func getOneUnitWorkTime() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: now))
        
        workTime = hour! <= 12 ? 90*60 : 25*60;
    }
    
    private func getOneUnitRestTime() -> Int {
        return 60 * 5
    }
    
    // MARK: - Output
    var minute: String {
        get {
            return String(remainTime! / 60)
        }
    }
    
    var second: String {
        get {
            return String(remainTime! % 60)
        }
    }
}
