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
    @IBOutlet weak var labelDateCreation: UILabel!
    @IBOutlet weak var labelDateUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var textCreationDate : String = "Created at : "
        var textUpdateDate : String = "Updated at : "
         navigationItem.rightBarButtonItem?.isEnabled = false
        if let itemToEdit = itemToEdit{
            textField.text = itemToEdit.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            
            textCreationDate += dateFormatter.string(from: itemToEdit.dateCreation!)
            textUpdateDate += dateFormatter.string(from: itemToEdit.dateModif!)
            //            imageView.image = listToEdit.icon.image
            navigationItem.title = "Edit List"
            if(itemToEdit.image != nil){
                imageView.image = UIImage(data:(itemToEdit.image?.data)!)
            }
            
        }else{
            textCreationDate += Date().description
            textUpdateDate += Date().description
        }
        labelDateUpdate.text = textUpdateDate
        labelDateCreation.text = textCreationDate
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
             if(imageView.image != nil){
                var imagetest = Image(context: DataManager.sharedInstance.context)
                imagetest.data = UIImagePNGRepresentation(imageView.image!) as Data?
                itemToEdit.image = imagetest
            }
            delegate?.detailItemViewController(self, didFinishEditingItem: itemToEdit)
        }else{
            var item = Item(context: DataManager.sharedInstance.context)
            item.text = textField.text!
            if(imageView.image != nil){
                var imagetest = Image(context: DataManager.sharedInstance.context)
                imagetest.data = UIImagePNGRepresentation(imageView.image!) as Data?
                item.image = imagetest
            }
            
            item.dateCreation = Date()
            item.dateModif = Date()
            delegate?.detailItemViewController(self, didFinishAddingItem: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
       
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
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        imageView.image = image
        navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}

