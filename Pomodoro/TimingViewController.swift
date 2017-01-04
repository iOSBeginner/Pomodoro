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
    
    var status : String? //working, rest, nothing
    var timer : Timer?
    var remainTime : Int! = 300
    var oneTimeUnit : Int! = 300
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTimeUnit = 300
        remainTime = oneTimeUnit
        
        status = "nothing"
        
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if status == "nothing" || status == "rest" {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            sender.setTitle("暫停", for: .normal)
            status = "working"
        }
        else if status == "working" {
            timer?.invalidate()
            sender.setTitle("開始", for: .normal)
            status = "rest"
        }
    }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    // MARK: - Timer
    
    @objc fileprivate func countDown() {
        remainTime = remainTime! - 1
        
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
        
        if remainTime == 0 {
            timer?.invalidate()
        }
    }
}
