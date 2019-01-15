//
//  DayTableViewCell.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var nameOfPerson: UILabel!
    
    @IBOutlet weak var dateOfTasks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(day: Day) {
        
  
        dateOfTasks.text = day.dayDate
        
        nameOfPerson.text = day.name
    }
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
}
