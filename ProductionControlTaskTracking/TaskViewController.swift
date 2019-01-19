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
    
    var summaryText = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mode1 = UIBarButtonItem(title: "Mode 1", style: .plain, target: self, action: #selector(mode1Pressed))
        let mode2 = UIBarButtonItem(title: "Mode 2", style: .plain, target: self, action: #selector(mode2Pressed))
        let mode3 = UIBarButtonItem(title: "Mode 3", style: .plain, target: self, action: #selector(mode3Pressed))
        let mode4 = UIBarButtonItem(title: "Mode 4", style: .plain, target: self, action: #selector(mode4Pressed))
        
        let summary = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(summaryPressed))
                let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPressed))
        
        navigationItem.rightBarButtonItems = [add, mode4, mode3, mode2, mode1, summary]
        navigationItem.title = ""
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        //loadTasks()
    }
    

    
    @objc func mode1Pressed(_ sender: Any) {
        let date = Date()
        let calendar = Calendar.current
        let newTask1 = Task(context: self.context)
        newTask1.taskName = "Pre-pick release requests"
        newTask1.startToggle   = false
        newTask1.comments = ""
        newTask1.dayForTask = self.dayOfTask
        let startTime1 = calendar.date(bySettingHour: 5,
                                       minute: 45,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask1.startTime = startTime1
        
        let newTask2 = Task(context: self.context)
        newTask2.taskName = "WPS and MOTX email"
        newTask2.startToggle   = false
        newTask2.comments = ""
        newTask2.dayForTask = self.dayOfTask
        let startTime2 = calendar.date(bySettingHour: 6,
                                       minute: 15,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask2.startTime = startTime2
        
        let newTask3 = Task(context: self.context)
        newTask3.taskName = "Process Replenator"
        newTask3.startToggle   = false
        newTask3.comments = ""
        newTask3.dayForTask = self.dayOfTask
        let startTime3 = calendar.date(bySettingHour: 6,
                                       minute: 45,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask3.startTime = startTime3
        
        let newTask4 = Task(context: self.context)
        newTask4.taskName = "Print B2C"
        newTask4.startToggle   = false
        newTask4.comments = ""
        newTask4.dayForTask = self.dayOfTask
        let startTime4 = calendar.date(bySettingHour: 7,
                                       minute: 30,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask4.startTime = startTime4
        
        let newTask5 = Task(context: self.context)
        newTask5.taskName = "Print Batch A"
        newTask5.startToggle   = false
        newTask5.comments = ""
        newTask5.dayForTask = self.dayOfTask
        let startTime5 = calendar.date(bySettingHour: 8,
                                       minute: 0,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask5.startTime = startTime5
        
        let newTask6 = Task(context: self.context)
        newTask6.taskName = "Send KNI spreadsheet"
        newTask6.startToggle   = false
        newTask6.comments = ""
        newTask6.dayForTask = self.dayOfTask
        let startTime6 = calendar.date(bySettingHour: 8,
                                       minute: 1,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask6.startTime = startTime6
        
        let newTask7 = Task(context: self.context)
        newTask7.taskName = "Wildcards"
        newTask7.startToggle   = false
        newTask7.comments = ""
        newTask7.dayForTask = self.dayOfTask
        let startTime7 = calendar.date(bySettingHour: 9,
                                       minute: 59,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask7.startTime = startTime7
        
        let newTask8 = Task(context: self.context)
        newTask8.taskName = "Print Batch B"
        newTask8.startToggle   = false
        newTask8.comments = ""
        newTask8.dayForTask = self.dayOfTask
        let startTime8 = calendar.date(bySettingHour: 10,
                                       minute: 0,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask8.startTime = startTime8
        
        let newTask9 = Task(context: self.context)
        newTask9.taskName = "Send turbo email"
        newTask9.startToggle   = false
        newTask9.comments = ""
        newTask9.dayForTask = self.dayOfTask
        let startTime9 = calendar.date(bySettingHour: 13,
                                       minute: 30,
                                       second: 0,
                                       of: date,
                                       direction: .backward)
        newTask9.startTime = startTime9
        
        let newTask10 = Task(context: self.context)
        newTask10.taskName = "Transition batch"
        newTask10.startToggle   = false
        newTask10.comments = ""
        newTask10.dayForTask = self.dayOfTask
        let startTime10 = calendar.date(bySettingHour: 14,
                                        minute: 0,
                                        second: 0,
                                        of: date,
                                        direction: .backward)
        newTask10.startTime = startTime10
        
        self.taskArray.append(newTask1)
        self.taskArray.append(newTask2)
        self.taskArray.append(newTask3)
        self.taskArray.append(newTask4)
        self.taskArray.append(newTask5)
        self.taskArray.append(newTask6)
        self.taskArray.append(newTask7)
        self.taskArray.append(newTask8)
        self.taskArray.append(newTask9)
        self.taskArray.append(newTask10)
        self.saveTasks()
        self.loadTasks()
        
    }
    
    
    @objc func mode2Pressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        newTask.taskName = "Send email to Steve"
        newTask.startToggle   = false
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
        newTask1.startToggle   = false
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
              
                    oneTask = "\(time) \t \(theTask) \n"
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

