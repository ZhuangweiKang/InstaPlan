//
//  AddClassController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/19/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit
import AVFoundation

class AddClassController: UIViewController {

    
    @IBOutlet weak var classNameTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var instructor_ta_info_text_field: UITextView!
    
    @IBOutlet weak var additional_info_text_field: UITextView!
    
    let timePickerView: UIDatePicker = UIDatePicker()
    
    let endDatePickerView: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var red_btn: UIButton!
    @IBOutlet weak var orange_btn: UIButton!
    @IBOutlet weak var yellow_btn: UIButton!
    @IBOutlet weak var green_btn: UIButton!
    @IBOutlet weak var blue_btn: UIButton!
    
    var red_clicked: Bool = false
    var orange_clicked: Bool = false
    var yellow_clicked: Bool = false
    var green_clicked: Bool = false
    var blue_clicked: Bool = false
    
    var class_color: String = ""
    
    func updateUI() {
        var days: String = ""
        for day in selectedWeekdays{
            days += day + " "
        }
        dayTextField.text = days
        print("day: " + dayTextField.text!)
        //selectedWeekdays = []
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black

        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 20)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "InstaPlan"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([textBtn, flexSpace, okBarBtn], animated: true)
        
        endDateTextField.inputAccessoryView = toolBar
        
        timeTextField.inputAccessoryView = toolBar

        timePickerView.datePickerMode = UIDatePickerMode.time
        timeTextField.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(self.timePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        endDatePickerView.datePickerMode = UIDatePickerMode.date
        endDateTextField.inputView = endDatePickerView
        endDatePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddClassController.updateUI), name: NSNotification.Name(rawValue: "UpdateDayTextField"), object: nil)
    }
    
    func donePressed() {
        endDateTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getUserInput() -> (class_name: String, class_time: String, class_day: String, enddate: NSDate, class_color: String, instructor_ta_info: String, additional_info: String){
        
        let class_name: String = self.classNameTextField.text!
        let class_time: String = self.timeTextField.text!
        let class_day: String = self.dayTextField.text!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let enddate: NSDate = dateFormatter.date(from: self.endDateTextField.text!)! as NSDate
        
        let instructor_ta_info: String = self.instructor_ta_info_text_field.text!
        let additional_info: String = self.additional_info_text_field.text!
        
        return (class_name, class_time, class_day, enddate, class_color, instructor_ta_info, additional_info)
        
    }
    
    func goback() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let todayView = storyBoard.instantiateViewController(withIdentifier: "startPoint")
        
        self.present(todayView, animated: true, completion: nil)
    }

    func jumpToPickWeekdays() {
        let popChoosedayView = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "weekDays") as! PickWeekDaysController
        
        self.addChildViewController(popChoosedayView)
        popChoosedayView.view.frame = self.view.frame
        self.view.addSubview(popChoosedayView.view)
        popChoosedayView.didMove(toParentViewController: self)
    }
    
    @IBAction func cancelAddClass(_ sender: Any) {
        goback()
    }

    @IBAction func addClass(_ sender: Any) {
        //store class information into database
        let class_name: String
        let class_time: String
        let class_day: String
        let enddate: NSDate
        let class_color: String
        let instructor_ta_info: String
        let additional_info: String
        (class_name, class_time, class_day, enddate, class_color, instructor_ta_info, additional_info) = getUserInput()
        CoreDataController().storeClass(class_name: class_name, class_time: class_time, class_color: class_color, class_day: class_day, class_end_date: enddate, instructor_ta_info: instructor_ta_info, additional_info: additional_info)
        goback()
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        
        timeFormatter.timeStyle = .short
        
        timeTextField.text = timeFormatter.string(from: sender.date)
    }
    
    
    func endDatePickerValueChanged(sender: UIDatePicker) {
        
        let enddateFormatter = DateFormatter()
        
        enddateFormatter.dateStyle = .full
        
        enddateFormatter.timeStyle = .none
        
        endDateTextField.text = enddateFormatter.string(from: sender.date)
    }
    @IBAction func timeTextAction(_ sender: UITextField) {
        
        
    }
    
    @IBAction func dayTextFieldAction(_ sender: UITextField) {
        jumpToPickWeekdays()
    }
    
    @IBAction func endDateTextFieldAction(_ sender: UITextField) {
        
        
    }
    
    @IBAction func colorTextFieldAction(_ sender: Any) {
        
    }
    
    @IBAction func red_btn_action(_ sender: Any) {
        if(!self.red_clicked){
            red_btn.setImage(#imageLiteral(resourceName: "red_check"), for: .normal)
            red_clicked = true
            orange_btn.isEnabled = false
            yellow_btn.isEnabled = false
            green_btn.isEnabled = false
            blue_btn.isEnabled = false
            self.class_color = "Red"
        }
        else{
            red_btn.setImage(#imageLiteral(resourceName: "red"), for: .normal)
            red_clicked = false
            orange_btn.isEnabled = true
            yellow_btn.isEnabled = true
            green_btn.isEnabled = true
            blue_btn.isEnabled = true
            self.class_color = ""
        }
    }
    
    @IBAction func orange_btn_action(_ sender: Any) {
        if(!self.orange_clicked){
            orange_btn.setImage(#imageLiteral(resourceName: "orange_check"), for: .normal)
            orange_clicked = true
            red_btn.isEnabled = false
            yellow_btn.isEnabled = false
            green_btn.isEnabled = false
            blue_btn.isEnabled = false
            self.class_color = "Orange"
        }
        else{
            orange_btn.setImage(#imageLiteral(resourceName: "orange"), for: .normal)
            orange_clicked = false
            red_btn.isEnabled = true
            yellow_btn.isEnabled = true
            green_btn.isEnabled = true
            blue_btn.isEnabled = true
            self.class_color = ""
        }
    }
    
    @IBAction func yellow_btn_action(_ sender: Any) {
        if(!self.yellow_clicked){
            yellow_btn.setImage(#imageLiteral(resourceName: "yellow_check"), for: .normal)
            yellow_clicked = true
            red_btn.isEnabled = false
            orange_btn.isEnabled = false
            green_btn.isEnabled = false
            blue_btn.isEnabled = false
            self.class_color = "Yellow"
        }
        else{
            yellow_btn.setImage(#imageLiteral(resourceName: "yellow"), for: .normal)
            yellow_clicked = false
            red_btn.isEnabled = true
            orange_btn.isEnabled = true
            green_btn.isEnabled = true
            blue_btn.isEnabled = true
            self.class_color = ""
        }
    }
    
    @IBAction func green_btn_action(_ sender: Any) {
        if(!self.green_clicked){
            green_btn.setImage(#imageLiteral(resourceName: "green_check"), for: .normal)
            green_clicked = true
            red_btn.isEnabled = false
            orange_btn.isEnabled = false
            yellow_btn.isEnabled = false
            blue_btn.isEnabled = false
            self.class_color = "Green"
        }
        else{
            green_btn.setImage(#imageLiteral(resourceName: "green"), for: .normal)
            green_clicked = false
            red_btn.isEnabled = true
            orange_btn.isEnabled = true
            yellow_btn.isEnabled = true
            blue_btn.isEnabled = true
            self.class_color = ""
        }
    }
    
    @IBAction func blue_btn_action(_ sender: Any) {
        if(!self.blue_clicked){
            blue_btn.setImage(#imageLiteral(resourceName: "blue_check"), for: .normal)
            blue_clicked = true
            red_btn.isEnabled = false
            orange_btn.isEnabled = false
            yellow_btn.isEnabled = false
            green_btn.isEnabled = false
            self.class_color = "Blue"
        }
        else{
            blue_btn.setImage(#imageLiteral(resourceName: "blue"), for: .normal)
            blue_clicked = false
            red_btn.isEnabled = true
            orange_btn.isEnabled = true
            yellow_btn.isEnabled = true
            green_btn.isEnabled = true
            self.class_color = ""
        }
    }
}
