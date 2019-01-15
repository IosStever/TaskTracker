//
//  TaskViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var dateOfTasksLabel: UILabel!
    
    var taskArray = [Task]()
    
    var dayOfTask : Day? {
        didSet {
            loadTasks()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // var controller: NSFetchedResultsController<Task>!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
                //generateTestData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let sections = controller.sections {
//
//            let sectionInfo = sections[section]
//            return sectionInfo.numberOfObjects
//        }
        print(taskArray.count)
        
        return taskArray.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        if let sections = controller.sections {
//            return sections.count
//        }
//
//        return 0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        cell.taskName?.text = task.taskName ?? ""
        cell.commentTextField?.text = task.comments ?? ""
        cell.startTimeLabel?.text = timeFormat(date: Date())
        
//        if let taskName = task.taskName {
//            cell.taskName?.text = taskName
//        }
//        if let comments = task.comments {
//            cell.commentTextField?.text = comments
//        }
        
        //cell.startTimeLabel?.text = timeFormat(date: Date())
        //cell.configureCell(task: task)//, indexPath: indexPath as NSIndexPath)
    return cell
    }
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.taskTableView.reloadData()
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let dayPredicate = NSPredicate(format: "dayForTask.dayDate MATCHES %@", dayOfTask!.dayDate!)// as CVarArg)
        //print(dayPredicate)
        //print(dayOfTask!.dayDate!)
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, additionalPredicate])
        } else {
            request.predicate = dayPredicate
            print("Reached else")
            print(request.predicate!)
        }
        
        do {
            taskArray = try context.fetch(request)
            print("Reached context fetch")
            print(taskArray.count)
            print(taskArray)
        } catch {
            print("Error loading context \(error)")
        }
        //generateTestData()
        taskTableView?.delegate = self
        taskTableView?.dataSource = self

        //if taskArray.count > 0 {
        taskTableView?.reloadData()
        //}
    }
    /*
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
     
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading context \(error)")
        }
        
        tableView.reloadData()
        
    }
    */
//    func configureCell(cell: TaskTableViewCell, indexPath: NSIndexPath) {
//
//        let task = controller.object(at: indexPath as IndexPath)
//        cell.configureCell(task: task)
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */
     
     func generateTestData() {
     
     let item = Task(context: context)
     item.taskName = "MacBook Pro"
     
     let item2 = Task(context: context)
     item2.taskName = "Bose Headphones"
     
     let item3 = Task(context: context)
     item3.taskName = "Tesla Model S"
     
     saveItems()
     
     }
     
 
    
    

}

