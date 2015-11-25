//
//  ItemDetailTableViewController.swift
//  IsaacItems
//
//  Created by Philipp Baum on 04/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//

import UIKit
import CoreData
//#import "Tracker.h"

class ItemDetailTableViewController: UITableViewController {
    
    var item : Item!
    var showAddButton = Bool()
    var itemName = String()
    var itemEffect = String()
    var itemNotes = String()
    var itemImageName = String()
    var addedToTrack = Bool()
    var sectionHeaders = ["Item", "Effect","Note"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 22.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        itemName = item.name!
        itemEffect = item.effect!
        itemNotes = item.notes!
        itemImageName = item.imagename!
        self.addedToTrack = false;
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //If effect is empty dont add Effect row
//        if(itemNotes.isEmpty) {
//            return 4
//        }
//        return 5
        return 1
    }
    
    @IBAction func trackItem(sender: AnyObject) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let trackerFetch = NSFetchRequest(entityName: "Tracker")
        trackerFetch.predicate = NSPredicate(format: "active == %@", NSNumber(bool: true))
        
        
        do {
            
            //TODO: Check if item already existing in run
            
            let fetchedTrackers = try managedContext.executeFetchRequest(trackerFetch) as! [Tracker]
            let newItem = NSEntityDescription.insertNewObjectForEntityForName("TrackerItems", inManagedObjectContext: managedContext) as! TrackerItems
            
            newItem.trackerrun = fetchedTrackers[0]
            newItem.item = item
            newItem.active = NSNumber(bool: true) as Bool
            
            try managedContext.save()
            self.addedToTrack = true;
            self.tableView.reloadData()
            
        } catch {
            fatalError("Failed to fetch Trackers: \(error)")
        }
    }
    
    //Prepare string and format stuff
    func prepareTextForLabel(itemString: String) -> NSAttributedString {
        
        var preparedString = itemString.stringByReplacingOccurrencesOfString("*", withString: "<br />&bull; ")
        
        let asRange = preparedString.rangeOfString("<br />")
        if let asRange = asRange where asRange.startIndex == preparedString.startIndex {
            preparedString = preparedString.substringWithRange(Range<String.Index>(start: preparedString.startIndex.advancedBy(6), end: preparedString.endIndex.advancedBy(0)))
        }
        
        //preparedString = preparedString + "<br />"
        let attrStr = try! NSMutableAttributedString(
            data: preparedString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        let fullRange : NSRange = NSMakeRange(0, attrStr.length)
        attrStr.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(16.0)], range: fullRange)
        
        return attrStr
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
//        if (indexPath.row == 1 || indexPath.row == 3) {
//            let cell = tableView.dequeueReusableCellWithIdentifier("spaceCell", forIndexPath: indexPath)
//            cell.layoutMargins = UIEdgeInsets.init(top: 0, left:1, bottom: 0, right: 1)
//            return cell
//        }
        
        if (indexPath.section == 0) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath)
            (cell.contentView.viewWithTag(1) as! UILabel).text = itemName
            (cell.contentView.viewWithTag(4) as! UIImageView).image = UIImage(named: itemImageName)
            if (!showAddButton) {
                (cell.contentView.viewWithTag(5) as! UIButton).hidden = true
            }
            
            if(self.addedToTrack) {
                (cell.contentView.viewWithTag(5) as! UIButton).hidden = true
                (cell.contentView.viewWithTag(6) as! UIButton).hidden = false
            }else {
                (cell.contentView.viewWithTag(6) as! UIButton).hidden = true
            }
            
                  cell.layoutMargins = UIEdgeInsets.init(top: 0, left:1, bottom: 0, right: 1)
                  cell.layoutMargins = UIEdgeInsets.init(top: 0, left:1, bottom: 0, right: 1)
            return cell
            
        }else if (indexPath.section == 1) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("effectCell", forIndexPath: indexPath)
            (cell.contentView.viewWithTag(2) as! UILabel).attributedText = self.prepareTextForLabel(itemEffect)
                  cell.layoutMargins = UIEdgeInsets.init(top: 0, left:30, bottom: 0, right: 1)
            return cell
            
        } else if (indexPath.section == 2) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath)
            (cell.contentView.viewWithTag(3) as! UILabel).attributedText = self.prepareTextForLabel(itemNotes)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath)

        return cell
    }
}
