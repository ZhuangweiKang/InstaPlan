//
//  AddCustomNotesController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/25/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

class AddCustomNotesController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.layer.borderWidth = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
    }
    
    func goback() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let todayView = storyBoard.instantiateViewController(withIdentifier: "startPoint")
        backfrom = "Notes"
        self.present(todayView, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        //Save notes content to database
        let custom_notes: String = self.textField.text
        let alert = UIAlertController(title: "Note Name", message: "Enter note name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Note Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            CoreDataController().storeCustomNotes(custom_notes: custom_notes, note_name: (textField?.text)!)
            self.goback()
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        goback()
    }
    
    
    
    @IBAction func clear(_ sender: Any) {
        self.textField.text = ""
    }
}
