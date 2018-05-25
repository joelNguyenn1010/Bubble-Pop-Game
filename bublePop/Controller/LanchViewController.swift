//
//  ViewController.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 21/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import UIKit
import GameKit
import Firebase
class LaunchView: UIViewController {
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeSettingLabel: UILabel!
    @IBOutlet var SettingViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingViewController.layer.cornerRadius = 5
        }
    @IBAction func ChangeTime(_ sender: Any) {
        Setting.playTime = timeSlider.value*60
        timeSettingLabel.text = "\(Int(Setting.playTime))"
    }
    @IBAction func returnIsTouched(_ sender: Any) {
        settingViewOut()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // dismiss keyboard by touch anywhere in the view
    }
 
    @IBAction func goToSetting(_ sender: Any) {
        settingViewIn()
    }
    func settingViewIn() { //create Setting view with pop up animation when Setting button is touched
        self.view.addSubview(SettingViewController) //add the Setting view to the LanchView
        SettingViewController.center = self.view.center // set the screen in the center
        SettingViewController.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)// animation for the view
        SettingViewController.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.SettingViewController.alpha = 1
            self.SettingViewController.transform = CGAffineTransform.identity
        }
    }
    func settingViewOut() {
        UIView.animate(withDuration: 0.3, animations: {//create animation for Setting view when Press Dismiss
            self.SettingViewController.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
             self.SettingViewController.alpha = 0
        }) { (success: Bool) in self.SettingViewController.removeFromSuperview()}//Remove Setting View from LanchView
    }
    @IBAction func playIsTouched(_ sender: Any) {
            performSegue(withIdentifier: "EnterLoad", sender: nil)//Go the CountdownView
        }
    @IBAction func unwindToLaunchViewController (segue:UIStoryboardSegue) {
        
    }
    }



    




