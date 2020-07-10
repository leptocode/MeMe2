//
//  UIViewController.swift
//  MemeMe
//
//  Created by Fabio Italiano on 7/1/20.
//  Copyright © 2020 Leptocode. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentMemeCreator(with meme: Meme? = nil) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "MemeScreenNav") as! UINavigationController
        
        if let memeViewController = navController.viewControllers.first as? MemeScreenViewController, let meme = meme {
            memeViewController.meme = meme
        }
        
        present(navController, animated: true, completion: nil)
    }
    
    func shareSheet(for memedImage: UIImage, completionHandler: @escaping (UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void) {
        
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = completionHandler
        
        shareSheet.popoverPresentationController?.sourceView = self.view
        present(shareSheet, animated: true, completion: nil)
    }
}
