//
//  CategoryTableViewController.swift
//  Saxjax Colorfull ToDoList

//  Created by Jakob Skov Søndergård on 19/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

  var categories = [ToDoCategory]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let defaultColorHexString = "#4ba38aff"
  var showFilteredItems = true


  //  MARK: -IBActions
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()

    let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
    alert.addTextField{ alertTextField in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }

    let action = UIAlertAction(title: "Add category", style: .default) { action in

      let newCategory = ToDoCategory(context: self.context)
      newCategory.name = textField.text!
      newCategory.isChecked = false
      newCategory.color = MakeColor.randomHex()
      self.categories.append(newCategory)

      self.saveItems()
      //      self.fetchSorted(searchText: self.searchBar.searchTextField.text)
      self.tableView.reloadData()
    }

    alert.addAction(action)

    present(alert, animated: true,completion: nil)
  }

  @IBAction func AllItemsButtonPressed(_ sender: UIBarButtonItem) {

    showFilteredItems = false
    performSegue(withIdentifier: Constants.segues.toDoItems, sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchItems()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return categories.count
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category = categories[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellNames.catagoryCell, for: indexPath)
    if let color = MakeColor.color(from: category.color) , let contrast = MakeColor.contrastingColor(from: category.color){

      cell.backgroundColor = color
      cell.tintColor = contrast
      cell.textLabel?.tintColor = contrast
      cell.textLabel?.textColor = contrast

      //      colorNavigationBar(backgroundcolor: color, contrastColor: contrast)
    }

    cell.textLabel?.text = category.name
    cell.accessoryType = category.isChecked ? .checkmark : .none
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    performSegue(withIdentifier: Constants.segues.toDoItems, sender: self)

    tableView.deselectRow(at: indexPath, animated: true)
  }
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! ToDoListViewController

    if showFilteredItems{
      if let indexPath = tableView.indexPathForSelectedRow {
        let category = categories[indexPath.row]
        destinationVC.selectedCategory = category
      }
    } else {
      if let color = MakeColor.color(from: defaultColorHexString), let contrast = MakeColor.contrastingColor(from: defaultColorHexString){

        colorNavigationBar(backgroundcolor: color, contrastColor: contrast)

      }
      destinationVC.showFilteredResults = showFilteredItems
      destinationVC.selectedCategory = nil
      
      showFilteredItems = true
    }



  }

  //MARK: -Enable Swipes

  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, boolvalue in
      self.delete(at: indexPath)
    }

    let swipeActions = UISwipeActionsConfiguration(actions: [delete])

    return swipeActions
  }

  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = UIContextualAction(style: .normal, title: "Edit") { _, view, boolValue in
      var textField = UITextField()

      let alert = UIAlertController(title: "Edit category", message: "", preferredStyle: .alert)
      alert.addTextField{ alertTextField in
        alertTextField.placeholder = self.categories[indexPath.row].name
        textField = alertTextField
      }

      let saveAction = UIAlertAction(title: "Save", style: .default) { action in

        let newCategory = self.categories[indexPath.row]
        newCategory.name = textField.text!
        newCategory.isChecked = false

        self.saveItems()
        self.tableView.reloadData()
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

      alert.addAction(cancelAction)
      alert.addAction(saveAction)


      self.present(alert, animated: true,completion: nil)
    }

    let changeColor = UIContextualAction(style: .normal, title: "New color") { _, view, boolValue in
      let newCategory = self.categories[indexPath.row]
      newCategory.color = MakeColor.randomHex()

      self.saveItems()
      self.tableView.reloadData()
    }
    changeColor.backgroundColor = UIColor.systemGreen


    let swipeActions = UISwipeActionsConfiguration(actions: [edit, changeColor])

    return swipeActions
  }


  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */




  //MARK: -Custom CRUD functions

  func saveItems(){
    do{
      try context.save()
    }catch{
      print("Error saving context:\(error)")
    }

    tableView.reloadData()

  }

  func update(){
    context.refreshAllObjects()
    tableView.reloadData()

  }

  func fetchItems(with request:NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest() ){

    do{
      categories =  try context.fetch(request)
    }catch{
      print("Error fetching data from CoreData: \(error)")
    }
    tableView.reloadData()
  }


  func delete(at indexPath:IndexPath){
    context.delete(categories[indexPath.row])
    categories.remove(at: indexPath.row)
    saveItems()
  }

  //MARK: -Custom popups



  //MARK: -Coloring
  private func colorNavigationBar(backgroundcolor color:UIColor,  contrastColor contrast:UIColor){

    guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exist on ToDoListViewController yet")}

    navBar.backgroundColor = color
    navBar.tintColor = contrast
    navBar.barTintColor = contrast
    navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: contrast]
  }

}



