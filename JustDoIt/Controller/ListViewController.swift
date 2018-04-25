//
//  ViewController.swift
//  JustDoIt@
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ItemCell
        let item = itemsFiltered[indexPath.row]
        cell.nameLabel.text = item.text
        cell.checkLabel.isHidden = (item.checked) ? false : true
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
        
        let cell = tableView.cellForRow(at: indexPath) as! ItemCell
        let item = itemsFiltered[indexPath.row]
        item.checked = !item.checked
        cell.checkLabel.isHidden = !cell.checkLabel.isHidden

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return DataManager.sharedInstance.cachedItems.count > 1
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let itemIndex = (category.items?.allObjects as! [Item]).index(where:{ $0 === self.itemsFiltered[indexPath.item]})!
        
        self.itemsFiltered.remove(at: indexPath.item)
        
        let tempItem = category.items?.allObjects[itemIndex] as! Item;
        DataManager.sharedInstance.delete(object: tempItem)
        
        DataManager.sharedInstance.saveCategory(category: self.category)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "addItem"
        {
            let destination = segue.destination as! UINavigationController
            let targetController = destination.topViewController as! DetailItemViewController
            targetController.delegate = self
            
        }
        
        if segue.identifier == "editItem"
        {
            let destination = segue.destination as! UINavigationController
            let targetController = destination.topViewController as! DetailItemViewController
            //TODO: Envoyer l'item a la case cliqué
            let index = tableView.indexPath(for: sender as! UITableViewCell)!
            targetController.itemToEdit = itemsFiltered[index.item]
            targetController.delegate = self
            
        }
    }
    
//
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
}

extension ListViewController: DetailItemViewControllerDelegate {
    
    func detailItemViewControllerDidCancel(_ controller: DetailItemViewController){
        controller.dismiss(animated: true)
    }
    func detailItemViewController(_ controller: DetailItemViewController, didFinishAddingItem item: Item){
        category.addToItems(item)
        DataManager.sharedInstance.saveCategory(category: category)
        self.resetSearchBar()
        tableView.reloadData()
        //        let indexPath : IndexPath = IndexPath(row: checkLists.count-1, section: 0)
        //        tableView.insertRows(at: [indexPath], with: .automatic)
        controller.dismiss(animated: true)
        
    }
    
    func detailItemViewController(_ controller: DetailItemViewController, didFinishEditingItem item: Item){
        DataManager.sharedInstance.saveCategory(category: category, item: item)
        tableView.reloadData()
        //        tableView.reloadRows(at: [IndexPath(row: listIndex, section: 0)], with: .automatic)
        controller.dismiss(animated: true)
    }
    
}

