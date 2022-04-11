//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Angela Sanhcez on 4/9/22.
//

import Foundation
import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    var toDos = [ToDo]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let saveTODos = ToDo.loadToDos(){
            toDos = saveTODos
        } else {
            toDos =  ToDo.loadSampleToDo()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
                    fatalError("Could not dequeue a cell")
        }

        cell.delegate = self
        
        let todo = toDos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! AddToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = toDos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = toDos[indexPath.row]
            todo.isComplete = !todo.isComplete
            toDos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    
    
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                toDos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
       ToDo.saveToDos(toDos)
    }
}
