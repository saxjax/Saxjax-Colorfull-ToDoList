//
//  Constants.swift
//  Todoey
//
//  Created by Jakob Skov Søndergård on 19/08/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct Constants {
  struct segues {
    static let toDoItems = "goToItems"
  }

  struct cellNames {
    static let ToDoItemCell = "toDoItemCell"
    static let catagoryCell = "categoryCell"
  }

  struct fieldName {
    static let ToDoItemTitle = "title"
    static let ToDoItemIsChecked = "isChecked"
    static let ToDoItemCreatedDate = "createdDate"
  }

  struct dataModels {
    static let ToDoItemsDataModel = "DataModel"
  }
  
}
