//
//  ViewController.swift
//  Todoey
//
//  Created by Michael Hartwell on 6/29/19.
//  Copyright © 2019 Mike Hartwell. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    print(defaultFilePath)
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    
    //give table a length
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //populate table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    //MARK - tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new items 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - model manipulation methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Error encoding item array, /(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("ERROR READING DATA /(error)")
            }
        }
    }
}

