//
//  ViewController.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/26/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    

    @IBAction func onSignup(_ sender: Any) {
        if ((usernameLabel.text?.isEmpty)! && (passwordLabel.text?.isEmpty)!) || (usernameLabel.text?.isEmpty)! || (passwordLabel.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Empty Fields", message: "Please enter your username and/or password" , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        } else {
            let newUser = PFUser()
            newUser.username = usernameLabel.text
            newUser.password = passwordLabel.text
            newUser.signUpInBackground{ (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    let alertMessage = "\(error.localizedDescription)"
                    let alertController = UIAlertController(title: "Sign Up Error", message: alertMessage , preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                    alertController.addAction(cancelAction)
                    let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                } else {
                    print("User Registered successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameLabel.text ?? ""
        let password = passwordLabel.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                let alertMessage = "\(error.localizedDescription)"
                let alertController = UIAlertController(title: "Log In Error", message: alertMessage.capitalized , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

