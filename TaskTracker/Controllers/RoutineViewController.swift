//
//  RoutineViewController.swift
//  Tax911TT
//
//  Created by Steven Robertson on 1/30/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var routineTableView: UITableView!
    
    var routineArray = [Routine]()
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        routineTableView.delegate = self
        routineTableView.dataSource = self
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

       self.hideKeyboardWhenTappedAround()
        loadRoutines()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        
        let alert = UIAlertController(title: "Name the series", message: "Series title", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newRoutine = Routine(context: self.context)
            newRoutine.nameOfRoutine = textField.text ?? " "
            newRoutine.commentsForRoutine = textField2.text ?? " "
            self.routineArray.append(newRoutine)
            
            self.saveRoutines()
            self.loadRoutines()
            
        }
        
        alert.addTextField { (alertTextField1) in
            alertTextField1.placeholder = "Name of series"
            textField = alertTextField1
        }
        alert.addTextField { (alertTextField2) in
            alertTextField2.placeholder = "Comments"
            textField2 = alertTextField2
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.preferredAction = action
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return routineArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routine = routineArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineTableViewCell
        cell.routineItem = routineArray[indexPath.row]
        cell.configureRoutineCell(routine: routine)
        
        return cell
    }
    
    
    func saveRoutines() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        routineTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toTasksSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RoutineTasksViewController
        if let indexPath = routineTableView.indexPathForSelectedRow {
            destinationVC.routine = routineArray[indexPath.row]

        } else {
            print("Did not work")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func loadRoutines (with request: NSFetchRequest<Routine> = Routine.fetchRequest()) {
        
        request.sortDescriptors = [NSSortDescriptor(key: "nameOfRoutine", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]

        do {
            routineArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }

        routineTableView?.reloadData()

    }
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        routineTableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.routineTableView.contentInset = contentInset
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(routineArray[indexPath.row])
            routineArray.remove(at: indexPath.row)
            saveRoutines()
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(addButtonPressed), discoverabilityTitle: "New Set"),
            
        ]
    }


    
    
}

extension RoutineViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Routine> = Routine.fetchRequest()
        request.predicate = NSCompoundPredicate(
            type: .or,
            subpredicates: [
                NSPredicate(format: "commentsForRoutine CONTAINS[cd] %@", searchBar.text!),
                NSPredicate(format: "nameOfRoutine CONTAINS[cd] %@", searchBar.text!)
            ]
        )
        
        request.sortDescriptors = [NSSortDescriptor(key: "nameOfRoutine", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        
            self.loadRoutines(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRoutines()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
