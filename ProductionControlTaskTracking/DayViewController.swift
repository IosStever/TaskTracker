//
//  DayViewController.swift
//  ProductionControlTaskTracking
//
//  Created by Steven Robertson on 1/14/19.
//  Copyright © 2019 Steven Robertson. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var dayTableView: UITableView!
    
    var controller: NSFetchedResultsController<Day>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayTableView.delegate = self
        dayTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        attemptFetch()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DayTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: DayTableViewCell, indexPath: NSIndexPath) {
        
        let day = controller.object(at: indexPath as IndexPath)
        cell.configureCell(day: day)
        
    }
    
    
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
    
    @objc func addTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Type your name below", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newDay = Day(context: context)
            //newNote.passage = textField.text
            newDay.name = textField.text
            let today = Date()
            
            newDay.dayDate = today
            self.saveItems()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        attemptFetch()
    }
    
}

