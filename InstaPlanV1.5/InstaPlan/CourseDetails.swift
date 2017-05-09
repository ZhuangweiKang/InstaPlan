//
//  CourseDetails.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/30/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

var courses: [Course] = []


class CourseDetails: UIViewController {

    @IBOutlet weak var class_name: UITextField!
    @IBOutlet weak var class_time: UITextField!
    @IBOutlet weak var class_day: UITextField!
    @IBOutlet weak var class_end_date: UITextField!
    @IBOutlet weak var red_btn: UIButton!
    @IBOutlet weak var orange_btn: UIButton!
    @IBOutlet weak var yellow_btn: UIButton!
    @IBOutlet weak var green_btn: UIButton!
    @IBOutlet weak var blue_btn: UIButton!
    @IBOutlet weak var instructor_ta_info: UITextView!
    @IBOutlet weak var additional_info: UITextView!
    
    @IBOutlet weak var edit_btn: UIBarButtonItem!
    var checked_color_btn: UIButton = UIButton()
    
    var color: String = ""
    
    var red_clicked: Bool = false
    var orange_clicked: Bool = false
    var yellow_clicked: Bool = false
    var green_clicked: Bool = false
    var blue_clicked: Bool = false
    
    var class_color: String = ""
    
    let timePickerView: UIDatePicker = UIDatePicker()
    
    let endDatePickerView: UIDatePicker = UIDatePicker()
    
    let empty_color = UIButton()
    func updateUI() {
        var days: String = ""
        for day in selectedWeekdays{
            days += day + " "
        }
        class_day.text = days
        print("day: " + class_day.text!)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        class_name.text = courses[search_index].class_name
        
        class_time.text = courses[search_index].class_time
        class_day.text = courses[search_index].class_day
        let dateformater = DateFormatter()
        dateformater.dateStyle = .full
        dateformater.timeStyle = .none
        
        class_end_date.text = dateformater.string(from: courses[search_index].class_end_date! as Date)
        
        if courses[search_index].class_color == "Red" {
            red_btn.setImage(#imageLiteral(resourceName: "red_check"), for: .normal)
            checked_color_btn = red_btn
        }
        else if (courses[search_index].class_color == "Orange"){
            orange_btn.setImage(#imageLiteral(resourceName: "orange_check"), for: .normal)
            checked_color_btn = orange_btn
        }
        else if (courses[search_index].class_color == "Yellow"){
            yellow_btn.setImage(#imageLiteral(resourceName: "yellow_check"), for: .normal)
            checked_color_btn = yellow_btn
        }
        else if (courses[search_index].class_color == "Green"){
            green_btn.setImage(#imageLiteral(resourceName: "green_check"), for: .normal)
            checked_color_btn = green_btn
        }
        else if (courses[search_index].class_color == "Blue"){
            blue_btn.setImage(#imageLiteral(resourceName: "blue_check"), for: .normal)
            checked_color_btn = blue_btn
        }
        else{
            checked_color_btn = empty_color
        }
        instructor_ta_info.text = courses[search_index].instructor_ta_info
        additional_info.text = courses[search_index].aditional_info
        class_name.isEnabled = false
        class_time.isEnabled = false
        class_day.isEnabled = false
        class_end_date.isEnabled = false
        instructor_ta_info.isEditable = false
        additional_info.isEditable = false
        
        red_btn.isEnabled = false
        orange_btn.isEnabled = false
        yellow_btn.isEnabled = false
        green_btn.isEnabled = false
        blue_btn.isEnabled = false
        
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
        
        class_end_date.inputAccessoryView = toolBar
        
        class_time.inputAccessoryView = toolBar
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        class_time.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(self.timePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        endDatePickerView.datePickerMode = UIDatePickerMode.date
        class_end_date.inputView = endDatePickerView
        endDatePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CourseDetails.updateUI), name: NSNotification.Name(rawValue: "UpdateDayTextField"), object: nil)
        
    }

    
    @IBAction func goback(_ sender: Any) {
        back()
    }

    func back() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let todayView = storyBoard.instantiateViewController(withIdentifier: "startPoint")
        
        self.present(todayView, animated: true, completion: nil)
        
        backfrom = "Search"
    }
    
    func donePressed() {
        class_end_date.resignFirstResponder()
        class_time.resignFirstResponder()
    }
    
    func getUserInput() -> (class_name: String, class_time: String, class_day: String, enddate: NSDate, class_color: String, instructor_ta_info: String, additional_info: String){
        
        let class_name: String = self.class_name.text!
        let class_time: String = self.class_time.text!
        let class_day: String = self.class_day.text!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let enddate: NSDate = dateFormatter.date(from: self.class_end_date.text!)! as NSDate
        
        let instructor_ta_info: String = self.instructor_ta_info.text!
        let additional_info: String = self.additional_info.text!
        
        return (class_name, class_time, class_day, enddate, class_color, instructor_ta_info, additional_info)
        
    }

    
    func jumpToPickWeekdays() {
        let popChoosedayView = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "weekDays") as! PickWeekDaysController
        
        self.addChildViewController(popChoosedayView)
        popChoosedayView.view.frame = self.view.frame
        self.view.addSubview(popChoosedayView.view)
        popChoosedayView.didMove(toParentViewController: self)
    }
    
    @IBAction func edit_action(_ sender: Any) {
        if edit_btn.title == "Edit" {
            edit_btn.title = "Save"
            class_name.isEnabled = true
            class_time.isEnabled = true
            class_day.isEnabled = true
            class_end_date.isEnabled = true
            if checked_color_btn == empty_color {
                
                red_btn.isEnabled = true
                orange_btn.isEnabled = true
                yellow_btn.isEnabled = true
                green_btn.isEnabled = true
                blue_btn.isEnabled = true
                
            }else{
                checked_color_btn.isEnabled = true
            }
            instructor_ta_info.isEditable = true
            additional_info.isEditable = true
        }
        else{
            let class_name: String
            let class_time: String
            let class_day: String
            let enddate: NSDate
            let class_color: String
            let instructor_ta_info: String
            let additional_info: String
            (class_name, class_time, class_day, enddate, class_color, instructor_ta_info, additional_info) = getUserInput()
            CoreDataController().modify_class(class_name: class_name, class_time: class_time, class_color: class_color, class_day: class_day, class_end_date: enddate, instructor_ta_info: instructor_ta_info, additional_info: additional_info)
            back()
        }
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateStyle = .none
        
        timeFormatter.timeStyle = .short
        
        class_time.text = timeFormatter.string(from: sender.date)
    }
    
    
    func endDatePickerValueChanged(sender: UIDatePicker) {
        
        let enddateFormatter = DateFormatter()
        
        enddateFormatter.dateStyle = .full
        
        enddateFormatter.timeStyle = .none
        
        class_end_date.text = enddateFormatter.string(from: sender.date)
    }
    
    @IBAction func dayTextFieldAction(_ sender: UITextField) {
        jumpToPickWeekdays()
    }
    
    @IBAction func red_btn_action(_ sender: Any) {
        if(!self.red_clicked && (checked_color_btn != red_btn || checked_color_btn == empty_color)){
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
        if(!self.orange_clicked && (checked_color_btn != orange_btn || checked_color_btn == empty_color)){
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
        if(!self.yellow_clicked && (checked_color_btn != yellow_btn || checked_color_btn == empty_color)){
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
        if(!self.green_clicked && (checked_color_btn != green_btn || checked_color_btn == empty_color)){
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
        if(!self.blue_clicked && (checked_color_btn != blue_btn || checked_color_btn == empty_color)){
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
