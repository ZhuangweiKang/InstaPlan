//
//  CoreDataController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/13/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit
import CoreData

var currentUserName: String!
var currentUserEmail: String!
var current_user: InstaPlanUser!

class CoreDataController: NSObject {
    
    
    
    //Get context
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    ///
    ///Store user information
    ///
    
    func storeUser(user_name: String, email_address: String, password: String) {
        let context = getContext()
        
        //define the entity
        let entity = NSEntityDescription.entity(forEntityName: "InstaPlanUser", in: context)
        
        let user = NSManagedObject(entity: entity!, insertInto: context) as! InstaPlanUser
        
        currentUserName = user_name
        current_user = user
        
        user.user_name = user_name
        user.email_address = email_address
        user.password = password
        user.login_status = true
        
        do{
            try context.save()
            
        }catch{
            print(error)
        }
    }

    
    ///
    ///Sign up input check
    ///prameter: user input email address
    ///return false if the email address has existed in CoreData
    ///
    func signupCheck(email_address: String) -> Bool {
        currentUserEmail = email_address
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPlanUser")
        do{
            let searchResuls = try getContext().fetch(fetchRequest)
            for item in (searchResuls as! [NSManagedObject]){
                let email = item.value(forKey: "email_address") as! String
                print("This is the email address: ", email)
                if email_address == email {
                    currentUserName = item.value(forKey: "user_name") as! String
                    current_user = item as! InstaPlanUser
                    return false
                }
            }
        }catch{
            print(error)
            //return true
        }
        return true
    }
    
    ///
    ///Log in check
    ///prameter: user input email address and password
    ///return false is no match user in core data
    ///
    func loginCheck(email_address: String, psd: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPlanUser")
        do{
            let searchResuls = try getContext().fetch(fetchRequest)
            for item in (searchResuls as! [NSManagedObject]){
                let email = item.value(forKey: "email_address") as! String
                let password = item.value(forKey: "password") as! String
                if email == email_address && password == psd {
                    currentUserEmail = email_address
                    currentUserName = item.value(forKey: "user_name") as! String
                    current_user = item as! InstaPlanUser
                    return true
                }
            }
        }catch{
            print(error)
            return false
        }
        return false
    }
    
    ///
    ///Rest user login status
    ///prameter: user email address
    ///
    func resetLoginStatus(email_address: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InstaPlanUser")
        do {
            let searchResuls = try getContext().fetch(fetchRequest)
            for item in (searchResuls as! [NSManagedObject]){
                if email_address == item.value(forKeyPath: "email_address") as! String{
                    item.setValue(false, forKey: "login_status")
                    let context = getContext()
                    try context.save()
                }
            }
        } catch {
            print("reset login status failed:", error)
        }
    }
    
    ///
    ///Get user username
    ///
    func getUserName() -> String {
        return String(describing: currentUserName.characters.first!)
    }
    
    ///
    ///Get full user name
    ///
    func getFullUserName() -> String {
        return currentUserName
    }

    ///
    ///Get full user email
    ///
    func getEmailAddress() -> String {
        return currentUserEmail
    }
    
    ///
    ///Get user password
    ///
    func getPassword() -> String {
        return current_user.password!
    }
    
    
    ///
    ///Store user class information
    ///
    func storeClass(class_name: String, class_time: String, class_color: String, class_day: String, class_end_date: NSDate?, instructor_ta_info: String, additional_info: String) {
        
        let context = getContext()
        
        //define the entity
        let entity = NSEntityDescription.entity(forEntityName: "Course", in: context)
        
        let course = NSManagedObject(entity: entity!, insertInto: context) as! Course
        
        course.class_color = class_color
        course.class_time = class_time
        course.class_day = class_day
        course.instructor_ta_info = instructor_ta_info
        course.aditional_info = additional_info
        course.class_end_date = class_end_date
        course.class_name = class_name
    
        course.user = current_user
        
        do{
            try context.save()
            
        }catch{
            print(error)
        }

    }
    
    ///
    ///Store custom notes
    ///
    func storeCustomNotes(custom_notes: String, note_name: String) {
        let context = getContext()
        
        //define the entity
        let entity = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        let notes = NSManagedObject(entity: entity!, insertInto: context) as! CustomNotes
        
        notes.notes_content = custom_notes
        notes.note_name = note_name
        
        notes.user = current_user
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }
    
    ///
    ///Get current classes name
    ///
    func getclasses() -> [String] {
        let context = getContext()
        var classes: [String] = []
        var dataSource: [Course] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Course", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Course])
            for course in dataSource{
                if course.user == current_user{
                    classes.append(course.class_name!)
                }
            }
        }catch{
            print("get_classes_fail!")
        }
        return classes
    }
    
    ///
    ///Get current classes object
    ///
    func getclasses_object(courses: [String]) -> [Course] {
        let context = getContext()
        var classes: [Course] = []
        var dataSource: [Course] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Course", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Course])
            for course in dataSource{
                if course.user! == current_user && courses.contains(course.class_name!){
                    classes.append(course)
                }
            }
        }catch{
            print("get_classes_object_fail!")
        }
        return classes
    }

    ///
    ///Get current assignments object
    ///
    
    func getassignment_object (assignments: [String]) -> [Assignment] {
        let context = getContext()
        var cur_assignments: [Assignment] = []
        var dataSource: [Assignment] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Assignment", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Assignment])
            for assignment in dataSource{
                if assignment.user! == current_user && assignments.contains(assignment.assignment_name!){
                    cur_assignments.append(assignment)
                }
            }
        }catch{
            print("get_assignments_object_fail!")
        }
        return cur_assignments
    }
    
    
    
    ///
    ///Get assignments
    ///
    func getAssignments() -> [String] {
        let context = getContext()
        var assignments: [String] = []
        var dataSource: [Assignment] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Assignment", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Assignment])
            for assignment in dataSource{
                if assignment.user == current_user{
                    assignments.append(assignment.assignment_name!)
                }
            }
        }catch{
            print("get_assignments_fail!")
        }
        return assignments
    }

    ///
    ///Get custom notes
    ///
    func getCustomNotes() -> [CustomNotes] {
        let context = getContext()
        var notes: [CustomNotes] = []
        var dataSource: [CustomNotes] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [CustomNotes])
            for note in dataSource{
                if note.user! == current_user{
                    notes.append(note)
                }
            }
        }catch{
            print("get_notes_fail!")
        }
        return notes
    }
    
    ///
    ///Get custom notes
    ///
    func getNotes(cur_notes: [String]) -> [CustomNotes] {
        let context = getContext()
        var notes: [CustomNotes] = []
        var dataSource: [CustomNotes] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [CustomNotes])
            for note in dataSource{
                if note.user! == current_user && cur_notes.contains(note.note_name!){
                    notes.append(note)
                }
            }
        }catch{
            print("get_notes_fail!")
        }
        return notes
    }
    
    ///
    ///Get custom notes
    ///
    func getCustomNotesName() -> [String] {
        let context = getContext()
        var notes: [String] = []
        var dataSource: [CustomNotes] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [CustomNotes])
            for note in dataSource{
                if note.user == current_user{
                    notes.append(note.note_name!)
                }
            }
        }catch{
            print("get_notes_fail!")
        }
        return notes
    }
    
    ///
    ///Store Assignment
    ///
    func storeAssignment(assignment_name: String, due_date: NSDate, advanced_notice_hours: Double, class_name: String, location: String, color: String, additional_info: String, priority: Int16) {
        let context = getContext()
        
        //define the entity
        let entity = NSEntityDescription.entity(forEntityName: "Assignment", in: context)
        
        let assignment = NSManagedObject(entity: entity!, insertInto: context) as! Assignment
        
        assignment.additional_info = additional_info
        assignment.assignment_name = assignment_name
        assignment.class_name = class_name
        assignment.due_date = due_date
        assignment.priority = priority
        assignment.remind_time = advanced_notice_hours
        assignment.color = color
        assignment.location = location
        
        assignment.user = current_user
        
        do{
            try context.save()
        }catch{
            print(error)
        }
    }

    ///
    ///Modify custom notes
    ///
    func modify_custom_note(note_name: String, note_content: String) {
        let context = getContext()
        var dataSource: [CustomNotes] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [CustomNotes])
            for note in dataSource{
                if note.user == current_user && note.note_name == note_name{
                    note.setValue(note_content, forKey: "notes_content")
                    print("Note Coentent:" + note.notes_content!)
                    try context.save()
                }
            }
        }catch{
            print("get_note_fail!")
        }
    }
    
    ///
    ///Modify course
    ///
    func modify_class(class_name: String, class_time: String, class_color: String, class_day: String, class_end_date: NSDate?, instructor_ta_info: String, additional_info: String) {
        let context = getContext()
        var dataSource: [Course] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Course", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Course])
            for course in dataSource{
                if course.user == current_user && course.class_name == class_name{
                    course.setValue(class_name, forKey: "class_name")
                    course.setValue(class_time, forKey: "class_time")
                    course.setValue(additional_info, forKey: "aditional_info")
                    course.setValue(class_color, forKey: "class_color")
                    course.setValue(class_day, forKey: "class_day")
                    course.setValue(class_end_date, forKey: "class_end_date")
                    course.setValue(instructor_ta_info, forKey: "instructor_ta_info")
                    try context.save()
                }
            }
        }catch{
            print("get_course_fail!")
        }
    }
    
    ///
    ///Modify Assignment
    ///
    func modify_assignment(assignment_name: String, due_date: NSDate, advanced_notice_hours: Double, class_name: String, location: String, color: String, additional_info: String, priority: Int16) {
        let context = getContext()
        var dataSource: [Assignment] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Assignment", in: context)
        
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [Assignment])
            for assignment in dataSource{
                if assignment.user == current_user && assignment.assignment_name == assignment_name{
                    
                    assignment.additional_info = additional_info
                    assignment.assignment_name = assignment_name
                    assignment.class_name = class_name
                    assignment.due_date = due_date
                    assignment.priority = priority
                    assignment.remind_time = advanced_notice_hours
                    assignment.color = color
                    assignment.location = location
                    
                    try context.save()
                }
            }
        }catch{
            print("get_assignment_fail!")
        }
    }
    
    ///
    ///Change user password
    ///
    func changePassword(email: String, newPassword: String) {
        let context = getContext()
        var dataSource: [InstaPlanUser] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "InstaPlanUser", in: context)
        request.entity = entity
        
        do{
            dataSource = try (context.fetch(request) as! [InstaPlanUser])
            for user in dataSource{
                if user.email_address == email{
                    
                    user.password = newPassword
                    
                    try context.save()
                }
            }
        }catch{
            print("get_password_fail!")
        }
    }
    ///
    ///Delete custom note
    ///
    func deleteNote(note_name: String) {
        let context = getContext()
        var dataSource: [CustomNotes] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "CustomNotes", in: context)
        
        request.entity = entity
        do{
            dataSource = try (context.fetch(request) as! [CustomNotes])
            for note in dataSource{
                if note.user == current_user && note.note_name == note_name{
                    context.delete(note)
                    try context.save()
                }
            }
        }catch{
            print("delete_note_fail!")
        }

    }
    
    ///
    ///Delete class
    ///
    func deleteClass(class_name: String) {
        let context = getContext()
        var dataSource: [Course] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Course", in: context)
        
        request.entity = entity
        do{
            dataSource = try (context.fetch(request) as! [Course])
            for course in dataSource{
                if course.user == current_user && course.class_name == class_name{
                    context.delete(course)
                    try context.save()
                }
            }
        }catch{
            print("delete_course_fail!")
        }
        
    }
    
    ///
    ///Delete Assignment
    ///
    func deleteAssignment(assignment_name: String) {
        let context = getContext()
        var dataSource: [Assignment] = []
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Assignment", in: context)
        
        request.entity = entity
        do{
            dataSource = try (context.fetch(request) as! [Assignment])
            for assignment in dataSource{
                if assignment.user == current_user && assignment.assignment_name == assignment_name{
                    context.delete(assignment)
                    try context.save()
                }
            }
        }catch{
            print("delete_assignment_fail!")
        }
        
    }
}
