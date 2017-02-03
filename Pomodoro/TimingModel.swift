//
//  TimingModel.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/1/25.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import Foundation
import UserNotifications

class TimingModel {
    private var timer : Timer?
    
    private var workTime : Int! = 300
    private var restTime : Int! = 900
    private var remainTime : Int! = 0
    
    private let notificationCenter = NotificationCenter.default
    
    //MARK: - public function
    func working() {
        status = statusEnum.working.rawValue
        
        let workTime = getOneUnitWorkTime()
        remainTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        
        cancelLocalNotification(identifier: "rest")
        setLocalNotification(title: "休息一下吧！", body: "你工作 \(workTime/60) 分鐘了", fireTime: workTime, identifier: "work")
        
        notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "取消")
    }
    
    func cancel() {
        status = statusEnum.nothing.rawValue
        
        timer?.invalidate()
        remainTime = 0
        notificationCenter.post(name: Notification.Name("updateTimeLabel"), object: nil)
        
        cancelLocalNotification(identifier: "work")
        notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "開始工作")
    }
    
    func rest() {
        status = statusEnum.rest.rawValue
        
        remainTime = getOneUnitRestTime()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        cancelLocalNotification(identifier: "work")
        setLocalNotification(title: "該工作囉！",body: "休息時間結束", fireTime: getOneUnitRestTime(), identifier: "rest")
        
        notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "跳過休息開始工作")
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
            notificationCenter.post(name: Notification.Name("changeButtonTitle"), object: "開始工作")
            status = statusEnum.nothing.rawValue
        }
    }
    
    // Mark: - LocalNotification
    
    private func setLocalNotification(title: String, body: String, fireTime: Int, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(fireTime), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("\(error)")
            }
        })
    }
    
    private func cancelLocalNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    //MARK: - private function
    private func getOneUnitWorkTime() -> Int {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: now))
        
        workTime = hour! <= 12 ? 90*60 : 25*60;
        
        return workTime
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
