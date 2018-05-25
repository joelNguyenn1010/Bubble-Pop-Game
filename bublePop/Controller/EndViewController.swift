//
//  HighScoreView.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 22/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import UIKit
class EndView: UIViewController {
    var score = Player()
    var playerStorage = PlayerManament()
    @IBOutlet weak var highScoreDisplayLabel: UILabel!
    @IBOutlet weak var playerScoreDisplayLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayScore()
        displayHighScore()
    }
    func displayScore(){
        do{
            score = try playerStorage.loadData()}
        catch{
            print(error)
        }
        playerScoreDisplayLabel.text = "\(score.playerScore)"
    }
    func displayHighScore() {
        let defaults = UserDefaults.standard
        let highscore = defaults.integer(forKey: "highscore")
        highScoreDisplayLabel.text = "High Score: \(highscore)"
    }
}
