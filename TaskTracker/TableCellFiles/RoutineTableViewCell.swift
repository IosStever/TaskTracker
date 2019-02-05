//
//  RoutineTableViewCell.swift
//  Tax911TT
//
//  Created by Steven Robertson on 1/30/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfRoutineLabel: UILabel!
    
    @IBOutlet weak var routineTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var routineItem: Routine!
    
    func configureRoutineCell(routine: Routine) {
        nameOfRoutineLabel.text = routine.nameOfRoutine
        routineTextField.text = routine.commentsForRoutine ?? ""
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func usePressed(_ sender: UIButton) {
    }
    
    @IBAction func commentsEntered(_ sender: Any) {
       routineItem.commentsForRoutine = routineTextField.text ?? ""
    }
    
}
