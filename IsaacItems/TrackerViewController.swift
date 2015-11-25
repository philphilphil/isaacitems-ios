//
//  TrackerViewController.swift
//  Isaac Items
//
//  Created by Philipp Baum on 06/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//

import UIKit
import CoreData

class TrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var historyTracker : Tracker!
    var tracker : Tracker!
    var items = [Item]()
    var trinkets = [Item]()
    var cards = [Item]()
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btnHistory: UIBarButtonItem!
    @IBOutlet weak var btnEndRun: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (historyTracker != nil) {
            btnHistory.enabled = false
            btnHistory.title = ""
            btnEndRun.title = "< Back"
        }else   {
            btnHistory.enabled = true
            btnHistory.title = "History"
            btnEndRun.title = "End Run"
        }
        
        self.loadData()
        self.tableView.reloadData()
    }
    
    func loadData() {
        //Load Active Tracker
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        items.removeAll()
        trinkets.removeAll()
        cards.removeAll()
        
        do {
            
            let trackerFetch = NSFetchRequest(entityName: "Tracker")
            trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: true))
            let fetchedTrackers = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
            if(historyTracker != nil) {
                self.tracker = historyTracker
            }else if (fetchedTrackers.count == 1) {
                self.tracker = fetchedTrackers[0]
            }else {
                //ERRORHANDLING
                self.tracker = fetchedTrackers[0]
            }

            //Fetch all Items to the Tracker
            let itemsFetch = NSFetchRequest(entityName: "TrackerItems")
            itemsFetch.predicate = NSPredicate(format: "ANY trackerrun == %@", tracker)
            
            let fetchedItems = try managedContext.executeFetchRequest(itemsFetch) as! [TrackerItems]
            
            for fetchedItem in fetchedItems {
                
                let trackerItem = fetchedItem as TrackerItems
                let itemitem = trackerItem.item! as Item
                
                if(itemitem.type == "ItemRebirth" || itemitem.type == "ItemAfterbirth") {
                    items.append(itemitem)
                }else if (itemitem.type == "TrinketAfterbirth" || itemitem.type == "TrinketRebirth") {
                    trinkets.append(itemitem)
                }else if (itemitem.type == "Misc") {
                    cards.append(itemitem)
                }
            }
            
        } catch {
            fatalError("Failed to fetch Trackers: \(error)")
        }
        
    }
    
    //End Tracker Run, save in CoreData
    @IBAction func endCurrentTrackerRun(sender: AnyObject) {
        
        
        if(historyTracker != nil) {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        do {
        let trackerFetch = NSFetchRequest(entityName: "Tracker")
        trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: true))
            
        let fetchedTrackers = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
        fetchedTrackers[0].active = NSNumber(bool: false) as Bool
            
        try managedContext.save()
        
        //Create Tracker Test Item
        let newTracker = NSEntityDescription.insertNewObjectForEntityForName("Tracker", inManagedObjectContext: managedContext) as! Tracker
        
        newTracker.active = NSNumber(bool: true) as Bool
        newTracker.name = "New Run"
        newTracker.seed = "Seed: -"
        

        try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        self.loadData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 4
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        if(section == 0) {
            return 1
        }else if (section == 1) {
            return trinkets.count //Trinkets
        }else if (section == 2) {
            return items.count //Items
        }else if (section == 3) {
            return cards.count //Cards
        }
        
        return 3
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCellTracker", forIndexPath: indexPath)
            (cell.contentView.viewWithTag(1) as! UILabel).text = tracker.name
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCellTracker", forIndexPath: indexPath)
            
            if(indexPath.section == 1) {
                cell.textLabel!.text = trinkets[indexPath.row].name
                cell.imageView?.image = UIImage(named: trinkets[indexPath.row].imagename!)
            }else if (indexPath.section == 2) {
                cell.textLabel!.text = items[indexPath.row].name
                cell.imageView?.image = UIImage(named: items[indexPath.row].imagename!)
            }else if (indexPath.section == 3) {
                cell.textLabel!.text = cards[indexPath.row].name
                cell.imageView?.image = UIImage(named: cards[indexPath.row].imagename!)
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //Rename in Headercell
        if (indexPath.section == 0) {
            let rename = UITableViewRowAction(style: .Destructive, title: "Edit") { (action, indexPath) in
                
                
                
                let alert = UIAlertController(title: "Edit", message: "Name and Seed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Name"
                    textField.secureTextEntry = false
                })
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Seed"
                    textField.secureTextEntry = false
                })
                alert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
                    let newName = (alert.textFields![0] as UITextField).text
                    let newSeed = (alert.textFields![1] as UITextField).text
                    
                    let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    
                    do {
                        let trackerFetch = NSFetchRequest(entityName: "Tracker")
                        trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: true))
                        let fetchedTrackers = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
                        
                        if(fetchedTrackers.count == 1) {
                            fetchedTrackers[0].name = newName
                            fetchedTrackers[0].seed = newSeed
                        }else  {
                                fatalError("Error Renaming")
                        }
                        
                        try managedContext.save()
                        self.loadData()
                        self.tableView.reloadData()
                        
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }

                    

                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                
                
               // print("rename pressed")
            }
            rename.backgroundColor = UIColor.blueColor()
            return [rename]
        }
        
        return []
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Seed: " + tracker.seed!
        }else if(section == 1) {
            return "Trinket"
        }else if (section == 2) {
            return "Items"
        }else if (section == 3) {
            return "Cards/Runes"
        }
        return ""
        
    }
    
    
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        if (segue.destinationViewController is ItemDetailTableViewController) {
            let detailViewController = ((segue.destinationViewController) as! ItemDetailTableViewController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            var item = items[indexPath.row]
            if (indexPath.section == 1) {
                //item = items[indexPath.row] as! Item
            }else if (indexPath.section == 2) {
                item = items[indexPath.row]
                
            }
            
            detailViewController.showAddButton = false
            detailViewController.item = item
        }
        
    }
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        
    //    }
    
}
