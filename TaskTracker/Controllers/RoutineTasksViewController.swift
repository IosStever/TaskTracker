//
//  RoutineTasksViewController.swift
//  Tax911TT
//
//  Created by Steven Robertson on 1/30/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

protocol loadRoutineTasksDelegate : class {
    func loadRoutineTasks(tempArray: [TempTask])
}

class RoutineTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //UITextFieldDelegate
    
    @IBOutlet weak var routineTasksTableView: UITableView!
    
    var routineTasksArray = [RoutineTask]()
    
    var routineName : String?
    
    var routine : Routine? {
        didSet {
            //routineName = routine?.nameOfRoutine
            //print("reached didSet for routine tasks")
            //print(routine!)
            loadRoutineTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: loadRoutineTasksDelegate?
    var tempTasks = [TempTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        routineTasksTableView.delegate = self
        routineTasksTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        loadRoutineTasks()
        saveRoutineTasks()
        loadTempTasks()
        let destinationVC = segue.destination as! TaskViewController
            destinationVC.tempTaskArray = self.tempTasks
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        loadRoutineTasks()
        saveRoutineTasks()
        
        if routineTasksArray.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func loadTempTasks() {
        saveRoutineTasks()
        loadRoutineTasks()
        
        if routineTasksArray.count > 0 {
            for task in routineTasksArray {
                let newTempTask = TempTask()
                newTempTask.tempName = task.nameOfTask ?? ""
                newTempTask.tempInterval = Int(task.interval)
                newTempTask.tempComments = task.commentsForTask ?? ""
                tempTasks.append(newTempTask)
            }
        } else {
            print("array was empty")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newRoutineTask = RoutineTask(context: self.context)
            newRoutineTask.nameOfTask = textField.text
            if let numberEntered = textField2.text {
                if let timeInterval = Int16(numberEntered) {
                    newRoutineTask.interval = timeInterval
                    
                } else {
                    newRoutineTask.interval = 0                }
            }
            
            
            newRoutineTask.commentsForTask = ""
            newRoutineTask.theRoutine = self.routine
            
            self.routineTasksArray.append(newRoutineTask)
            self.saveRoutineTasks()
            self.loadRoutineTasks()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New task"
            textField = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "# of minutes"
            textField2 = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.preferredAction = action
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func useButtonPressed(_ sender: UIBarButtonItem) {
        loadTempTasks()
    }
    
  
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.saveRoutineTasks()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return routineTasksArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routineTask = routineTasksArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineTasksCell", for: indexPath) as! RoutineTasksTableViewCell
        //cell.delegate = self
        cell.routineTaskItem = routineTasksArray[indexPath.row]
        cell.configureRoutineTaskCell(routineTask: routineTask)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(routineTasksArray[indexPath.row])
            routineTasksArray.remove(at: indexPath.row)
            saveRoutineTasks()
        }
    }
    
    func saveRoutineTasks() {
            do {
                try self.context.save()
            } catch {
                print("Error saving context \(error)")
            }
        
        routineTasksTableView.reloadData()
    }
    
    func loadRoutineTasks(with request: NSFetchRequest<RoutineTask> = RoutineTask.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let routinePredicate = NSPredicate(format: "theRoutine.nameOfRoutine MATCHES %@", routine!.nameOfRoutine!)
        print("this is the name of the routine")
        print(routine!.nameOfRoutine!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [routinePredicate, additionalPredicate])
        } else {
            request.predicate = routinePredicate
            
        }
        let sort = NSSortDescriptor(key: "interval", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            routineTasksArray = try context.fetch(request)
            print("This is the routine tasks array")
            print(routineTasksArray)
        } catch {
            print("Error loading context \(error)")
        }
        
        routineTasksTableView?.reloadData()
    }
    
    @objc func useRoutinePressed(_ sender: Any)  {
        loadTempTasks()
        delegate?.loadRoutineTasks(tempArray: tempTasks)
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
//       let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let destVC = mainStoryboard.instantiateViewController(withIdentifier: "taskVC") as? TaskViewController else {
//                print("couldn't find the view controller")
//                //return
//        }
//        
//        navigationController?.pushViewController(TaskViewController, animated: true)  //popViewController(myVC, animated: true)
    }

    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        routineTasksTableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.routineTasksTableView.contentInset = contentInset
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(addButtonPressed), discoverabilityTitle: "New day"),
            
        ]
    }

    
    
}
