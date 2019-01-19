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
//            DispatchQueue.main.async {
//                self.taskTableView.reloadData()
//            }
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mode1 = UIBarButtonItem(title: "Mode 1", style: .plain, target: self, action: #selector(mode1Pressed))
        let mode2 = UIBarButtonItem(title: "Mode 2", style: .plain, target: self, action: #selector(mode2Pressed))
        let mode3 = UIBarButtonItem(title: "Mode 3", style: .plain, target: self, action: #selector(mode3Pressed))
        let mode4 = UIBarButtonItem(title: "Mode 4", style: .plain, target: self, action: #selector(mode4Pressed))
                let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPressed))
        
        navigationItem.rightBarButtonItems = [add, mode4, mode3, mode2, mode1]
        
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        //loadTasks()
    }
    

    
    @objc func mode1Pressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Send MOTX email"
        newTask.startToggle   = true
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        
        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.date(bySettingHour: 6,
                                      minute: 15,
                                      second: 0,
                                      of: date,
                                      direction: .backward)

        
        newTask.startTime = startTime
        self.taskArray.append(newTask)
       
        let newTask1 = Task(context: self.context)
        newTask1.taskName = "Send KNI email"
        newTask1.startToggle   = true
        newTask1.comments = ""
        newTask1.dayForTask = self.dayOfTask
        let startTime2 = calendar.date(bySettingHour: 14,
                                      minute: 0,
                                      second: 0,
                                      of: date,
                                      direction: .backward)
        newTask1.startTime = startTime2
        self.taskArray.append(newTask1)
        self.saveTasks()
        self.loadTasks()
        
    }
    
    
    @objc func mode2Pressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Send email to Steve"
        newTask.startToggle   = true
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        
        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.date(bySettingHour: 6,
                                      minute: 30,
                                      second: 0,
                                      of: date,
                                      direction: .backward)
        
        
        newTask.startTime = startTime
        self.taskArray.append(newTask)
        let newTask1 = Task(context: self.context)
        newTask1.taskName = "Start pick release"
        newTask1.startToggle   = true
        newTask1.comments = ""
        newTask1.dayForTask = self.dayOfTask
        let startTime2 = calendar.date(bySettingHour: 7,
                                       minute: 0,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask1.startTime = startTime2
        self.taskArray.append(newTask1)
        self.saveTasks()
        self.loadTasks()
    }
    
    
    @objc func mode3Pressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Send MOTX email"
        newTask.startToggle   = false
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        newTask.startTime = Date()
        self.taskArray.append(newTask)
        let newTask1 = Task(context: self.context)
        newTask1.taskName = "Send KNI email"
        newTask1.startToggle   = false
        newTask1.comments = ""
        newTask1.dayForTask = self.dayOfTask
        newTask1.startTime = Date()
        self.taskArray.append(newTask1)
        self.saveTasks()
        self.loadTasks()
    }
    
    
    @objc func mode4Pressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Send MOTX email"
        newTask.startToggle   = false
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        newTask.startTime = Date()
        self.taskArray.append(newTask)
        let newTask1 = Task(context: self.context)
        newTask1.taskName = "Send KNI email"
        newTask1.startToggle   = false
        newTask1.comments = ""
        newTask1.dayForTask = self.dayOfTask
        newTask1.startTime = Date()
        self.taskArray.append(newTask1)
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func addPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            let newTask = Task(context: self.context)
            newTask.taskName = textField.text
            newTask.startToggle   = true
            newTask.comments = ""
            newTask.dayForTask = self.dayOfTask
            newTask.startTime = Date()
            self.taskArray.append(newTask)
            self.saveTasks()
            self.loadTasks()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
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
        cell.delegate = self
        cell.taskItem = taskArray[indexPath.row]
        cell.configureCell(task: task)
        return cell
    }
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func saveTasks() {
        DispatchQueue.main.async {
            do {
                try self.context.save()
            } catch {
                print("Error saving context \(error)")
            }
        }
        
        self.taskTableView.reloadData()
    }
    

    
    
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let dayPredicate = NSPredicate(format: "dayForTask.dayDate MATCHES %@", dayOfTask!.dayDate!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, additionalPredicate])
        } else {
            request.predicate = dayPredicate
            
        }
        let sort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [sort]

        do {
            taskArray = try context.fetch(request)
            
        } catch {
            print("Error loading context \(error)")
        }

        
        taskTableView?.reloadData()
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

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(taskArray[indexPath.row])
            taskArray.remove(at: indexPath.row)
            saveTasks()
        }
    }
    
    
}

extension TaskViewController: MyTableViewCellDelegate {
    func didTapStartAction(task: Task) {
        task.startTime = Date()
        
        task.startToggle = !task.startToggle
        saveTasks()
        loadTasks()
    }
}

