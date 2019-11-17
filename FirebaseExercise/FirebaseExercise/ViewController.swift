//
//  ViewController.swift
//  FirebaseExercise
//
//  Created by Tengli Li on 11/12/19.
//  Copyright © 2019 Tengli Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    var photoURL: URL?
    var userUid: String?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailAddres: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = 20
        if Auth.auth().currentUser?.uid == nil{
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "signoutSegue", sender: self)
            }
        }
        else{
            let uid = Auth.auth().currentUser?.uid
            userUid = uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    print(snapshot)
                    self.userName.text = dictionary["name"] as? String
                    self.emailAddres.text = dictionary["email"] as? String
                    if let profileImageUrl = dictionary["imageURL"]{
                        let url = NSURL(string: profileImageUrl as! String)
                        let request = URLRequest(url: url! as URL)
                        URLSession.shared.dataTask(with: request) { (data, response, error) in
                            if error !=  nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.photoImage.image = UIImage(data: data!)
                            }
                            }.resume()

                    }
                    else{
                        self.photoImage.image = UIImage(named: "default")!
                    }
                    
                    self.userUid = uid
//                    let storageRef = Storage.storage().reference().child("\(String(describing: uid!)).png")
//                    storageRef.downloadURL(completion: {url, error in
//                        if let error = error {
//                            print(error)
//                        } else {
//                            let data = try? Data(contentsOf: url!)
//                            self.photoImage.image = UIImage(data:data!)
//                        }
//                    })
                }
            }, withCancel: nil)
        }
        
        
    }
    @IBAction func signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.performSegue(withIdentifier: "signoutSegue", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selected : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selected = editedImage as? UIImage
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selected = originalImage as? UIImage
        }
        
        
        if let selectedImage = selected {
            photoImage.image = selectedImage
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = self.photoImage.image?.jpegData(compressionQuality: 0.75){
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": self.userName.text, "email": self.emailAddres.text, "imageURL": profileImageUrl]
                            Database.database().reference(fromURL:"https://fir-exercise-ecdde.firebaseio.com/").child("users").child(self.userUid!).updateChildValues(values)
                        }
                    })
                    
                    
                })
            }
//            let storageRef = Storage.storage().reference().child("\(String(describing: userUid!)).png")
//
//            if let uploadData = (self.photoImage.image!).pngData(){
//                storageRef.putData(uploadData, metadata: nil, completion: { (metadata,error) in
//                    if error != nil {
//                        print(error)
//                        return
//                    }
//                })
//            }
//
//            storageRef.downloadURL(completion: {url, error in
//                if let error = error {
//                    print(error)
//                } else {
//                    let imageURL = url?.absoluteString
//                    let databaseRef = Database.database().reference().child("users").child(self.userUid!)
//                    let values = ["name": self.userName.text, "email": self.emailAddres.text, "imageURL": imageURL]
//                    databaseRef.updateChildValues(values as [AnyHashable : Any])
//                }
//            })
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    
}

