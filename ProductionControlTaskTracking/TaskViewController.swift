//
//  TaskViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var taskHeaderLabel: UILabel!
    
    @IBOutlet weak var commentsHeaderLabel: UILabel!
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var dateOfTasksLabel: UILabel!
    
    var taskArray = [Task]()
    
    var dayOfTask : Day? {
        didSet {
            loadTasks()
        }
    }
    
    var summaryText = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let full = UIBarButtonItem(title: "Full", style: .plain, target: self, action: #selector(fullPressed))
        let noWPS = UIBarButtonItem(title: "noWPS", style: .plain, target: self, action: #selector(noWPSPressed))
        let print = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(printPressed))
        let kni = UIBarButtonItem(title: "KNI", style: .plain, target: self, action: #selector(kniPressed))
        let wild = UIBarButtonItem(title: "Wildcard", style: .plain, target: self, action: #selector(wildPressed))
        let b2c = UIBarButtonItem(title: "B2C", style: .plain, target: self, action: #selector(b2cPressed))
        
        let summary = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(summaryPressed))
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPressed))
        
        navigationItem.rightBarButtonItems = [add, b2c, wild, print, kni, noWPS, full, summary]
        navigationItem.title = ""
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        //loadTasks()
    }
    

    
    @objc func fullPressed(_ sender: Any) {
        createTask(name: "Pre-pick release requests", hour: 5, minute: 45)
        createTask(name: "Process Replenator", hour: 6, minute: 45)
        createTask(name: "WPS and MOTX email", hour: 6, minute: 15)
        createTask(name: "Print B2C", hour: 7, minute: 35)
        createTask(name: "Send KNI Spreadsheet", hour: 8, minute: 0)
        createTask(name: "Kick off Regular Pick release", hour: 6, minute: 55)
        createTask(name: "Turbo email", hour: 13, minute: 30)
        self.saveTasks()
        self.loadTasks()
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.saveTasks()
    }
    
    @objc func noWPSPressed(_ sender: Any) {
        createTask(name: "Print B2C", hour: 7, minute: 35)
        createTask(name: "Send KNI Spreadsheet", hour: 8, minute: 0)
        createTask(name: "Kick off Regular Pick release", hour: 7, minute: 30)
        createTask(name: "Turbo email", hour: 13, minute: 30)
        self.saveTasks()
        self.loadTasks()
    }
    
    func createTask(name: String, hour: Int, minute: Int) {
        let newTask = Task(context: self.context)
        newTask.taskName = name
        newTask.startToggle   = false
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.date(bySettingHour: hour,
                                      minute: minute,
                                      second: 0,
                                      of: date,
                                      direction: .backward)
        
        
        newTask.startTime = startTime
        self.taskArray.append(newTask)
    }
    
    func createNowTask(name: String) {
        let newTask = Task(context: self.context)
        newTask.taskName = name
        newTask.startToggle   = true
        newTask.comments = ""
        newTask.dayForTask = self.dayOfTask
        let startTime = Date()
        newTask.startTime = startTime
        self.taskArray.append(newTask)
    }
    
    
    @objc func printPressed(_ sender: Any) {
        createNowTask(name: "Big print job: Add comment")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func kniPressed(_ sender: Any) {
        createNowTask(name: "KNI processing")
        self.saveTasks()
        self.loadTasks()
    }
    
    
    @objc func b2cPressed(_ sender: Any) {
        createNowTask(name: "B2C print")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func wildPressed(_ sender: Any) {
        createNowTask(name: "Wildcards: Add comment")
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
    
    @objc func summaryPressed(_ sender: Any) {
    allTasksTogether()
    let myVC = storyboard?.instantiateViewController(withIdentifier: "summaryVC") as! SummaryViewController
    myVC.summaryText = summaryText
//    if let thisVCtitletext = noteToEdit?.passage {
//        myVC.titleText = thisVCtitletext
//    }
    navigationController?.pushViewController(myVC, animated: true)
    }
    
    func allTasksTogether() {
        saveTasks()
        loadTasks()
        var oneTask = ""
        
        if taskArray.count > 0 {
            for task in taskArray {
                let time = timeFormat(date: task.startTime ?? Date())
                let theTask = task.taskName ?? ""
                let comment = task.comments ?? ""
              
                    oneTask = "\(time) \t \(theTask) \t \(comment) \n"
                    summaryText += oneTask
                
            }
        }
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
        //task.comments = cell.commentTextField.text ?? ""
        cell.delegate = self
        cell.taskItem = taskArray[indexPath.row]
        cell.configureCell(task: task)
        return cell
    }
    
    

    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
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
    
        func textFieldDidEndEditing(_ textField: UITextField) {
            print("textFieldDidEndEditing")
            //saveTasks()
            //loadTasks()
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

