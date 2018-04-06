//
//  DetailCategoryTableViewController.swift
//  JustDoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class DetailCategoryViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    var delegate : DetailCategoryViewControllerDelegate?
    var categoryToEdit: Category?
    @IBOutlet weak var labelDateCreation: UILabel!
    @IBOutlet weak var labelDateUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var textCreationDate : String = "Creation Date : "
        var textUpdateDate : String = "Update Date : "
        if let categoryToEdit = categoryToEdit{
            titleTextField.text = categoryToEdit.title
            textCreationDate += (categoryToEdit.dateCreation?.description)!
            textUpdateDate += (categoryToEdit.dateModif?.description)!
//            imageView.image = listToEdit.icon.image
            navigationItem.title = "Edit List"
        }else{
            textCreationDate += Date().description
            textUpdateDate += Date().description
        }
        labelDateUpdate.text = textUpdateDate
        labelDateCreation.text = textCreationDate
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.detailCategoryViewControllerDidCancel(self)
    }
    @IBAction func isDone(_ sender: Any) {
        if let categoryToEdit = categoryToEdit {
            categoryToEdit.title = titleTextField.text!
            delegate?.detailCategoryViewController(self, didFinishEditingItem: categoryToEdit)
        }else{
            var category = Category(context: DataManager.sharedInstance.context)
            category.title = titleTextField.text!
            category.dateCreation = Date()
            category.dateModif = Date()
            delegate?.detailCategoryViewController(self, didFinishAddingItem: category)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleTextField.delegate = self
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
protocol DetailCategoryViewControllerDelegate : class {
    func detailCategoryViewControllerDidCancel(_ controller: DetailCategoryViewController)
    func detailCategoryViewController(_ controller: DetailCategoryViewController, didFinishAddingItem category: Category)
    func detailCategoryViewController(_ controller: DetailCategoryViewController, didFinishEditingItem category: Category)
}
