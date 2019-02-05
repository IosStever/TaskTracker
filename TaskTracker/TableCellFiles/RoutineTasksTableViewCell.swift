//
//  RoutineTasksTableViewCell.swift
//  Tax911TT
//
//  Created by Steven Robertson on 1/30/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class RoutineTasksTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfTaskLabel: UILabel!
    
    @IBOutlet weak var intervalLabel: UILabel!
    
    @IBOutlet weak var tasksCommentTextField: UITextField!
    
    
    var routineTaskItem: RoutineTask!
    
    func configureRoutineTaskCell(routineTask: RoutineTask) {
        nameOfTaskLabel?.text = routineTask.nameOfTask
        intervalLabel?.text = String(routineTask.interval)
        tasksCommentTextField?.text = routineTask.commentsForTask ?? ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func commentsTextField(_ sender: Any) {
        
        routineTaskItem.commentsForTask  = tasksCommentTextField.text ?? ""
    }
}
