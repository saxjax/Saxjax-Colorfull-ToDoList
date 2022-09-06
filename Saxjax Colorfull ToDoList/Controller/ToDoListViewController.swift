//
//  ToDoListViewController.swift
//  Saxjax Colorfull ToDoList
//
//  Created by Jakob Skov Søndergård on 19/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {


  //  let defaults = UserDefaults()
  var itemArray = [Item]()

  var selectedCategory: ToDoCategory? {
    didSet {
      fetchItems()
    }
  }

  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var isAscending = true
  let initialDateSorted = NSSortDescriptor(key: Constants.fieldName.ToDoItemCreatedDate, ascending: true)
  let colorChangeAmount = 10
  var defaultColorHexString = "#4ba38aff"
  var showFilteredResults = true

  //  MARK: -IBOutlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
  @IBOutlet weak var navBar: UINavigationItem!
  

  //MARK: -IBActions

  @IBAction func AddNewItem(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)

    alert.addTextField{ alertTextField in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }


    let action = UIAlertAction(title: "Add item", style: .default) { action in

      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.isChecked = false
      newItem.parentCategory = self.selectedCategory
      newItem.createdDate = Date()
      self.itemArray.append(newItem)

      self.saveItems()
      let req = Item.fetchRequest()
      req.sortDescriptors =  [self.initialDateSorted]
      self.fetchItems(with:req)
      //      self.fetchSorted(searchText: self.searchBar.searchTextField.text)
      self.tableView.reloadData()
    }

    alert.addAction(action)

    present(alert, animated: true,completion: nil)
  }

  @IBAction func sort(_ sender: UIBarButtonItem) {
    isAscending.toggle()
    sortButtonOutlet.image = isAscending ? UIImage(systemName: "arrow.down") : UIImage(systemName: "arrow.up")
    fetchSorted(searchText: searchBar?.searchTextField.text)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    //I have ctrl dragged from searchBar to ViewController and selected delegate
    //    searchBar.delegate = self

    //    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    let req = Item.fetchRequest()
    req.sortDescriptors = [initialDateSorted]
    fetchItems(with: req)
    navBar.title = showFilteredResults ? "\(selectedCategory?.name ?? "") items" : "All items"

  }

  override func viewWillAppear(_ animated: Bool) {
    if let color = MakeColor.color(from: selectedCategory?.color ?? defaultColorHexString) , let contrast = MakeColor.contrastingColor(from: selectedCategory?.color){

      guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exist on ToDoListViewController yet")}

      navBar.backgroundColor = color
      navBar.tintColor = contrast
      navBar.barTintColor = contrast
      navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: contrast]
    }
  }


  //  MARK: -TableView methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = itemArray[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellNames.ToDoItemCell, for: indexPath)

    cell.textLabel?.text = item.title
    cell.accessoryType = item.isChecked ? .checkmark :  .none

    if let color = MakeColor.color(from: selectedCategory?.color ?? defaultColorHexString) {
      //TODO: theese colors are problematic in regards to contrast color, the ap believes they are dark blue not yellow
      //     if let color = MakeColor.color(from: "#df0f68ff") {
      //      if let color = MakeColor.color(from: "#dd0168ff") {


      let cellColor = MakeColor.closeColor(from: color, steps: indexPath.row * colorChangeAmount)
      let contrast = MakeColor.contrastingColor(from: cellColor)

      cell.backgroundColor = cellColor
      cell.tintColor = contrast
      cell.textLabel?.tintColor = contrast
      cell.textLabel?.textColor = contrast
      ////      TODO: remove this after debugging
      //      cell.textLabel?.text! += "  \(MakeColor.UIColorToHexString(from: cellColor) ?? "none")"
    }

    return cell
  }

  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let selectedItem = itemArray[indexPath.row]
    selectedItem.isChecked.toggle()
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)

  }


//  MARK: Swipe actions
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, boolvalue in
      self.deleteItem(at: indexPath)
    }

    let edit = UIContextualAction(style: .normal, title: "Edit") { _, view, boolValue in
      var textField = UITextField()


      let alert = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
      alert.addTextField{ alertTextField in
        alertTextField.text = self.itemArray[indexPath.row].title
        textField = alertTextField
      }

      let saveAction = UIAlertAction(title: "Save", style: .default) { action in

        let newItem = self.itemArray[indexPath.row]
        newItem.title = textField.text!
        newItem.isChecked = false

        self.saveItems()
        self.tableView.reloadData()
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

      alert.addAction(cancelAction)
      alert.addAction(saveAction)


      self.present(alert, animated: true,completion: nil)
    }

    let swipeActions = UISwipeActionsConfiguration(actions: [delete,edit])

    return swipeActions


  }

  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = UIContextualAction(style: .normal, title: "Edit") { _, view, boolValue in
      var textField = UITextField()


      let alert = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
      alert.addTextField{ alertTextField in
        alertTextField.text = self.itemArray[indexPath.row].title
        textField = alertTextField
      }

      let saveAction = UIAlertAction(title: "Save", style: .default) { action in

        let newItem = self.itemArray[indexPath.row]
        newItem.title = textField.text!
        newItem.isChecked = false

        self.saveItems()
        self.tableView.reloadData()
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

      alert.addAction(cancelAction)
      alert.addAction(saveAction)


      self.present(alert, animated: true,completion: nil)
    }

    let swipeActions = UISwipeActionsConfiguration(actions: [edit])

    return swipeActions
  }

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

  func fetchItems(with request:NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil){

    if showFilteredResults{
      let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

      if let aditionalPredicate = predicate {
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,aditionalPredicate])
      }
      else {
        request.predicate = categoryPredicate
      }
    }

    do{
      itemArray =  try context.fetch(request)
    }catch{
      print("Error fetching data from CoreData: \(error)")
    }

    tableView.reloadData()
  }

  func deleteItem(at indexPath:IndexPath){
    let item = itemArray[indexPath.row]
    context.delete(item)
    itemArray.remove(at: indexPath.row)
    saveItems()
  }

}



//MARK: -SearchBar delegate methods
extension ToDoListViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let searchText = searchBar.text, searchText.isEmpty == false {
      fetchSorted(searchText: searchText)
    }

    resignSearchField()
  }


  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty  {
      fetchItems()

      resignSearchField()
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    fetchItems()
    resignSearchField()
  }


  //  MARK: -Custom Search functions
  func fetchSorted(searchText:String? = nil){

    let req:NSFetchRequest<Item> = Item.fetchRequest()

    if let text = searchText, text.isEmpty == false{
      req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
    }

    req.sortDescriptors = [NSSortDescriptor(key: Constants.fieldName.ToDoItemTitle, ascending: isAscending)]

    fetchItems(with: req, predicate: req.predicate)
    resignSearchField()
  }

  private func resignSearchField(){
    DispatchQueue.main.async {
      self.searchBar.resignFirstResponder()
    }
  }


}

