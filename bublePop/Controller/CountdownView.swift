//
//  TimerView.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 22/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import UIKit
import GameKit
class CountdownView: UIViewController {

    var count = 4
    var timer: Timer?
    @IBOutlet weak var countDown: UILabel!
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Countdown), userInfo: nil, repeats: true)
        Countdown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func Countdown() {//Count down and perform Segue to GamePlayView
        count = count - 1
        if count > 0 {
            countDown.text = "\(count)"
        }
        if count == 0 {
            performSegue(withIdentifier: "startGame", sender: nil)
        }
    }
}
