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
        titleLabel.text = "Production Control Task Tracker"
        dayTableView.delegate = self
        dayTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        //attemptFetch()
        loadDays()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return dayArray.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = dayArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DayTableViewCell
        //cell.configureCell(day: day)
        cell.nameOfPerson.text = day.name
        cell.dateOfTasks.text = day.dayDate

        return cell
    }
    
    
    func saveDays() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        dayTableView.reloadData()
        print("dtv saved")
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
            print("Did not work")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    
    func loadDays (with request: NSFetchRequest<Day> = Day.fetchRequest()) {
        do {
            dayArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        dayTableView.reloadData()
        
    }
    @objc func addTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Type your name below", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newDay = Day(context: self.context)
            newDay.name = textField.text
            let today = Date()
            
            newDay.dayDate = self.timeFormat(date: today)
            self.dayArray.append(newDay)

            self.saveDays()
                        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(dayArray[indexPath.row])
            dayArray.remove(at: indexPath.row)
            saveDays()
        }
    }
    
}

