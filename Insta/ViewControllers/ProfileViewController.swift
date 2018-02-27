//
//  ProfileViewController.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/26/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        profileImage.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    func getUserInfo(){
        let user = PFUser.current()
        let username = user!["username"] as! String
        if  username != "username" {
            self.usernameLabel.text = user!["username"] as? String
        } else {
            self.usernameLabel.text = "Unknown Username"
        }
        if let getParseImg = user!["profilePic"] as? PFFile {
            getParseImg.getDataInBackground{(imageData, error) in
                if (error == nil) {
                    if let imageData = imageData{
                        let img = UIImage(data: imageData)
                        self.profileImage.image = img
                        self.usernameLabel.text = user!["username"] as? String
                    }
                }
            }
        }
    }
    
    func didTap(){
        print("User did tap")
        let  vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Camera is available")
            vc.sourceType = .camera
        } else {
            print("Camera is not available. Use photo library")
            vc.sourceType = .photoLibrary
        }
        //Show ImagePicker either library or camera
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImage.image = editedImage
        let imageData = UIImagePNGRepresentation(editedImage)
        let parseImageFile = PFFile(name: "upload_image.png", data: imageData!)
        let currentuser = PFUser.current()
        currentuser!["profilePic"] = parseImageFile
        currentuser?.saveInBackground(block: { (success, error: Error?) in
            if error == nil {
                print(success)
            } else {
                print(error?.localizedDescription)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
