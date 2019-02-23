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

protocol MyInfoTaskTableViewCellDelegate : class {
    func didTapInfo (task: Task)
    
}

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var startOutletSwitch: UISwitch!
    
    @IBOutlet weak var goalTimeLabel: UILabel!
    
    var taskItem: Task!
    
    weak var delegate: MyTableViewCellDelegate?
    weak var delegateInfo: MyInfoTaskTableViewCellDelegate?
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    func configureTaskCell(task: Task) {
        if task.startToggle {
            startTimeLabel?.text = ""
            goalTimeLabel?.textColor = .gray
            goalTimeLabel?.text = timeFormat(date: task.goalTime ?? Date())
             startOutletSwitch.isEnabled = true
            
        } else {
            startTimeLabel?.textColor = .black
            startTimeLabel?.text = timeFormat(date: task.startTime ?? Date())
            goalTimeLabel?.text = timeFormat(date: task.goalTime ?? Date())
            startOutletSwitch.isEnabled = false
        }
        
        taskName?.text = ("+\(task.timeFromStart): \((task.taskName) ?? "No name")")
        startOutletSwitch?.setOn(task.startToggle, animated: false)
        commentTextField.text = task.comments ?? ""
        taskName?.font = .preferredFont(forTextStyle: .body)
        commentTextField?.font = .preferredFont(forTextStyle: .body)
        startTimeLabel?.font = .preferredFont(forTextStyle: .body)
        goalTimeLabel?.font = .preferredFont(forTextStyle: .body)
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
    
    @IBAction func infoButtonPushed(_ sender: UIButton) {
        delegateInfo?.didTapInfo(task: taskItem)
    }
    
    @IBAction func taskStartSwitch(_ sender: UISwitch) {
        delegate?.didTapStartAction(task: taskItem)
    }
    
  
    
    
    @IBAction func commentInput(_ sender: Any) {
        taskItem.comments = commentTextField.text ?? ""
    }
}





