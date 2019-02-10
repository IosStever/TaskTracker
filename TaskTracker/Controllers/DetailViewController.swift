//
//  DetailViewController.swift
//  TaskTracker
//
//  Created by Steven Robertson on 2/6/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow), name:
            UIApplication.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)

    }
    
    var taskToEdit : RoutineTask? {
        didSet {
            //print(taskToEdit)
            //loadTask()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
 

    
    @IBAction func intervalChanged(_ sender: Any) {
    }
    
    @IBAction func taskCommentsChanged(_ sender: Any) {
    }
    
    
}
