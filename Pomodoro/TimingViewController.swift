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
    
    private let model = TimingModel()
    private let userPrefence = UserDefaults.standard
    
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
}
