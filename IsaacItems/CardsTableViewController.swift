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

class CardsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    var items = [Item]()
    var cards = [Item]()
    var filteredItems = [Item]()
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
            if (type == "Misc") {
                self.cards.append(tempItem)
            }
            
            self.tableView.editing = false
        }
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.scopeButtonTitles = ["Name", "Property"]
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active)
        {
            return filteredItems.count
        }
        else
        {
            return cards.count
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier("ItemCell")
        
        let item = cards[indexPath.row]
        
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
        
        var item = cards[indexPath.row]
        if (self.resultSearchController.active)
        {
            item = filteredItems[indexPath.row]
        }
        
        detailViewController.showAddButton = true
        detailViewController.item = item
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredItems = self.cards.filter({( item: Item) -> Bool in
            
            if (self.resultSearchController.searchBar.selectedScopeButtonIndex == 1) {
                let stringMatch = item.propertys!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("misc")
                return (stringMatch != nil) && (typeMatch != nil)
            }else {
                let stringMatch = item.name!.lowercaseString.rangeOfString(searchController.searchBar.text!.lowercaseString)
                let typeMatch = item.type!.lowercaseString.rangeOfString("misc")
                return (stringMatch != nil) && (typeMatch != nil)
            }
        })
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Search
    
    
}
