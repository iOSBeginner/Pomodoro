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
        
        registerObserver()
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {        
        switch status {
        case "nothing":
            model.working()
            startButton.setTitle("取消", for: .normal)
        case "working":
            if Int(model.minute)! <= 9 {
                model.cancel()
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
    private func registerObserver() {
        updateTimeLabel()
        changeButtonTitle()
    }
    
    private func updateTimeLabel() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"updateTimeLabel"), object:nil, queue:nil) {_ in
            self.minuteLabel.text = self.model.minute
            self.secondLabel.text = self.model.second
        }
    }
    
    private func changeButtonTitle() {
        NotificationCenter.default.addObserver(forName: Notification.Name("changeButtonTitle"), object:nil, queue:nil) {notification in
            self.startButton.setTitle(notification.object as! String?, for: .normal)
        }
    }
}
