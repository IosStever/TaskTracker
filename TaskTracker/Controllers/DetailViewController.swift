//
//  DetailViewController.swift
//  TaskTracker
//
//  Created by Steven Robertson on 2/6/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var taskNameOutlet: UITextField!
    
    @IBOutlet weak var taskIntervalOutlet: UITextField!
    
    @IBOutlet weak var taskCommentsOutlet: UITextField!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTask()
        infoTextView.allowsEditingTextAttributes=true
        infoTextView.layer.borderWidth = 1
        infoTextView.layer.borderColor = UIColor.blue.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        //let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplication.willResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    var taskToEdit : RoutineTask? {
        didSet {
            //print(taskToEdit)
            //loadTask()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    @objc func keyboardWillShow(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//                return
//        }
//        //let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
//        //scrollView.contentInset = contentInset
//    }
    
//    @objc func keyboardWillHide(notification:NSNotification){
//
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        self.scrollView.contentInset = contentInset
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        saveData()
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveData()
    }
    
    func loadTask() {
        if let name = taskToEdit?.nameOfTask {
        taskNameOutlet.text =  name
        }
        if let comments = taskToEdit?.commentsForTask {
        taskCommentsOutlet.text = comments
        }
        if let interval = taskToEdit?.interval {
            taskIntervalOutlet.text = String(interval)
        }
        if let info = taskToEdit?.infoRoutine {
        infoTextView.attributedText = (info as! NSAttributedString)
        }
        
        
    }
    
    @objc func appMovedToBackground() {
        saveData()
    }
    
    
    fileprivate func saveData() {
        var task: RoutineTask!
        task = taskToEdit
        
        if let taskName = taskNameOutlet.text {
            task.nameOfTask = taskName
        }
        if let comments = taskCommentsOutlet.text {
            task.commentsForTask = comments
        }
        if let intervalText = taskIntervalOutlet.text {
            if let interval = Int16(intervalText) {
                task.interval=interval
            }
        }
        if let infoText = infoTextView.attributedText {
            task.infoRoutine =  infoText
        }
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    /*
     }RoutineTasks(with request: NSFetchRequest<RoutineTask> = RoutineTask.fetchRequest(), predicate: NSPredicate? = nil) {
     
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
     
     
     
     
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

    @IBAction func intervalChanged(_ sender: Any) {
    }
    
    @IBAction func taskCommentsChanged(_ sender: Any) {
    }
    
    
}