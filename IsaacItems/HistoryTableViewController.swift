//
//  HistoryTableViewController.swift
//  Isaac Items
//
//  Created by Philipp Baum on 06/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var runs = [Tracker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let trackerFetch = NSFetchRequest(entityName: "Tracker")
        trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: false))
        
        
        do {
            
            runs = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
        }catch {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return runs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCellWithIdentifier("trackerCell")
        
        cell!.textLabel!.text = runs[indexPath.row].name
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .Normal, title: "Remove") { (action, indexPath) in
        
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(self.runs[indexPath.row])
            
            let trackerFetch = NSFetchRequest(entityName: "Tracker")
            trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: false))
            
            
            do {
                
                self.runs = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
            }catch {
                
            }

            
            self.tableView.reloadData()
        }
        
        remove.backgroundColor = UIColor.redColor()

        return [remove]
    }
    
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!)
    {
        if (segue.destinationViewController is TrackerViewController) {
            let trackerVC = ((segue.destinationViewController) as! TrackerViewController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            trackerVC.historyTracker = runs[indexPath.row]
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
