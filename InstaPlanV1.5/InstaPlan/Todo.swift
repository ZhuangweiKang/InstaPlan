//
//  Todo.swift
//  InstaPlan
//
//  Created by 康壮伟 on 5/3/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit
var from_todo: Bool = false
class Todo: UITableViewController {

    var todo_assignments: [Assignment] = CoreDataController().getassignment_object(assignments: CoreDataController().getAssignments())
    
    var filteredAssignments: [Assignment] = []

    @IBOutlet weak var sort_seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backfrom = "Todo"
        sort_assignment_with_due_date()
    }

    func filterAssignments(all: [Assignment]) {
        filteredAssignments = []
        for assignment in all{
            if assignment.due_date! as Date > Date() {
                filteredAssignments.append(assignment)
            }
        }
    }
    
    func sort_assignment_with_due_date() {
        filterAssignments(all: todo_assignments)
        for index1 in 0..<filteredAssignments.count{
            for index2 in index1..<filteredAssignments.count{
                if filteredAssignments[index1].due_date! as Date > filteredAssignments[index2].due_date! as Date {
                    let temp = filteredAssignments[index1]
                    filteredAssignments[index1] = filteredAssignments[index2]
                    filteredAssignments[index2] = temp
                }
            }
        }
    }
    
    func sort_assignment_with_priority() {
        filterAssignments(all: todo_assignments)
        for index1 in 0..<filteredAssignments.count{
            for index2 in index1..<filteredAssignments.count{
                if filteredAssignments[index1].priority < filteredAssignments[index2].priority {
                    let temp = filteredAssignments[index1]
                    filteredAssignments[index1] = filteredAssignments[index2]
                    filteredAssignments[index2] = temp
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filteredAssignments.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredAssignments[section].assignment_name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoList", for: indexPath) as! todoAssignments

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let due_date_string = formatter.string(from: filteredAssignments[indexPath.section].due_date! as Date)
        cell.due_date.text = "Due @" + due_date_string
        cell.class_name.text = "Class: " + filteredAssignments[indexPath.section].class_name!
        switch filteredAssignments[indexPath.section].color! {
        case "Red":
            cell.color.backgroundColor = UIColor.red
        case "Orange":
            cell.color.backgroundColor = UIColor.orange
        case "Yellow":
            cell.color.backgroundColor = UIColor.yellow
        case "Green":
            cell.color.backgroundColor = UIColor.green
        case "Blue":
            cell.color.backgroundColor = UIColor.blue
        default:
            cell.color.backgroundColor = UIColor.white
        }
        cell.color.layer.borderWidth = 1
        cell.color.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataController().deleteAssignment(assignment_name: filteredAssignments[indexPath.section].assignment_name!)
            for index in 0..<assignments.count{
                if assignments[index].assignment_name == filteredAssignments[indexPath.section].assignment_name {
                    assignments.remove(at: index)
                    break
                }
            }
            filteredAssignments.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func SortSegAction(_ sender: Any) {
        if sort_seg.selectedSegmentIndex == 0 {
            sort_assignment_with_due_date()
        }
        else{
            sort_assignment_with_priority()
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        from_todo = true
        assignments = filteredAssignments
        search_index = indexPath.section
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
        
        let todayView = storyBoard.instantiateViewController(withIdentifier: "assignmentDetails")
        
        self.present(todayView, animated: true, completion: nil)
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
