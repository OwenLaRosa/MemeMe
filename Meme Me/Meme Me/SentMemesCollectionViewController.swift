//
//  SentMemesCollectionViewController.swift
//  Meme Me
//
//  Created by Owen LaRosa on 4/6/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload data to reflect recently added memes
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cellSpacing = CGFloat(4)
        let cellsPerRow = CGFloat(3)
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        
        let sideLength = floor((collectionView.frame.size.width - cellSpacing * (cellsPerRow + 1)) / cellsPerRow)
        layout.itemSize = CGSize(width: sideLength, height: sideLength)
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.appDelegate.memes[indexPath.row]
        
        // set the image
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // show the meme in the detail view controller
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memedImage = appDelegate.memes[indexPath.row].memedImage
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}
