//
//  RoutineTasksTableViewCell.swift
//  Tax911TT
//
//  Created by Steven Robertson on 1/30/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

protocol MyRoutineTaskTableViewCellDelegate : class {
    func didTapInfo (task: RoutineTask)
    
}

class RoutineTasksTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfTaskLabel: UILabel!
    
    
    @IBOutlet weak var tasksCommentTextField: UITextField!
    
    
    var routineTaskItem: RoutineTask!
    
    weak var delegate: MyRoutineTaskTableViewCellDelegate?

    
    func configureRoutineTaskCell(routineTask: RoutineTask) {
        nameOfTaskLabel?.text = ("+\(routineTask.interval):  \((routineTask.nameOfTask) ?? "No name")")
        tasksCommentTextField?.text =  routineTask.commentsForTask ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        delegate?.didTapInfo(task: routineTaskItem)

    }
    
    @IBAction func commentsTextField(_ sender: Any) {
        
        routineTaskItem.commentsForTask  = tasksCommentTextField.text ?? ""
    }
}
