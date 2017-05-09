//
//  SearchController.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/30/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

var course_selected: Bool = false
var assignment_selected: Bool = false
var note_selected: Bool = false
var search_index = Int()

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
class SearchController: UITableViewController {

    let sections = ["Courses", "Assignment", "Notes"]
    var section_items = [CoreDataController().getclasses(), CoreDataController().getAssignments(), CoreDataController().getCustomNotesName()]
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredSearchContent: [[String]] = [[],[],[]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backfrom = "Search"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSearchContent[section].count
        }
        
        return section_items[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections [section ]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableCell", for: indexPath) as! SearchTableCell

        // Configure the cell...
        var cells: [[String]] = [[]]
        if searchController.isActive && searchController.searchBar.text != "" {
            cells = filteredSearchContent
        }
        else{
            cells = section_items
        }
        courses = CoreDataController().getclasses_object(courses: cells[0])
        assignments = CoreDataController().getassignment_object(assignments: cells[1])
        search_notes = CoreDataController().getNotes(cur_notes: cells[2])
        
        cell.textLabel?.text = cells[indexPath.section][indexPath.row]
        
        return cell
    }
 
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSearchContent = [[],[],[]]
        var i = 0
        for items in section_items{
            for item in items{
                if item.lowercased().contains(searchText.lowercased()) {
                    filteredSearchContent[i].append(item)
                }
            }
            i += 1
        }
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0) {
                CoreDataController().deleteClass(class_name: section_items[indexPath.section][indexPath.row])
            }
            else if (indexPath.section == 1){
                CoreDataController().deleteAssignment(assignment_name: section_items[indexPath.section][indexPath.row])
            }
            else if (indexPath.section == 2){
                CoreDataController().deleteNote(note_name: section_items[indexPath.section][indexPath.row])
            }
            if searchController.isActive && searchController.searchBar.text != ""{
                filteredSearchContent[indexPath.section].remove(at: indexPath.row)
                section_items[indexPath.section].remove(at: indexPath.row)
            }
            else{
                section_items[indexPath.section].remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        search_index = indexPath.row
        if indexPath.section == 0 {
            course_selected = true
            assignment_selected = false
            note_selected = false
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
            
            let todayView = storyBoard.instantiateViewController(withIdentifier: "courseDetails")
            
            self.present(todayView, animated: true, completion: nil)
            
            
        }else if (indexPath.section == 1){
            course_selected = false
            assignment_selected = true
            note_selected = true
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
            
            let todayView = storyBoard.instantiateViewController(withIdentifier: "assignmentDetails")
            
            self.present(todayView, animated: true, completion: nil)
        }else if (indexPath.section == 2){
            course_selected = false
            assignment_selected = false
            note_selected = true
            notefrom = true
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomePage", bundle: nil)
            
            let todayView = storyBoard.instantiateViewController(withIdentifier: "note_detail")
            
            self.present(todayView, animated: true, completion: nil)
        }
        
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
