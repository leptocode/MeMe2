//
//  MemeScreenViewController.swift
//  MemeMe
//
//  Created by Kbotei on 8/21/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class MemeScreenViewController: UIViewController {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var meme: Meme?
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes:[String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
            NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
            NSAttributedString.Key.strokeWidth.rawValue: -4.0
        ]
        
        //Moved text field setup into an extension method
        topTextField.setupTextField(text: "WRITE HERE", delegate: self, attributes: memeTextAttributes)
        bottomTextField.setupTextField(text: "WRITE HERE", delegate: self, attributes: memeTextAttributes)
        
        shareButton.isEnabled = false
        
        if let meme = self.meme {
            imageView.image = meme.originalImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            shareButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        guard imageView.image != nil else {
            let alert = UIAlertController(title: "Missing Image", message: "Please Select an Image", preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        memedImage = generateMemedImage()
        
        let completionHandler: (UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void = { (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        shareSheet(for: memedImage, completionHandler: completionHandler)
    }
    
    
    @IBAction func selectCamera(_ sender: Any) {
        
        // Create action sheet
        let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source", preferredStyle: .actionSheet)
        
        // Only add the camera when available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // Add Camera button
            let cameraAlbumButton = UIAlertAction(title: "Camera", style: .default) {(ation) in
                // Display the UIImagePickerController set to camera mode
                self.imagePicker(source: .camera)
            }
            actionSheet.addAction(cameraAlbumButton)
        }
        
        // Only add the album when available
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let albumButton = UIAlertAction(title: "Album", style: .default) {(ation) in
                // Display the UIImagePickerController set to album mode
                self.imagePicker(source: .photoLibrary)
            }
            actionSheet.addAction(albumButton)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelButton)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        
        imageView.image = nil
        topTextField.text = "WRITE HERE"
        bottomTextField.text = "WRITE HERE"
        shareButton.isEnabled = false
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    // Manage the Keyboard ********************************* START
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Manage the Keyboard ********************************* END
    
    
    
    func imagePicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text ?? "", bottomText: bottomTextField.text ?? "", originalImage: imageView.image!, memedImage: memedImage)
        
        // Only save meme if it was changed.
        if meme != self.meme {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)
        }
    }
}

private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension MemeScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        view.backgroundColor = .black
        toolBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        
        return memedImage
    }
}

extension MemeScreenViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "WRITE HERE" || textField.text == "WRITE HERE" {
            textField.text = ""
        }
    }
    
    // Dismiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension UITextField {
    func setupTextField(text: String, delegate: UITextFieldDelegate, attributes: [String : Any]) {
        self.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(attributes)
        self.text = text
        self.textAlignment = .center
        self.delegate = delegate
    }
}
