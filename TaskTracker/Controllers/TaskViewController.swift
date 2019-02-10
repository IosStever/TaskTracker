//
//  TaskViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, loadRoutineTasksDelegate {

    @IBOutlet weak var taskHeaderLabel: UILabel!
    @IBOutlet weak var commentsHeaderLabel: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var dateOfTasksLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    var baseTime: Date?
    var startTime: Date?
    var taskArray = [Task]()
    var dayOfTask : Day? {
        didSet {
            startTime = dayOfTask?.startOfDay
            loadTasks()
        }
    }
    
    var tempTaskArray : [TempTask]? {
        didSet {
           print("This is the temptask array")
            print(tempTaskArray!)
           addRoutineTasks(tempArray: tempTaskArray!)
        }
    }
    
    var summaryText = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self.view, action: Selector(“endEditing:”))
//        tap.cancelsTouchesInView = false
//        self.view.addGestureRecognizer(tap)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        startTimeLabel.text = timeFormat(date: startTime!)
        //taskTableView.rowHeight = UITableView.automaticDimension
        //taskTableView.estimatedRowHeight = 35
    }
    
    @IBAction func nowButtonPressed(_ sender: UIBarButtonItem) {
        if taskArray.count > 0 {
            self.baseTime = Date()
            self.startTimeLabel.text = ("\(timeFormat(date: baseTime!))")
            for task in taskArray {
                if !task.startToggle {
                    task.goalTime = baseTime?.adding(minutes: Int(task.timeFromStart))
                }
            }
        }
        self.saveTasks()
        self.loadTasks()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTask = Task(context: self.context)
            newTask.taskName = textField.text ?? "No name entered"
            if let numberEntered = textField2.text {
                if let timeInterval = Int16(numberEntered) {
                    if timeInterval > 0 {
                    self.startTime = Date()
                    newTask.startToggle   = false
                    print("starttoggle is false")
                    newTask.timeFromStart = timeInterval
                    newTask.goalTime = self.startTime!.adding(minutes: Int(newTask.timeFromStart))
                    }
                }
                    else {
                    newTask.startToggle   = true
                    newTask.timeFromStart = 0
                    newTask.startTime = Date()
                    newTask.goalTime = Date()
                }
            }
            //newTask.comments = ""
            newTask.dayForTask = self.dayOfTask
            
            self.taskArray.append(newTask)
            self.saveTasks()
            self.loadTasks()
            
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
    
    @IBAction func listsButtonPressed(_ sender: UIBarButtonItem) {
        self.saveTasks()
        let myVC = storyboard?.instantiateViewController(withIdentifier: "routineVC") as! RoutineViewController
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    @IBAction func summaryButtonPressed(_ sender: UIBarButtonItem) {
        allTasksTogether()
        let myVC = storyboard?.instantiateViewController(withIdentifier: "summaryVC") as! SummaryViewController
        myVC.summaryText = summaryText
        
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.saveTasks()
    }
    

    func addRoutineTasks(tempArray: [TempTask]) {
        
        for tempTask in tempArray {

            baseTime = Date()
            self.startTimeLabel.text = timeFormat(date: baseTime!)
            let newTask = Task(context: self.context)
            newTask.taskName = tempTask.tempName
            newTask.startToggle   = false
            newTask.dayForTask = self.dayOfTask
            if let comments = tempTask.tempComments {
               newTask.comments = comments
            }
            if let interval = tempTask.tempInterval {
                newTask.timeFromStart = Int16(interval)
                newTask.startTime = self.baseTime!.adding(minutes: interval)
                newTask.goalTime = self.baseTime!.adding(minutes: interval)

            }

            if let info = tempTask.tempInfo {
                newTask.info = info
            }
            self.taskArray.append(newTask)

        }

        self.saveTasks()
        self.loadRoutineTasks()
    }
    
    func createTimedTask(name: String, comments: String, timeFromStart: Int) {
        baseTime = Date()
        self.startTimeLabel.text = timeFormat(date: baseTime!)
        let newTask = Task(context: self.context)
        newTask.taskName = name
        newTask.startToggle   = false
        newTask.comments = comments
        newTask.dayForTask = self.dayOfTask
        newTask.startTime = self.baseTime!.adding(minutes: timeFromStart)
        self.taskArray.append(newTask)
    }
    
    func createNowTask(name: String, comments: String) {
        let newTask = Task(context: self.context)
        newTask.taskName = name
        newTask.startToggle   = true
        newTask.comments = comments
        newTask.dayForTask = self.dayOfTask
        let startTime = Date()
        newTask.startTime = startTime
        self.taskArray.append(newTask)
    }
    
    func allTasksTogether() {
    saveTasks()
    loadTasks()
        self.summaryText = ""
        var oneTask = " "
    var sTime = ""
    var gTime = " "
        if taskArray.count > 0 {
        for task in taskArray {
            if let startTime = task.startTime {
                sTime = timeFormat(date: startTime)
            }
            if let goalTime = task.goalTime {
                gTime = timeFormat(date: goalTime)
            }
            let theTask = task.taskName ?? " "
            let comment = task.comments ?? " "
            oneTask = ("\(sTime) \t \(gTime) \t \(theTask) \t \(comment) \n")
            self.summaryText = summaryText + oneTask

            }
    }
}
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    //MARK: Tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        cell.delegateInfo = self
        cell.taskItem = taskArray[indexPath.row]
        cell.configureTaskCell(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(taskArray[indexPath.row])
            taskArray.remove(at: indexPath.row)
            saveTasks()
            taskTableView.reloadData()

        }
    }
    
    //MARK: Save and load functions
    
    func saveTasks() {
            do {
                try self.context.save()
            } catch {
                print("Error saving context \(error)")
            }
        
        //taskTableView.reloadData()
    }
    
    func loadRoutineTasks (with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        let sort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [sort]
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        taskTableView.reloadData()
        
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
    
    @IBAction func unwindToTaskVC(_ sender: UIStoryboardSegue) {
        
    }
    
    //MARK: Keyboard functions
    

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        taskTableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.taskTableView.contentInset = contentInset

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(addButtonPressed), discoverabilityTitle: "New task"),
            
        ]
    }


}

extension TaskViewController: MyTableViewCellDelegate {
    func didTapStartAction(task: Task) {
        task.startToggle = true
        task.info = nil
        task.startTime = Date()
        saveTasks()
        loadTasks()
    }
}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}


extension TaskViewController: MyInfoTaskTableViewCellDelegate {
    func didTapInfo(task: Task) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "infoVC") as! InfoViewController
        myVC.infoTask = task
        
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    
    
}
