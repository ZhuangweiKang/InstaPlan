
//
//  NoteDetailController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/29/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

var notefrom: Bool = false

var search_notes: [CustomNotes] = []

class NoteDetailController: UIViewController {

    @IBOutlet weak var back_btn: UIBarButtonItem!
    @IBOutlet weak var edit_btn: UIBarButtonItem!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var note_title: UILabel!
    
    var notes: [CustomNotes] = CoreDataController().getCustomNotes()

    override func viewDidLoad() {
        super.viewDidLoad()
        note.layer.borderWidth = 5
        note.layer.borderColor = UIColor.lightGray.cgColor
        note.layer.cornerRadius = 10
        if notefrom {
            note_title.text = search_notes[search_index].note_name
            note.text = search_notes[search_index].notes_content
        }
        else{
            self.note_title.text = notes[row_index].note_name
            self.note.text = notes[row_index].notes_content
        }
        
        self.note.isEditable = false
    }
    
    func goback() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let notedetail = storyBoard.instantiateViewController(withIdentifier: "startPoint")
        if notefrom {
            backfrom = "Search"
        }
        else{
            backfrom = "Notes"
        }
        notefrom = false
        self.present(notedetail, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        goback()
    }

    @IBAction func edit(_ sender: Any) {
        if edit_btn.title == "Edit" {
            edit_btn.title = "Save"
            note.isEditable = true
        }
        else{
            CoreDataController().modify_custom_note(note_name: self.note_title.text!, note_content: self.note.text)
            self.goback()
        }
    }
}
