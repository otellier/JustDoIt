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
        categories.append(Category(title: "Category 1"))
        categories.append(Category(title: "Category 2"))
        categories.append(Category(title: "Category 3"))

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
        switch (categories[index].items.count, categories[index].uncheckedItemsCount) {
        case (0,_):
            return "(No Item)"+", Last Update : " + categories[index].dateModif.description
        case (_, 0):
            return "All Done!" + ", Last Update : " + categories[index].dateModif.description
        default:
            return String(categories[index].uncheckedItemsCount) + ", Last Update : " + categories[index].dateModif.description
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
        categories.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      //  DataManager.sharedInstance.cachedItems = categories
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewList"
        {
            let destination = segue.destination as! ListViewController
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            destination.list = categories[index.row]
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
        //TODO: Sauvegarde CoreData        save()
        tableView.reloadData()
        //        let indexPath : IndexPath = IndexPath(row: checkLists.count-1, section: 0)
        //        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        
    }
    
    func detailCategoryViewController(_ controller: DetailCategoryViewController, didFinishEditingItem category: Category){
        let listIndex = categories.index(where:{ $0 === category })!
        //TODO: Sauvegarde CoreData      save()
        tableView.reloadData()
        //        tableView.reloadRows(at: [IndexPath(row: listIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
}

}
