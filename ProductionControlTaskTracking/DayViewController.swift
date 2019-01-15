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
//, NSFetchedResultsControllerDelegate {
    
    var dayArray = [Day]()
    
    @IBOutlet weak var dayTableView: UITableView!
    
    //var controller: NSFetchedResultsController<Day>!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayTableView.delegate = self
        dayTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        //attemptFetch()
        loadDays()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if let sections = controller.sections {
//
//            let sectionInfo = sections[section]
//            return sectionInfo.numberOfObjects
//        }
//
        return dayArray.count
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
        let day = dayArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DayTableViewCell
        //cell.configureCell(day: day)
        cell.nameOfPerson.text = day.name
        cell.dateOfTasks.text = day.dayDate
//        if let day = dayArray[indexPath.row].dayDate {
//            cell.dateOfTasks.text = timeFormat(date: day)
//        }
        //timeFormat(date: dayArray[indexPath.row].dayDate)
        //configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
//    func configureCell(cell: DayTableViewCell, indexPath: NSIndexPath) {
//
//        let day = controller.object(at: indexPath as IndexPath)
//        cell.configureCell(day: day)
//
//    }
    
    
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
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskViewController
        if let indexPath = dayTableView.indexPathForSelectedRow {
            destinationVC.dayOfTask = dayArray[indexPath.row]
            print("segue")
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
    /*
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        let dateSort = NSSortDescriptor(key: "dayDate", ascending: false)
        
        
        
        fetchRequest.sortDescriptors = [dateSort]
        
        
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dayTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dayTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                dayTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                dayTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = dayTableView.cellForRow(at: indexPath) as! DayTableViewCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                dayTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                dayTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    */
    @objc func addTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Type your name below", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newDay = Day(context: self.context)
            //newNote.passage = textField.text
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
    
//    func saveItems() {
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//        
//        attemptFetch()
//    }
    
}

