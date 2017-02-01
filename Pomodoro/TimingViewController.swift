//
//  TimingViewController.swift
//  Pomodoro
//
//  Created by 蘇健豪1 on 2017/1/4.
//  Copyright © 2017年 Oyster. All rights reserved.
//

import UIKit

class TimingViewController: UIViewController {
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let model = TimingModel()
    let userPrefence = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            status = statusEnum.nothing.rawValue
        #endif
        
        updateTimeLabel()
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {        
        switch status {
        case "nothing":
            model.working()
            status = statusEnum.working.rawValue
            startButton.setTitle("取消", for: .normal)
        case "working":
            if Int(model.minute)! <= 9 {
                model.cancel()
                status = statusEnum.nothing.rawValue
                startButton.setTitle("開始", for: .normal)
            }
            else {
                model.rest()
                startButton.setTitle("跳過休息開始工作", for: .normal)
            }
        case "rest":
            model.skipRestToWork()
            startButton.setTitle("跳過休息開始工作", for: .normal)
        default: break
        }
    }
    
    //MARK: - NotificationCenter
    private func updateTimeLabel() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"updateTimeLabel"), object:nil, queue:nil) {_ in
            self.minuteLabel.text = self.model.minute
            self.secondLabel.text = self.model.second
        }
    }
    
    private func changeButtonTitle() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"changeButtonTitle"), object:nil, queue:nil) {_ in
            self.startButton.titleLabel?.text = ""
        }
    }
    
    //MARK: - Custom Properties
    private var status: String {
        get {
            return userPrefence.value(forKey: "status") as! String
        }
        
        set {
            userPrefence.set(newValue, forKey: "status")
        }
    }
    
    private enum statusEnum : String {
        case nothing = "nothing"
        case working = "working"
        case rest = "rest"
    }
}
