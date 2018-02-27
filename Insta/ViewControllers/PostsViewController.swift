//
//  PostsViewController.swift
//  Insta
//
//  Created by Melissa Phuong Nguyen on 2/26/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 400
        
        self.getPosts()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.imageCaptureLabel.text = post["capture"] as? String
        cell.usernameLabel.text = post["user"] as? String
        
        let getParseImg = post["image"] as! PFFile
        getParseImg.getDataInBackground { (imageData, error) in
            if (error == nil) {
                if let imageData = imageData{
                    let img = UIImage(data: imageData)
                    cell.imageView?.image = img
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    @objc func getPosts() {
        let query = PFQuery(className: "Post")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts: [PFObject]? , error: Error?) in
            if error == nil {
                print(posts!)
                if let posts = posts {
                    self.posts = posts
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
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
