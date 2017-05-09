//
//  PickWeekDaysController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/19/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

var selectedWeekdays: [String] = []

class PickWeekDaysController: UIViewController {

    @IBOutlet weak var monday: UISwitch!
    @IBOutlet weak var tuesday: UISwitch!
    @IBOutlet weak var wednesday: UISwitch!
    @IBOutlet weak var thursday: UISwitch!
    @IBOutlet weak var friday: UISwitch!
    @IBOutlet weak var saturday: UISwitch!
    @IBOutlet weak var sunday: UISwitch!
    
    let days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var weekdays: [UISwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedWeekdays = []
        weekdays = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        // Do any additional setup after loading the view.
    }

    @IBAction func doneAction(_ sender: Any) {
        checkSwitches()
        updateAllUI()
        self.view.removeFromSuperview()
    }

    func updateAllUI() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateDayTextField"), object: nil)
    }
    
    func checkSwitches() {
        for day in weekdays{
            if day.isOn {
                //print(days[weekdays.index(of: day)!])
                selectedWeekdays.append(days[weekdays.index(of: day)!])
            }
        }
    }
}
