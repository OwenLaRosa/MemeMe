//
//  SentMemesTableViewController.swift
//  Meme Me
//
//  Created by Owen LaRosa on 4/3/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this is the first view of the app
        // check if the app has launched for the first time and if the memes array is empty
        if appDelegate.didLaunch == false && appDelegate.memes.count == 0 {
            // show the meme editor
            performSegueWithIdentifier("ShowMemeEditor", sender: nil)
            appDelegate.didLaunch == true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // reload data to reflect recently added memes
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.appDelegate.memes[indexPath.row]
        
        // set the image and name
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // show the meme in the detail view controller
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.memedImage = appDelegate.memes[indexPath.row].memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
