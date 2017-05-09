//
//  AssignmentContent.swift
//  InstaPlan
//
//  Created by 康壮伟 on 5/6/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

class AssignmentContent: UITableViewController {

    
     let assignments = CoreDataController().getassignment_object(assignments: CoreDataController().getAssignments())
     var today_assignment: [Assignment] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterAssignment(all_assignments: assignments)
    }

    
    
     func filterAssignment(all_assignments: [Assignment]) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for assignment in all_assignments{
            let due_time = assignment.due_date
            let due_date = formatter.string(from: due_time! as Date)
            let today = formatter.string(from: Date())
            if due_date == today {
                today_assignment.append(assignment)
            }
        }
     }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if today_assignment.count == 0{
            return 1
        }
        else{
            return today_assignment.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignment_content", for: indexPath)

        if today_assignment.count == 0 {
            cell.textLabel?.text = "You don't have any assignment today."
        }
        else{
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            cell.textLabel?.text = "Due @" + formatter.string(from: today_assignment[indexPath.section].due_date! as Date)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if today_assignment.count == 0 {
            return "No assignment!"
        }
        return today_assignment[section].assignment_name
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
