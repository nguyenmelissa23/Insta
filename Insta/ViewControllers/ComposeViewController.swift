//
//  ComposeViewController.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/26/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCaptionLabel: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create TapGesture for Image
        postImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
        postImage.addGestureRecognizer(tapGesture)

    }
    
    // Do this when image is tapped
    func didTap(_ sender: UITapGestureRecognizer?) {
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
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        postImage.image = editedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func onCancelPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSharePost(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(postImage.image!)
        let parseImageFile = PFFile(name: "upload_image.png", data: imageData!)
        let newPost = PFObject(className: "Post")
        newPost["caption"] = postCaptionLabel.text
        newPost["image"] = parseImageFile
        newPost["user"] = PFUser.current()
        newPost.saveInBackground { (success, error) in
            if success {
                print("Success:", success)
            } else {
                print(error?.localizedDescription)
            }
        }
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
