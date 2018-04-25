//
//  DetailItemViewController.swift
//  JustDoIt
//
//  Created by lpiem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class DetailItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    var delegate : DetailItemViewControllerDelegate?
    var itemToEdit: Item?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemToEdit = itemToEdit{
            textField.text = itemToEdit.text
            //            imageView.image = listToEdit.icon.image
            navigationItem.title = "Edit List"
            if(itemToEdit.image != nil){
                imageView.image = UIImage(data:(itemToEdit.image?.data)!,scale:1.0)
            }
            
        }
    }
    
    @IBAction func browseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for:.photoLibrary)!
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.detailItemViewControllerDidCancel(self)
    }
 
    
    @IBAction func isDone(_ sender: Any) {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.detailItemViewController(self, didFinishEditingItem: itemToEdit)
        }else{
            var item = Item(context: DataManager.sharedInstance.context)
            item.text = textField.text!
            delegate?.detailItemViewController(self, didFinishAddingItem: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
       //TODO navigationItem.rightBarButtonItem?.isEnabled = false
        textField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            // ...
            if(newString.count==0){
                navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        }
        return true
        // ...
    }
}
protocol DetailItemViewControllerDelegate : class {
    func detailItemViewControllerDidCancel(_ controller: DetailItemViewController)
    func detailItemViewController(_ controller: DetailItemViewController, didFinishAddingItem item: Item)
    func detailItemViewController(_ controller: DetailItemViewController, didFinishEditingItem item: Item)
}

extension DetailItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        imageView.image = image
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}

