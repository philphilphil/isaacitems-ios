//
//  ItemsTableViewController.swift
//  IsaacItems
//
//  Created by Philipp Baum on 01/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//

import UIKit
import CSwiftV
import CoreData

class ItemsTableViewController: UITableViewController, UISearchResultsUpdating  {
    
    
    @IBOutlet weak var searchBarItem: UISearchBar!
    var items = [Item]()
    var filteredItems = [Item]()
    var itemsRebirth = [Item]()
    var itemsAfterbirth = [Item]()
    var itemCategories = ["Rebirth Items","Afterbirth Items"]
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
            self.createItems()
            defaults.setBool(true, forKey: "isPreloaded")
        }
        
        //Load Data
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            items = results as! [Item]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        for tempItem in items {
            
            let type = (tempItem.valueForKey("type") as! String)
            if (type == "ItemRebirth") {
                self.itemsRebirth.append(tempItem)
            }else if (type == "ItemAfterbirth") {
                self.itemsAfterbirth.append(tempItem)
            }
        }
        
        self.tableView.editing = false
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.scopeButtonTitles = ["Name", "Property"]
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //        searchBarItem.showsCancelButton = false
        //        searchBarItem.showsScopeBar = false
    }
    
    func createItems() {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Item", inManagedObjectContext:managedContext)
        
        
        //Import Data from CSV
        let myFileURL = NSBundle.mainBundle().URLForResource("items", withExtension: "csv")!
        let itemscsv = try! String(contentsOfURL: myFileURL, encoding: NSUTF8StringEncoding)
        
        let csv = CSwiftV(String: itemscsv, separator: ";")
        
        let rows = csv.rows
        
        for row in rows {
            
            let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            //3
            item.setValue(row[0], forKey: "type")
            item.setValue(row[1], forKey: "name")
            item.setValue(row[3], forKey: "imagename")
            item.setValue(row[4], forKey: "propertys")
            item.setValue(row[5], forKey: "effect")
            item.setValue(row[6], forKey: "notes")
            
            //4
            do {
                try managedContext.save()
                //5
                items.append(item as! Item)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
        //Create Tracker Test Item
        let newTracker = NSEntityDescription.insertNewObjectForEntityForName("Tracker", inManagedObjectContext: managedContext) as! Tracker
        
        newTracker.active = NSNumber(bool: true) as Bool
        newTracker.name = "New Run"
        newTracker.seed = "Seed: -"
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredItems = self.items.filter({( item: Item) -> Bool in
            
            if (self.resultSearchController.searchBar.selectedScopeButtonIndex == 1) {
                let stringMatch = item.propertys!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("item")
                return (stringMatch != nil) && (typeMatch != nil)
            }else {
                let stringMatch = item.name!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("item")
                return (stringMatch != nil) && (typeMatch != nil)
            }
        })
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.active)
        {
            return filteredItems.count
        }
        else
        {
            if (section == 0) {
                return itemsRebirth.count
                
            }else if (section == 1) {
                return itemsAfterbirth.count
            }
        }
        
        
        return 0
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (self.resultSearchController.active)
        {
            return 1
        }
        else
        {
            return itemCategories.count
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (self.resultSearchController.active)
        {
            return "Results"
        }
        
        return itemCategories[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier("ItemCell")
        
        var item = items[0]
        
        if (self.resultSearchController.active) {
            item = filteredItems[indexPath.row]
        }else if (indexPath.section == 0) {
            item = itemsRebirth[indexPath.row]
        }else if (indexPath.section == 1) {
            item = itemsAfterbirth[indexPath.row]
        }
        
        cell!.textLabel!.text = item.valueForKey("name") as? String
        //cell!.detailTextLabel!.text = item.valueForKey("foundin") as? String
        
        let imageName = item.valueForKey("imagename") as? String
        cell!.imageView?.image = UIImage(named: imageName!)
        
        
        return cell!
    }
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        if (segue.destinationViewController is ItemDetailTableViewController) {
            let detailViewController = ((segue.destinationViewController) as! ItemDetailTableViewController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            var item = items[0]
            
            if (self.resultSearchController.active) {
                item = filteredItems[indexPath.row]
            }else if (indexPath.section == 0) {
                item = itemsRebirth[indexPath.row]
            }else if (indexPath.section == 1) {
                item = itemsAfterbirth[indexPath.row]
            }
            
            detailViewController.showAddButton = true
            detailViewController.item = item
        }
        
        if(self.resultSearchController.active)
        {
            self.resultSearchController.active = false
        }
    }
}
