//
//  ViewController.swift
//  JustDoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemsFiltered = [Item]()
    
    var category : Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createItem()
        navigationItem.title = category.title
        try? DataManager.sharedInstance.loadData()
        
        itemsFiltered = category.items?.allObjects as! [Item]
        searchBar.placeholder = "Search Item"
        
    }
//    func createItem(){
//        for item in items{
//            items2.append(Item(text: item))
//        }
//    }

    @IBAction func addAction(_ sender: Any) {
        let alertController =  UIAlertController(title: "Doit", message: "New item", preferredStyle: .alert)
        
        alertController.addTextField{ (textField) in
            textField.placeholder = "Name"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default){ (action) in
           // let item = Item(text: alertController.textFields![0].text!)
            let item = Item(context: DataManager.sharedInstance.context)
            item.text = alertController.textFields![0].text!
            item.checked = false
            self.category.addToItems(item)
            DataManager.sharedInstance.saveCategory(category: self.category)
            DataManager.sharedInstance.saveData()
            self.resetSearchBar()
            self.tableView.reloadData()
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
//        let editButton = sender as! UIBarButtonItem
//        editButton.se
        tableView.isEditing = !tableView.isEditing
    }
    
    func resetSearchBar(){
        searchBar.text = ""
        itemsFiltered = category.items?.allObjects as! [Item]
    }
}

extension ListViewController : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFiltered.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath)
        let item = itemsFiltered[indexPath.row]
        cell.textLabel?.text = item.text
        cell.accessoryType = (item.checked) ? .checkmark : .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let sourceItem = DataManager.sharedInstance.cachedItems.remove(at: sourceIndexPath.row)
//
//        DataManager.sharedInstance.cachedItems.insert(sourceItem, at: destinationIndexPath.row)
//        DataManager.sharedInstance.saveData()
//    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return searchBarIsEmpty()
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = (itemsFiltered[indexPath.row].checked) ? .none : .checkmark
        itemsFiltered[indexPath.row].checked = !itemsFiltered[indexPath.row].checked
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return DataManager.sharedInstance.cachedItems.count > 1
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let itemIndex = (category.items?.allObjects as! [Item]).index(where:{ $0 === self.itemsFiltered[indexPath.item]})!

        category.removeFromItems(category.items?.allObjects[itemIndex] as! Item)
      //  DataManager.sharedInstance.delete(item: DataManager.sharedInstance.cachedItems[itemIndex])
        self.itemsFiltered.remove(at: itemIndex)
//        (category.items as! [Item]).remove(at: itemIndex)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: UISearchResultsUpdating
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty() {
            self.itemsFiltered = (category.items?.allObjects as! [Item])
        }else{
            self.itemsFiltered = DataManager.sharedInstance.filter(searchText: searchText, category: category)
        }
        tableView.reloadData()
    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
}

