//
//  PostDetailViewController.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {

    var post: [PFObject] = []
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let post = self.post[0]
        print("post in detail", self.post[0])
        print("post updated at", post.createdAt as? Date)
        if post != nil {
            print("post detail:", post)
            let getParseImg = post["image"] as! PFFile
            getParseImg.getDataInBackground{(imageData, error) in
                if (error == nil) {
                    if let imageData = imageData{
                        let img = UIImage(data: imageData)
                        
                        self.postImage.image = img
                        self.captionLabel.text = post["caption"] as? String
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM.dd.yyyy"
                        let timestamp = post.createdAt
                        let dateString = formatter.string(from: timestamp!)
            
                        self.timestampLabel.text = dateString
                        let user = post["user"] as? PFUser
                        let username = "\(user!["username"]!)"
                        if username != "username"{
                            self.usernameLabel.text = "\(user!["username"]!)"
                        } else {
                            self.usernameLabel.text = "Unknown User"
                        }
                        
                    }
                }
            }
        }
       
        // Do any additional setup after loading the view.
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
