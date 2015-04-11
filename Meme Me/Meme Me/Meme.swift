//
//  Meme.swift
//  Meme Me
//
//  Created by Owen LaRosa on 3/19/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    // structure for storing memes
    var topText = ""
    var bottomText = ""
    var image: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}