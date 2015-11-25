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

class TrinketsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var items = [Item]()
    var itemsRebirth = [Item]()
    var itemsAfterbirth = [Item]()
    var filteredItems = [Item]()
    var itemCategories = ["Rebirth Trinkets","Afterbirth Trinkets"]
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if (type == "TrinketRebirth") {
                self.itemsRebirth.append(tempItem)
            }else if (type == "TrinketAfterbirth") {
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
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredItems = self.items.filter({( item: Item) -> Bool in
            
            if (self.resultSearchController.searchBar.selectedScopeButtonIndex == 1) {
                let stringMatch = item.propertys!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("trinket")
                return (stringMatch != nil) && (typeMatch != nil)
            }else {
                let stringMatch = item.name!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("trinket")
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
        
        if (section == 0) {
            return itemsRebirth.count
            
        }else if (section == 1) {
            return itemsAfterbirth.count
        }
        
        return 0
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        if (self.resultSearchController.active)
        {
            return 1
        }
        
        return itemCategories.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (self.resultSearchController.active)
        {
            return "Result"
        }
        
        return itemCategories[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier("ItemCell")
        
        var item = items[0]
        if (self.resultSearchController.active)
        {
            item = filteredItems[indexPath.row]
        }else {
            if (indexPath.section == 0) {
                item = itemsRebirth[indexPath.row]
            }else if (indexPath.section == 1) {
                item = itemsAfterbirth[indexPath.row]
            }
        }
        
        
        cell!.textLabel!.text = item.valueForKey("name") as? String
        //cell!.detailTextLabel!.text = item.valueForKey("foundin") as? String
        
        let imageName = item.valueForKey("imagename") as? String
        cell!.imageView?.image = UIImage(named: imageName!)
        
        
        return cell!
    }
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        let detailViewController = ((segue.destinationViewController) as! ItemDetailTableViewController)
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        var item = items[0]
        if (self.resultSearchController.active)
        {
            item = filteredItems[indexPath.row]
        }else {
            if (indexPath.section == 0) {
                item = itemsRebirth[indexPath.row]
            }else if (indexPath.section == 1) {
                item = itemsAfterbirth[indexPath.row]
            }
        }
        
        
        detailViewController.showAddButton = true
        detailViewController.item = item
        
        if(self.resultSearchController.active)
        {
            self.resultSearchController.active = false
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Search
    
    
}
