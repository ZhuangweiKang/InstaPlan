//
//  Today.swift
//  InstaPlan
//
//  Created by 康壮伟 on 5/3/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

var show_class: Bool  = true
class Today: UIViewController {

    @IBOutlet weak var class_view: UIView!
    
    @IBOutlet weak var assignment_view: UIView!
   
    @IBOutlet weak var date_label: UILabel!
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClassContent().viewDidLoad()
        AssignmentContent().viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        date_label.text = formatter.string(for: date)
        
    }
    
    @IBAction func seg_action(_ sender: Any) {
        if seg.selectedSegmentIndex == 0 {
            class_view.alpha = 1
            assignment_view.alpha = 0
        }
        else{
            class_view.alpha = 0
            assignment_view.alpha = 1
        }
    }
}

