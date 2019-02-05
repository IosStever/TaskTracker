//
//  DayViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    var dayArray = [Day]()
    
    @IBOutlet weak var dayTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Your name"
        dayTableView.delegate = self
        dayTableView.dataSource = self
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        //command shift . shows hidden folders
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadDays()
        
        
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
        print("This is the day array")
        print(dayArray)
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
        let destinationVC = segue.destination as! TaskViewController
        
        if let indexPath = dayTableView.indexPathForSelectedRow {
            destinationVC.dayOfTask = dayArray[indexPath.row]
        } else {
            print("Segue for DayVC did not work")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    
    func loadDays (with request: NSFetchRequest<Day> = Day.fetchRequest()) {
        let sort = NSSortDescriptor(key: "dayDate", ascending: false)
        request.sortDescriptors = [sort]
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
