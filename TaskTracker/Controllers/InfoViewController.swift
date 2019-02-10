//
//  InfoViewController.swift
//  TaskTracker
//
//  Created by Steven Robertson on 2/8/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskCommentsLabel: UILabel!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    var infoTask: Task? {
        didSet {
            //print(taskToEdit)
            //loadTask()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadTask()
        
        // Do any additional setup after loading the view.
    }
    
    func loadTask() {
        if let name = infoTask?.taskName {
            taskNameLabel.text =  name
        }
        if let comments = infoTask?.comments {
            taskCommentsLabel.text = comments
        }

        if let info = infoTask?.info {
            infoTextView.attributedText = (info as! NSAttributedString)
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




