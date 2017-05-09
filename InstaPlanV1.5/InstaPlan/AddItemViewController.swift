//
//  AddItemViewController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/15/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
 
    
    @IBAction func addClass(_ sender: Any) {
        flag = false
        
        let storyboard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let addClassView = storyboard.instantiateViewController(withIdentifier: "addClass")
        
        self.present(addClassView, animated:true, completion:nil)
    }
    
    @IBAction func addCustomNote(_ sender: UIButton) {
        flag = false
        
        let storyboard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let addCustomNotesView = storyboard.instantiateViewController(withIdentifier: "addCustomNotes")
        
        self.present(addCustomNotesView, animated:true, completion:nil)
    }
    
    @IBAction func closePopView(_ sender: Any) {
        flag = false
        self.view.removeFromSuperview()
        
    }
   
    @IBAction func AddAssignment(_ sender: UIButton) {
        flag = false
        
        let storyboard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let addCustomNotesView = storyboard.instantiateViewController(withIdentifier: "addAssignment")
        
        self.present(addCustomNotesView, animated:true, completion:nil)
    }
    
}
