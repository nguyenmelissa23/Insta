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
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 500
        tableView.rowHeight = 500
        getPosts()
        self.tableView.reloadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        print("Segue:")
        if let indexPath = tableView.indexPath(for: cell){
        let post = self.posts[indexPath.row]
        let navVC = segue.destination as! UINavigationController
        let detailViewController = navVC.topViewController as! PostDetailViewController
        detailViewController.post = [post]
        print("VC", detailViewController)
        print("send POST:", detailViewController.post)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.posts.isEmpty {
            return 0
        } else {
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        print("POST:", post)
//        print("post createdat", post["_created_at"])
//        Get image data and set that to imageView
        let getParseImg = post["image"] as! PFFile
        getParseImg.getDataInBackground{(imageData, error) in
            if (error == nil) {
                if let imageData = imageData{
                    let img = UIImage(data: imageData)
                    cell.postImage.image = img
                    
                    cell.imageCaptureLabel.text = post["caption"] as? String
                    let user = post["user"] as? PFUser
                    let username = "\(user!["username"]!)"
                    if username != "username"{
                        cell.usernameLabel.text = "\(user!["username"]!)"
                    } else {
                        cell.usernameLabel.text = "Unknown User"
                    }
                    
                }
            }
        }
        return cell
    }

    
    func getPosts() {
        let query = PFQuery(className: "Post")
        query.includeKey("user")
        query.includeKey("createAt")
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
    
   
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        let query = PFQuery(className: "Post")
        query.includeKey("user")
        query.includeKey("createAt")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts: [PFObject]? , error: Error?) in
            if error == nil {
//                print(posts!)
                if let posts = posts {
                    self.posts = posts
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        }
        
    }
    
    //Deselect row after it's selected to see post details
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
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
