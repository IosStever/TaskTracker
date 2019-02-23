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
            startTime = Date()//dayOfTask?.startOfDay
            loadTasks()
        }
    }
    
    var tempTaskArray : [TempTask]? {
        didSet {
            addRoutineTasks(tempArray: tempTaskArray!)
        }
    }
    
    var summaryText = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        if let dayBeingTracked = startTime {
            self.navigationItem.title = "Tasks for \(dateFormat(date: dayBeingTracked))"
        } else {
        self.navigationItem.title = "Tasks for today"
        }
        taskTableView.delegate = self
        taskTableView.dataSource = self
        startTimeLabel.text = timeFormat(date: startTime!)
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.estimatedRowHeight = 35
    }
    //MARK: Update GoalTimes
    fileprivate func updateGoalTimes() {
        self.saveTasks()
        if taskArray.count > 0 {
            self.baseTime = Date()
            self.startTimeLabel.text = ("\(timeFormat(date: baseTime!))")
            for task in taskArray {
                if task.startToggle {
                    task.goalTime = baseTime?.adding(minutes: Int(task.timeFromStart))
                    task.startTime = baseTime?.adding(minutes: Int(task.timeFromStart))
                }
            }
        }
        self.saveTasks()
        self.loadTasks()
    }
    
    @IBAction func helpButtonPressed(_ sender: UIBarButtonItem) {
        self.saveTasks()
        let myVC = storyboard?.instantiateViewController(withIdentifier: "popOverVC") as! PopOverViewController
        var mutableAttributedString = NSMutableAttributedString()
        
        let style = NSMutableParagraphStyle()
        
        style.alignment = NSTextAlignment.center
        
        
        let boldAttribute = [NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 13)!, NSAttributedString.Key.paragraphStyle: style]
        
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Georgia", size: 13)!
            
        ]
        let myString = "Adding tasks to track\n\n"
        let boldAttributedString = NSAttributedString(string: myString, attributes:  boldAttribute)
        let regularAttributedString = NSAttributedString(string: "Tap the \"\" button to add a new task. (Shortcut for external keyboard: Ctrl - n). day to track tasks. Then tap the row you just created to start tracking tasks for today.", attributes: regularAttribute)
        mutableAttributedString = boldAttributedString + regularAttributedString as! NSMutableAttributedString
        myVC.preferredContentSize = CGSize(width: 375, height: 200)
        myVC.popOverText = mutableAttributedString
        
        
        
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    
    
    @IBAction func nowButtonPressed(_ sender: UIBarButtonItem) {
        updateGoalTimes()
    }
    //MARK: Add Button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        var textField2 = UITextField()
        textField2.delegate = self
        var intervalEntered = Int16(0)
        let alert = UIAlertController(title: "New Task", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newTask = Task(context: self.context)
            newTask.taskName = textField.text ?? "No name entered"
            let numberEntered = textField2.text ?? "0"
            if let theInterval = Int16(numberEntered) {
                intervalEntered = theInterval
            }
            
            self.startTime = Date()
            newTask.timeFromStart = intervalEntered
            if intervalEntered > 0 {
            newTask.startToggle   = true
            } else {
                newTask.startToggle = false
            }
            newTask.startTime = self.startTime!.adding(minutes: Int(newTask.timeFromStart))
            newTask.goalTime = self.startTime!.adding(minutes: Int(newTask.timeFromStart))
            
            
            newTask.dayForTask = self.dayOfTask
            
            self.taskArray.append(newTask)
            self.saveTasks()
            self.loadTasks()
            self.updateGoalTimes()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New task"
            textField = alertTextField
        }
        alert.addTextField { (alertTextField2) in
            alertTextField2.placeholder = "# of minutes"
            textField2 = alertTextField2
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
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     switch segue.identifier! {
     case "segueToTasks":
     
     let destinationVC = segue.destination as! TaskViewController
     
     if let indexPath = dayTableView.indexPathForSelectedRow {
     destinationVC.dayOfTask = dayArray[indexPath.row]
     } else {
     print("Segue for DayVC did not work")
     }
     case "toPopOverVC":
     let destinationVC = segue.destination as! PopOverViewController
     var mutableAttributedString = NSMutableAttributedString()
     
     let style = NSMutableParagraphStyle()
     
     style.alignment = NSTextAlignment.center
     
     
     let boldAttribute = [NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 13)!, NSAttributedString.Key.paragraphStyle: style]
     
     let regularAttribute = [
     NSAttributedString.Key.font: UIFont(name: "Georgia", size: 13)!
     
     ]
     let myString = "Adding day to track\n\n"
     let boldAttributedString = NSAttributedString(string: myString, attributes:  boldAttribute)
     let regularAttributedString = NSAttributedString(string: "Tap the \"+\" button to add a new day to track tasks. Then tap the row you just created to start tracking tasks for today.", attributes: regularAttribute)
     mutableAttributedString = boldAttributedString + regularAttributedString as! NSMutableAttributedString
     destinationVC.preferredContentSize = CGSize(width: 375, height: 75)
     destinationVC.popOverText = mutableAttributedString
     
     default:
     break
     }
     }
 
 
 
 */
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.saveTasks()
    }
    
    //MARK: Add Routine Tasks
    func addRoutineTasks(tempArray: [TempTask]) {
        loadRTasks()
        for tempTask in tempArray {
            
            baseTime = Date()
            self.startTimeLabel.text = timeFormat(date: baseTime!)
            let newTask = Task(context: self.context)
            newTask.taskName = tempTask.tempName
            newTask.startToggle   = true
            print(self.dayOfTask!)
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
        self.loadTasks()
        self.updateGoalTimes()
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
    
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func infoHelpButtonPressed(_ sender: UIButton) {
    }
    //MARK: Tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
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
        
    }
    
    //    func loadRoutineTasks (with request: NSFetchRequest<Task> = Task.fetchRequest()) {
    //        let sort = NSSortDescriptor(key: "startTime", ascending: true)
    //        request.sortDescriptors = [sort]
    //        do {
    //            taskArray = try context.fetch(request)
    //        } catch {
    //            print("Error loading categories \(error)")
    //        }
    //
    //        taskTableView.reloadData()
    //
    //    }
    
    func loadRTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let dayPredicate = NSPredicate(format: "dayForTask.dayDate MATCHES %@", dayOfTask!.dayDate!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, additionalPredicate])
        } else {
            request.predicate = dayPredicate
            
        }
        //        let sort = NSSortDescriptor(key: "startTime", ascending: true)
        //        request.sortDescriptors = [sort]
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }
        //taskTableView?.reloadData()
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
        print("unwound")
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
        task.startToggle = false
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

extension TaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        
        //        guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
        //            return false
        //        }
        //        return true
    }
}
