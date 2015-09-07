//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Owen LaRosa on 4/7/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    // class for displaying selected meme
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memedImage: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = memedImage
    }
}