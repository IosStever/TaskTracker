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


    
    func setTask(task: Task) -> Task {
        let task = task
        return task
    }
 
    
    var taskItem: Task!
    
    weak var delegate: MyTableViewCellDelegate?
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    func configureCell(task: Task) {
        startTimeLabel?.text = timeFormat(date: task.startTime ?? Date())
//        //if task.startToggle {
//            if let time = task.startTime {
//                startTimeLabel?.text = timeFormat(date: time )
//            } else {
//                startTimeLabel?.text = timeFormat(date: Date())
//            }
//        }
//        if !task.startToggle {
//            startTimeLabel?.text = ""
//        }
       
        taskName?.text = task.taskName
        startOutletSwitch?.setOn(task.startToggle, animated: false)
        commentTextField.text = task.comments ?? ""
        //task.comments = commentTextField.text ?? ""
        //commentTex tField.isHidden = true//?.text = task.comments ?? ""
    }

    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func taskStartSwitch(_ sender: UISwitch) {
        delegate?.didTapStartAction(task: taskItem)
    }
    
    @IBAction func commentInput(_ sender: Any) {
        print("commentInputended")
        taskItem.comments = commentTextField.text ?? ""
        //TaskViewController.saveTasks()
    }
}


