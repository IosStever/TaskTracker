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

    
    var taskItem: Task!
    
    weak var delegate: MyTableViewCellDelegate?
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    func configureCell(task: Task) {
        startTimeLabel?.text = timeFormat(date: task.startTime ?? Date())
        if !task.startToggle {
            startTimeLabel?.textColor = .gray
        } else {
            startTimeLabel?.textColor = .black
        }
       
        taskName?.text = task.taskName
        startOutletSwitch?.setOn(task.startToggle, animated: false)
        commentTextField.text = task.comments ?? ""
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
    }
    
    @IBAction func taskStartSwitch(_ sender: UISwitch) {
        delegate?.didTapStartAction(task: taskItem)
    }
    
    @IBAction func commentInput(_ sender: Any) {
        taskItem.comments = commentTextField.text ?? ""
    }
}





