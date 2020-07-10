//
//  Meme.swift
//  MemeMe
//
//  Created by Fabio Italiano on 6/25/20.
//  Copyright © 2020 Leptocode. All rights reserved.
//

import Foundation
import UIKit

struct Meme: Equatable {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    static func == (lhs: Meme, rhs: Meme) -> Bool {
        return lhs.topText == rhs.topText && lhs.bottomText == rhs.bottomText && lhs.originalImage.cgImage == rhs.originalImage.cgImage
    }
}

