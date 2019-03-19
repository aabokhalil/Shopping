//
//  ShoppingListTableViewController.swift
//  Shopping
//
//  Created by ahmed abokhalil on 7/12/1440 AH.
//  Copyright © 1440 AH Razeware LLC. All rights reserved.
//

import UIKit
import Firebase
class ShoppingListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [ShoppingItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  let shoppingItemsReference = Database.database().reference(withPath: "shopping-items")
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    user = User(uid: "FakeId", email: "hungry@person.food")
    
    
    // print all data in database
    shoppingItemsReference.observe(.value) { (snapshot) in
      print(snapshot)
    }
    
    
    //print specific children data
//    shoppingItemsReference.child("pizza").observe(.value) { (snapshot) in
//      let values = snapshot.value as! [String : Any]
//      let name = values["name"] as! String
//      print("name : \(name)")
//    }
    
    
    // update tableview list with data in database
    shoppingItemsReference.observe(.value) { (snapshot) in
      var newItems : [ShoppingItem] = []
      for item in snapshot.children {
        let shoppingItem = ShoppingItem(snapshot: item as! DataSnapshot)
        newItems.append(shoppingItem)
        
        self.items = newItems
        self.tableView.reloadData()
      }
    }
    
    
    
    
    
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let groceryItem = items[indexPath.row]
    
    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = groceryItem.addedByUser
    
    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  //MARK: - deletevalues
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let shoppingItem = items[indexPath.row]
//      shoppingItem.ref?.removeValue()
      // or
      shoppingItem.ref?.setValue(nil)
      items.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    var shoppingItems = items[indexPath.row]
    let toggledCompletion = !shoppingItems.completed

    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    shoppingItems.completed = toggledCompletion
    
//    let values : [ String : Any ] = ["name" : "Bacon" ]
//    shoppingItems.ref?.updateChildValues(values)
    tableView.reloadData()
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
    }
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Shopping Item",
                                  message: "Add an Item",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
      let textField = alert.textFields![0] 
      let shoppingItem = ShoppingItem(name: textField.text!,
                                    addedByUser: self.user.email,
                                    completed: false)
      self.items.append(shoppingItem)
      self.tableView.reloadData()
      //save to database
      let shoppingItemRef = self.shoppingItemsReference.child(textField.text!.lowercased())
      //saving some values
      let values : [String : Any] = ["name" : textField.text!.lowercased() , "addedByUser" : self.user.email , "completed" : false]
      shoppingItemRef.setValue(values)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
  
}
