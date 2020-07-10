//
//  ListViewController.swift
//  MemeMe
//
//  Created by Fabio Italiano on 7/3/20.
//  Copyright © 2020 Leptocode. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addMemeButton(_ sender: Any) {
        presentMemeCreator()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushTableToDetail",
            let meme = sender as? Meme,
            let controller = segue.destination as? MemeDetailViewController {
            controller.meme = meme
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if memes.count > indexPath.row {
            performSegue(withIdentifier: "pushTableToDetail", sender: memes[indexPath.row])
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! MemeTableCell
        
        if memes.count > indexPath.row {
            let meme = memes[indexPath.row]
            cell.memeImage.image = meme.memedImage
            cell.memeText?.text = "\(meme.topText) \(meme.bottomText)"
        }
        
        return cell
    }
}

class MemeTableCell: UITableViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeText: UILabel!
}
