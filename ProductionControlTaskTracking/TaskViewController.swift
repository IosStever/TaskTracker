//
//  TaskViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var dateOfTasksLabel: UILabel!
    
    var taskArray = [Task]()
    
    var dayOfTask : Day? {
        didSet {
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        loadTasks()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.taskName?.text = task.taskName ?? ""
        cell.commentTextField?.text = task.comments ?? ""
        if let time = task.time {
            cell.startTimeLabel.text = timeFormat(date: time)
        } else {
        cell.startTimeLabel?.text = ""
        }
        cell.startOutletSwitch.setOn(task.startToggle, animated: false)
        
        return cell
    }
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func saveTasks() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.taskTableView.reloadData()
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let dayPredicate = NSPredicate(format: "dayForTask.dayDate MATCHES %@", dayOfTask!.dayDate!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, additionalPredicate])
        } else {
            request.predicate = dayPredicate
            //print("Reached else")
            //print(request.predicate!)
        }
        
        do {
            taskArray = try context.fetch(request)
            //print("Reached context fetch")
            //print(taskArray.count)
            //print(taskArray)
        } catch {
            print("Error loading context \(error)")
        }
        //generateTestData()
        taskTableView?.delegate = self
        taskTableView?.dataSource = self

        //if taskArray.count > 0 {
        taskTableView?.reloadData()
        //}
    }
    
    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Create deliveries"
        newTask.startToggle   = false
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        self.taskArray.append(newTask)
        print("appended task")
        self.saveTasks()
    }
    
     func generateTestData() {
     
     let item = Task(context: context)
     item.taskName = "MacBook Pro"
     
     let item2 = Task(context: context)
     item2.taskName = "Bose Headphones"
     
     let item3 = Task(context: context)
     item3.taskName = "Tesla Model S"
     
     saveTasks()
     
     }
 
}

