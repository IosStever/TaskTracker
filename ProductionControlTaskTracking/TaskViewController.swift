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
        
        let wps = UIBarButtonItem(title: "WPS", style: .plain, target: self, action: #selector(wpsPressed))
        let b2c = UIBarButtonItem(title: "B2C", style: .plain, target: self, action: #selector(b2cPressed))
        let print = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(printPressed))
        let kni = UIBarButtonItem(title: "KNI", style: .plain, target: self, action: #selector(kniPressed))
        let turbo = UIBarButtonItem(title: "Turbo", style: .plain, target: self, action: #selector(turboPressed))
        let amazon = UIBarButtonItem(title: "AMZN", style: .plain, target: self, action: #selector(amazonPressed))
        let exp = UIBarButtonItem(title: "Exp", style: .plain, target: self, action: #selector(expPressed))
        let drop = UIBarButtonItem(title: "Drop", style: .plain, target: self, action: #selector(dropPressed))
        let issue = UIBarButtonItem(title: "Issue", style: .plain, target: self, action: #selector(issuePressed))
        let dummy = UIBarButtonItem(title: "Scroll", style: .plain, target: self, action: #selector(dummyPressed))

        let summary = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(summaryPressed))
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPressed))
        
        navigationItem.rightBarButtonItems = [add, dummy, turbo, print, kni, issue, exp, drop, b2c, amazon, wps, summary]
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.title = ""
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
    
    //MARK: Functions for Navigation Buttons
    
    @objc func addPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
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
        alert.addAction(cancelAction)
        alert.preferredAction = action
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func dummyPressed(_ sender: Any) {
        createTask(name: "EOD", hour: 18, minute: 0, comment: "Delete when done")
        createTask(name: "EOD", hour: 18, minute: 0, comment: "Delete when done")
        createTask(name: "EOD", hour: 18, minute: 0, comment: "Delete when done")
        createTask(name: "EOD", hour: 18, minute: 0, comment: "Delete when done")
        createTask(name: "EOD", hour: 18, minute: 0, comment: "Delete when done")
        
        self.saveTasks()
        self.loadTasks()
        
    }
    
    @objc func turboPressed(_ sender: Any) {
        createNowTask(name: "Turbo", comments: "Check for deliveries, pre-auth")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func printPressed(_ sender: Any) {
        createNowTask(name: "Print", comments: "Check LGBX singles")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func kniPressed(_ sender: Any) {
        createNowTask(name: "KNI prep or release", comments: " ")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func issuePressed(_ sender: Any) {
        createNowTask(name: "Issue", comments: "Briefly describe")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func expPressed(_ sender: Any) {
        createNowTask(name: "Expedite", comments: "Check for deliveries, pre-auth, move to folder")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func dropPressed(_ sender: Any) {
        createNowTask(name: "Dropship", comments: "Check for deliveries, pre-auth")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func b2cPressed(_ sender: Any) {
        createNowTask(name: "B2C", comments: "Run orders on hold with deliveries")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func amazonPressed(_ sender: Any) {
        createNowTask(name: "Amazon prep or release", comments: "Check for DC prep orders")
        self.saveTasks()
        self.loadTasks()
    }
    
    @objc func wpsPressed(_ sender: Any) {
        createTask(name: "Estimated lines", hour: 5, minute: 45, comment: "Run both TOAD queries if not releasing all")
        createTask(name: "Process header holds", hour: 5, minute: 46, comment: "Email Carrie re: BO threshold")
        createTask(name: "Pre-pick release requests", hour: 5, minute: 48, comment: "Change B2C year")
        createTask(name: "Estimated lines", hour: 5, minute: 50, comment: "After requests finish")

        createTask(name: "Update WPS", hour: 5, minute: 51, comment: "Use picks, carryover reports and est. lines")
        createTask(name: "Replenator", hour: 5, minute: 52, comment: " ")
        createTask(name: "Secondaries", hour: 5, minute: 53, comment: "To Jacob, CC Justin, wavecontrol")
        createTask(name: "Priorities on unprinted lines", hour: 5, minute: 54, comment: " ")

        createTask(name: "WPS and MOTX email", hour: 5, minute: 59, comment: "")
        createTask(name: "No prime", hour: 6, minute: 1, comment: "email to Justin")

        createTask(name: "Process DNSB", hour: 6, minute: 3, comment: "Check request date, email to Carrie")
        createTask(name: "Process Costing holds", hour: 6, minute: 6, comment: "Email to Paul Asnicar")
        createTask(name: "Process Cubiscan holds", hour: 6, minute: 7, comment: "Email to Brandy, Gena")
        createTask(name: "Process MIA", hour: 6, minute: 10, comment: " ")
        createTask(name: "Process pick holds", hour: 6, minute: 11, comment: " ")
        createTask(name: "Process replen issue", hour: 6, minute: 14, comment: "Check for <cpq, order holds")
        createTask(name: "2 deliveries - one order", hour: 6, minute: 17, comment: "Check for pre-auth'd deliveries")
        createTask(name: "Pre-auth", hour: 6, minute: 20, comment: "Process inbox during Reg. pre-auth")
        createTask(name: "Check big lines or boxes", hour: 6, minute: 21, comment: "Avoid orders with 220 lines, 100 boxes Best way to SS")

        createTask(name: "Start Reg. pick release", hour: 6, minute: 30, comment: "Main date only; exclude ESRs")

        self.saveTasks()
        self.loadTasks()
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.saveTasks()
    }
    
    @objc func summaryPressed(_ sender: Any) {
        allTasksTogether()
        let myVC = storyboard?.instantiateViewController(withIdentifier: "summaryVC") as! SummaryViewController
        myVC.summaryText = summaryText
        
        navigationController?.pushViewController(myVC, animated: true)
    }

    //MARK: Supporting functions for navigation buttons
    
    func createTask(name: String, hour: Int, minute: Int, comment: String) {
        let newTask = Task(context: self.context)
        newTask.taskName = name
        newTask.startToggle   = false
        newTask.comments = comment
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(taskArray[indexPath.row])
            taskArray.remove(at: indexPath.row)
            saveTasks()
        }
    }
    
    //MARK: Save and load functions
    
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


}

extension TaskViewController: MyTableViewCellDelegate {
    func didTapStartAction(task: Task) {
        
        task.startTime = Date()
        
        task.startToggle = !task.startToggle
        saveTasks()
        loadTasks()
    }
}


