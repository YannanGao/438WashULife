//
//  MessageViewController.swift
//  FirebaseExercise
//
//  Created by Tengli Li on 11/14/19.
//  Copyright © 2019 Tengli Li. All rights reserved.
//

import UIKit
import Firebase


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var messages:[String]=[]
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var contactsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        }
        else {
            cell.textLabel?.text = messages[indexPath.row]
            return cell
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (messages as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        
        self.contactsTable.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func newMessage(_ sender: Any) {
        self.performSegue(withIdentifier: "newMessageSegue", sender: self)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
