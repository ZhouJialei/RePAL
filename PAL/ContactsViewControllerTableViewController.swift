//
//  ContactsViewControllerTableViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/3/30.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//
//MARK: UNUSED

import UIKit

class ContactsViewControllerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITableViewDataSource {
    
    var conversationVC: YDConversationViewController?
    
    @IBOutlet var mtableView: UITableView!
    func appDelegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    //MARK: delegate
    private var _fetchedResultsController: NSFetchedResultsController?
    var fetchedResultsController: NSFetchedResultsController? {
        get {
            if _fetchedResultsController == nil {
                let moc: NSManagedObjectContext = self.appDelegate().managedObjectContext_roster()
                let entity: NSEntityDescription = NSEntityDescription.entityForName("XMPPUserCoreDataStorageObject", inManagedObjectContext: moc)!
                let sd1: NSSortDescriptor = NSSortDescriptor(key: "sectionNum", ascending: true)
                let sd2: NSSortDescriptor = NSSortDescriptor(key: "displayName", ascending: true)
                
                let sortDescriptors: NSArray = NSArray(objects: sd1, sd2)
                let fetchRequest: NSFetchRequest = NSFetchRequest()
                fetchRequest.entity = entity
                fetchRequest.sortDescriptors = sortDescriptors
                fetchRequest.fetchBatchSize = 10
                
                _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "sectionNum", cacheName: nil)
                _fetchedResultsController?.delegate = self
                
                var error: NSError? = nil
                if _fetchedResultsController?.performFetch(&error) == false {
                    println("Error performing fetch: \(error)")
                }
            }
            return _fetchedResultsController
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.mtableView.reloadData()
    }
    
    //MARK: UITableViewCell helpers
    func configurePhotoForCell(cell: UITableViewCell, user: XMPPUserCoreDataStorageObject) {
        if user.photo != nil {
            cell.imageView?.image = user.photo
        }else {
            
            if let photoData = self.appDelegate().xmppvCardAvatarModule?.photoDataForJID(user.jid) {
                cell.imageView!.image = UIImage(data: photoData)
            }else {
                cell.imageView!.image = UIImage(named: "emptyavatar")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        println(self.fetchedResultsController!.sections!.count)
        return self.fetchedResultsController!.sections!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sections: NSArray = self.fetchedResultsController!.sections!
        
        if (section < sections.count) {
            var sectionInfo: AnyObject = sections.objectAtIndex(section)
            
            var sectionIndex: Int = sectionInfo.name.toInt()!
            switch (sectionIndex) {
            case 0:
                return "Available"
            case 1:
                return "Away"
            default:
                return "Offline"
            }
        }
        return ""
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var sections: NSArray = self.fetchedResultsController!.sections!
        
        if section < sections.count {
            var sectionInfo: AnyObject = sections.objectAtIndex(section)
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier: NSString = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        var user: XMPPUserCoreDataStorageObject = self.fetchedResultsController?.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        
        cell!.textLabel?.text = user.displayName
        self.configurePhotoForCell(cell!, user: user)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //Get our contact record
        let user: XMPPUserCoreDataStorageObject = self.fetchedResultsController?.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        println("user \(user.jidStr)")
        
        if (self.conversationVC != nil) {
            self.conversationVC = nil
        }
        
        self.conversationVC = YDConversationViewController()
        self.conversationVC?.showConversationForJIDString(user.jidStr)
        //self.navigationController?.pushViewController(self.conversationVC!, animated: true)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
