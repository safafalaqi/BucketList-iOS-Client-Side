//
//  ViewController.swift
//  Bucket List
//
//  Created by Safa Falaqi on 12/12/2021.
//

import UIKit

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {
    
    var items = ["Go to moon", "Swim  in the amazon", "Eat a candy bat","Ride a bike in Tokyo"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "AddItemSegue"{
            let navigationController = segue.destination as! UINavigationController
            let addItemTabelController = navigationController.topViewController as! AddItemTableViewController
            addItemTabelController.delegate = self
        }else if segue.identifier == "EditItemSegue"{
            let navigationController = segue.destination as! UINavigationController
            let addItemTabelController = navigationController.topViewController as! AddItemTableViewController
            addItemTabelController.delegate = self
            
           let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTabelController.item = item
            addItemTabelController.indexPath = indexPath
            
        }
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
       dismiss(animated: true)
    }
    
    func itemSaved(by controller: AddItemTableViewController, with text:String, at indexPath:NSIndexPath?) {
        if let ip = indexPath{
            items[ip.row] = text
        }else{
        items.append(text)
        }
        
        tableView.reloadData()
        dismiss(animated: true)
    }
    


}

