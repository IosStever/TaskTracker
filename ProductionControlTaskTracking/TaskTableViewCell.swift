//
//  TaskTableViewCell.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

protocol MyTableViewCellDelegate : class {
    func didTapStartAction (task: Task)
    
}


class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var startOutletSwitch: UISwitch!
//        {
//    didSet {
//    startOutletSwitch.addTarget(self, action: #selector(TaskTableViewCell.updateTime), for: .valueChanged)
//    }
//    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
  
    
    func setTask(task: Task) -> Task {
        let task = task
        return task
    }
   
    //Error in initializing var taskItem = Task()
    //Error in unexpectedly finding nil taskItem: Task!
    
    var taskItem: Task!
    
    @objc func updateTime(task: Task) {
        
         task.time = Date()
        self.startTimeLabel.text = timeFormat(date: task.time!)
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    
    //var taskItem = NSFetchRequest<Task>(entityName: "Task")
    //print("assigned taskItem")
    
    weak var delegate: MyTableViewCellDelegate?
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    func configureCell(task: Task) {
        if let time = task.time {
        startTimeLabel?.text = timeFormat(date: time )
        } else {
             startTimeLabel?.text = ""
        }
        taskName?.text = task.taskName
        startOutletSwitch?.setOn(task.startToggle, animated: false)
        print(task.startToggle)
        commentTextField?.text = task.comments ?? ""
    }

    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func taskStartSwitch(_ sender: UISwitch) {
        //let newTask = Task(context: self.context)
//        guard let theTask = taskItem else {
//            fatalError("task not set")
//        }
        delegate?.didTapStartAction(task: taskItem)
    }
    

}


//extension TaskTableViewCell, TaskDataSourceDelegate {
//    func setTask (task: Task) {
//        taskItem = task
//    }
//}
