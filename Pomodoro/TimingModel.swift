//
//  TimingModel.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/1/25.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import Foundation

class TimingModel {
    private var timer : Timer?
    
    private var workTime : Int! = 300
    private var restTime : Int! = 900
    private var remainTime : Int! = 0
    
    private let notificationCenter = NotificationCenter.default
    private let userPrefence = UserDefaults.standard

    //MARK: - public function
    func working() {
        status = statusEnum.working.rawValue
        
        getOneUnitWorkTime()
        remainTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    func cancel() {
        status = statusEnum.nothing.rawValue
        
        timer?.invalidate()
        remainTime = 0
        notificationCenter.post(name: Notification.Name("updateTimeLabel"), object: nil)
    }
    
    func rest() {
        status = statusEnum.rest.rawValue
        
        remainTime = getOneUnitRestTime()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func skipRestToWork() {
        working()
    }
    
    // MARK: - Timer Method
    
    @objc private func count() {
        remainTime = remainTime! + 1
        notificationCenter.post(name: Notification.Name("updateTimeLabel"), object: nil)
        
        if remainTime == 10 * 60 {
            notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "提早完成開始休息")
        }
        else if remainTime == workTime {
            notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "開始休息")
        }
    }
    
    @objc private func countDown() {
        remainTime = remainTime! - 1
        notificationCenter.post(name: Notification.Name("updateTimeLabel"), object: nil)
        
        if remainTime == 0 {
            timer?.invalidate()
            notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "開始")
            status = statusEnum.nothing.rawValue
        }
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
