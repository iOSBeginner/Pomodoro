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
    
    var status : String? //working, rest, nothing
    var timer : Timer?
    
    var workTime : Int! = 300
    var restTime : Int! = 900
    
    var remainTime : Int! = 300
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status = "nothing"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let now = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hour = Int(dateFormatter.string(from: now))
        
        workTime = hour! <= 12 ? 90*60 : 25*60;
        remainTime = workTime
        
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if status == "nothing" {
            working()
        }
        else if status == "working" {
            pause()
        }
        else if status == "pause" {
            restart()
        }
        else if status == "rest" {
            cancel()
            startButton.setTitle("開始", for: .normal)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        cancel()
        startButton.titleLabel?.text = "開始"
    }
    
    //MARK: - status function
    
    fileprivate func working() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        remainTime = workTime
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
        startButton.setTitle("暫停", for: .normal)
        status = "working"
    }
    
    fileprivate func pause() {
        startButton.setTitle("繼續", for: .normal)
        timer?.invalidate()
        status = "pause"
    }
    
    fileprivate func restart() {
        startButton.setTitle("暫停", for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        status = "working"
    }
    
    fileprivate func cancel() {
        status = "nothing"
        
        remainTime = workTime
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
        
        timer?.invalidate()
    }
    
    // MARK: - Timer
    
    @objc fileprivate func countDown() {
        remainTime = remainTime! - 1
        minuteLabel.text = String(remainTime! / 60)
        secondLabel.text = String(remainTime! % 60)
        
        if remainTime == 0 {
            if status == "working" {
                status = "rest"
                remainTime = restTime
                startButton.titleLabel?.text = "跳過"
            }
            else if status == "rest" {
                status = "nothing"
                remainTime = workTime
                startButton.setTitle("開始", for: .normal)
                timer?.invalidate()
            }

        }
    }
}
