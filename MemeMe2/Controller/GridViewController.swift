//
//  GridViewController.swift
//  MemeMe
//
//  Created by Fabio Italiano on 7/9/20.
//  Copyright © 2020 Leptocode. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    @IBAction func addMeme(_ sender: Any) {
        presentMemeCreator()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushCollectionToDetail",
            let meme = sender as? Meme,
            let controller = segue.destination as? MemeDetailViewController {
            controller.meme = meme
        }
    }
}

// MARK: - Delegates

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if memes.count > indexPath.row {
            performSegue(withIdentifier: "pushCollectionToDetail", sender: memes[indexPath.row])
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionCell
        
        if memes.count > indexPath.row {
            let meme = memes[indexPath.row]
            cell.imageView.image = meme.memedImage
        }
        
        return cell
    }
}

class MemeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
