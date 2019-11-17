//
//  LoginViewController.swift
//  FirebaseExercise
//
//  Created by Tengli Li on 11/13/19.
//  Copyright © 2019 Tengli Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func loginRegisterChanged(_ sender: Any) {
        let index = loginRegisterSegmentedControl.selectedSegmentIndex
        let title = loginRegisterSegmentedControl.titleForSegment(at: index)
        loginRegisterButton.setTitle(title, for: .normal)
        if index == 0{
            userNameTextField.isHidden = true
        }
        else{
            userNameTextField.isHidden = false
        }
    }
    
    @IBAction func loginRegister(_ sender: Any) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
        {
            guard let email = emailTextField.text, let password = passwordTextField.text else{
                let alertController = UIAlertController(title: "Oops!", message:
                    "Both email and password cannot be empty!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let alertController = UIAlertController(title: "Oops!", message:
                        error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Done", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                else{
                    self.performSegue(withIdentifier: "loginRegisterSegue", sender: self)
                }
            }

        }
        else{
            guard let email = emailTextField.text, let password = passwordTextField.text, let name = userNameTextField.text else{
                let alertController = UIAlertController(title: "Oops!", message:
                    "Both email and password cannot be empty!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in
                guard let user = authResult?.user, error == nil else {
                    let alertController = UIAlertController(title: "Oops!", message:
                        error!.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Done", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                //successfully authenticated user
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(user.uid)
                let values = ["name": name, "email": email]
                usersReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        let alertController = UIAlertController(title: "Oops!", message:
                            err!.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Done", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }else{
                        self.performSegue(withIdentifier: "loginRegisterSegue", sender: self)
                    }

                    print("Saved user successfully into Firebase.")
                })
            })
        }
        
        
    }
}
