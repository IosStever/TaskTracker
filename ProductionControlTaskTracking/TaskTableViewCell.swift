//
//  TaskTableViewCell.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var taskName: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    func configureCell(task: Task) {
        
        if let time = task.time {
        startTimeLabel.text = timeFormat(date: time )
        }
        taskName.text = task.taskName
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
    }
    

}
