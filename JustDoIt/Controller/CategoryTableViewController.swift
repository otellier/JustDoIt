//
//  CategoryTableViewController.swift
//  JustDoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categories = Array<Category>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        categories.append(Category(title: "Category 1"))
//        categories.append(Category(title: "Category 2"))
//        categories.append(Category(title: "Category 3"))
        categories = DataManager.sharedInstance.cachedCategories
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Checklist", for: indexPath)
        cell.textLabel?.text = categories[indexPath.item].title
        cell.detailTextLabel?.text = writeSubtitle(index: indexPath.row)
        return cell
    }
    
    func writeSubtitle(index: Int) -> String {
        //
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let date = dateFormatter.string(from: categories[index].dateModif!)
        
        switch (categories[index].items!.count, categories[index].uncheckedItemsCount) {
        case (0,_):
            return "(No Item)"+" - " + date
        case (_, 0):
            return "All Done!" + " - " + date
        default:
            return String(categories[index].uncheckedItemsCount) + " - " + date
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DataManager.sharedInstance.delete(object: categories[indexPath.row])
        DataManager.sharedInstance.cachedCategories.remove(at: indexPath.row)
        DataManager.sharedInstance.saveData()
        categories = DataManager.sharedInstance.cachedCategories
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewList"
        {
            let destination = segue.destination as! ListViewController
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            destination.category = categories[index.row]
        }
        
        if segue.identifier == "addCategory"
        {
            let destination = segue.destination as! UINavigationController
            let targetController = destination.topViewController as! DetailCategoryViewController
            targetController.delegate = self

        }

        if segue.identifier == "editCategory"
        {
            let destination = segue.destination as! UINavigationController
            let targetController = destination.topViewController as! DetailCategoryViewController
            //TODO: Envoyer l'item a la case cliqué
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            targetController.categoryToEdit = categories[index.row]
            targetController.delegate = self

        }
    }
    

}

extension CategoryTableViewController: DetailCategoryViewControllerDelegate {
    
    func detailCategoryViewControllerDidCancel(_ controller: DetailCategoryViewController){
        controller.dismiss(animated: true)
    }
    func detailCategoryViewController(_ controller: DetailCategoryViewController, didFinishAddingItem category: Category){
        categories.append(category)
        DataManager.sharedInstance.saveData()
        tableView.reloadData()
        //        let indexPath : IndexPath = IndexPath(row: checkLists.count-1, section: 0)
        //        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        
    }
    
    func detailCategoryViewController(_ controller: DetailCategoryViewController, didFinishEditingItem category: Category){
        let listIndex = categories.index(where:{ $0 === category })!
        DataManager.sharedInstance.save(category: category)
        tableView.reloadData()
        //        tableView.reloadRows(at: [IndexPath(row: listIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
}

}
