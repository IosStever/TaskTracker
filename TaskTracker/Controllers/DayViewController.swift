//
//  DayViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//
/*
 Set labels to 0 to top and bottom, 0 lines
 Set preferred font: ex. dateOfTasks.font = .preferredFont(forTextStyle: .body)
 Set automatic and estimated row height
 Make sure all height settings in storyboard are deleted as well as heightforrowat
 
 */

import UIKit
import CoreData

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    var dayArray = [Day]()
    
    @IBOutlet weak var dayTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Your name"
        
        dayTableView.delegate = self
        dayTableView.dataSource = self
        dayTableView.rowHeight = UITableView.automaticDimension
        dayTableView.estimatedRowHeight = 35.0
        loadDays()
        
    }
    
    @IBAction func questionBtnPressed(_ sender: UIBarButtonItem) {
     }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Type your name below", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newDay = Day(context: self.context)
            newDay.name = textField.text
            let today = Date()
            
            newDay.dayDate = self.timeFormat(date: today)
            newDay.startOfDay = today
            newDay.org = "test"
            self.dayArray.append(newDay)
            
            self.saveDays()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your name"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        alert.preferredAction = action
        present(alert, animated: true, completion: nil)
    }
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return dayArray.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = dayArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DayTableViewCell
        cell.configureCell(day: day)

        return cell
    }
    
    
    func saveDays() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }

        dayTableView.reloadData()
    }
    
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueToTasks":
            
        let destinationVC = segue.destination as! TaskViewController
        
        if let indexPath = dayTableView.indexPathForSelectedRow {
            destinationVC.dayOfTask = dayArray[indexPath.row]
        } else {
            print("Segue for DayVC did not work")
        }
        case "toPopOverVC":
         let destinationVC = segue.destination as! PopOverViewController
         var mutableAttributedString = NSMutableAttributedString()
         
        let style = NSMutableParagraphStyle()
         
        style.alignment = NSTextAlignment.center
         
         
         let boldAttribute = [NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 13)!, NSAttributedString.Key.paragraphStyle: style]
         
         let regularAttribute = [
            NSAttributedString.Key.font: UIFont(name: "Georgia", size: 13)!
            
         ]
         let myString = "Adding day to track\n\n"
         let boldAttributedString = NSAttributedString(string: myString, attributes:  boldAttribute)
         let regularAttributedString = NSAttributedString(string: "Tap the \"+\" button to add a new day to track tasks. Then tap the row you just created to start tracking tasks for today.", attributes: regularAttribute)
         mutableAttributedString = boldAttributedString + regularAttributedString as! NSMutableAttributedString
         destinationVC.preferredContentSize = CGSize(width: 375, height: 75)
         destinationVC.popOverText = mutableAttributedString

        default:
            break
        }
    }
    
    
    func loadDays (with request: NSFetchRequest<Day> = Day.fetchRequest()) {
        request.sortDescriptors = [NSSortDescriptor(key: "dayDate", ascending: true)]
        do {
            dayArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }

        dayTableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(dayArray[indexPath.row])
            dayArray.remove(at: indexPath.row)
            saveDays()
        }
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "n", modifierFlags: .command, action: #selector(addButtonPressed), discoverabilityTitle: "New day"),

        ]
    }
    

    
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
