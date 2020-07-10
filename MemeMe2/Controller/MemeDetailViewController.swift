//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kbotei on 9/25/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = meme.memedImage
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func editMeme(_ sender: Any) {
        presentMemeCreator(with: meme)
    }
}
