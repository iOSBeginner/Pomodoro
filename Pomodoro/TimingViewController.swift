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
    @IBOutlet weak var workHourLabel: UILabel!
    
    private let model = TimingModel()
    private let userPrefence = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObserver()
        model.restartCounting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let workTime = CoreDataModel.readWorkTime()
        workHourLabel.text = "\(workTime / 60):\(workTime % 60)"
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {        
        switch status {
        case "nothing":
            model.working()
        case "working":
            if Int(model.minute)! <= 9 {
                model.cancel()
            }
            else {
                model.rest()
            }
        case "rest":
            model.skipRestToWork()
        default: break
        }
    }
    
    //MARK: - NotificationCenter
    private func registerObserver() {
        updateTimeLabel()
        changeButtonTitle()
        restartContingObserver()
    }
    
    private func updateTimeLabel() {
        NotificationCenter.default.addObserver(forName: Notification.Name("updateTimeLabel"), object:nil, queue:nil) {_ in
            self.minuteLabel.text = self.model.minute
            self.secondLabel.text = self.model.second
        }
    }
    
    private func changeButtonTitle() {
        NotificationCenter.default.addObserver(forName: Notification.Name("changeButtonTitle"), object:nil, queue:nil) {notification in
            self.startButton.setTitle(notification.object as! String?, for: .normal)
        }
    }
    
    private func restartContingObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("restartCounting"), object:nil, queue:nil) {_ in
            self.model.restartCounting()
        }
    }
}
