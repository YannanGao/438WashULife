//
//  NewMessageViewController.swift
//  FirebaseExercise
//
//  Created by Tengli Li on 11/16/19.
//  Copyright © 2019 Tengli Li. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactPhoto: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    
    
}

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contacts:[User]=[]

    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //contactsTable.register(UserTableViewCell.self, forCellReuseIdentifier: "theCell")
        contactsTable.dataSource = self
        contactsTable.delegate = self
        // Do any additional setup after loading the view.
        fetchContacts()


    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = contactsTable.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        let cell = contactsTable.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! UserTableViewCell
        cell.contactName.text = contacts[indexPath.row].name
        cell.contactEmail.text = contacts[indexPath.row].email
        cell.contactPhoto.layer.masksToBounds = true
        cell.contactPhoto.layer.cornerRadius = 20
        if let profileImageUrl = contacts[indexPath.row].imageURL{
            print("!!!!!\(profileImageUrl)")
            let url = NSURL(string: profileImageUrl)
            let request = URLRequest(url: url! as URL)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error !=  nil{
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.contactPhoto?.image = UIImage(data: data!)
                }
                }.resume()
            
        }else{
            cell.contactPhoto?.image = UIImage(named: "default")!
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatLogVC = ChatLogViewController(collectionViewLayout: UICollectionViewLayout())
        let chosenUser = contacts[indexPath.row]
        chatLogVC.contactName = chosenUser.name


        navigationController?.pushViewController(chatLogVC, animated: true)
    }
    
    
    func fetchContacts(){
        Database.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.imageURL = dictionary["imageURL"] as? String
                self.contacts.append(user)
                DispatchQueue.main.async {
                    self.contactsTable.reloadData()
                }
            }
            
        }, withCancel: nil)
        

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


