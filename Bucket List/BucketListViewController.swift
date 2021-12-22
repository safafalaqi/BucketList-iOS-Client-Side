//
//  ViewController.swift
//  Bucket List (iOS Client-Side)
//  Bucket List (Adding Tasks)
//  Bucket List IV
//  Created by Safa Falaqi on 22/12/2021.
// https://github.com/rodleyva/BucketServer/tree/master


import UIKit

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {
    
    var tasks = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
       
    }
    
    func getData(){
      
        TaskModel.getAllTasks() {
                    data, response, error in
                    do {
                        //clear the list
                        self.tasks.removeAll()
                        guard let myData = data else {return}
                        if let tasksResult = try JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                            
                        //itertate through the result to append each object to the tasks array
                            for task in tasksResult{
                                self.tasks.append(task as! NSDictionary)
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print("Something went wrong")
                    }
                }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]["objective"] as? String
        //print(tasks[indexPath.row]["id"] as! String)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Delete Task
        TaskModel.deleteTask(id: tasks[indexPath.row]["id"] as! String) {
           data, response, error in
            print("task deleted")
            self.tasks.remove(at: indexPath.row)
            self.getData()
        }
           
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
            let item = tasks[indexPath.row]
            addItemTabelController.item = item["objective"] as? String
            addItemTabelController.indexPath = indexPath
            
        }
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
       dismiss(animated: true)
    }
    
    func itemSaved(by controller: AddItemTableViewController, with text:String, at indexPath:NSIndexPath?) {
        
        if let ip = indexPath{
            //Update a Task
            TaskModel.updateTask(id: tasks[ip .row]["id"] as! String,objective: text) {
               data, response, error in
                guard let myData = data else {return}
                do{
                let task = try JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                DispatchQueue.main.async {
                    self.tasks[ip.row] = task
                    self.tableView.reloadData()
                }
                self.getData()
                print("task updated")
                }catch{
                    
                }
            }
        }else{
            //Add a New Task
        TaskModel.addTaskWithObjective(objective: text) {
             data, response, error in
            guard let myData = data else {return}
            do{
                let task = try JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                DispatchQueue.main.async {
                    self.tasks.append(task)
                    self.tableView.reloadData()
                }
            self.getData()
            print("new task added")
            }catch{
                
            }
            
            }
          }
        dismiss(animated: true)
    }
}

