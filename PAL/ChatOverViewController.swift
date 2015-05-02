//
//  ChatOverViewController.swift
//  PAL
//
//  Created by 周佳磊 on 15/3/30.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//
//UNUSED


import UIKit

class ChatOverViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mtableView: UITableView!
    var chats: NSMutableArray?
    var conversationVC: YDConversationViewController?
    
    func appDelegate() -> YDAppDelegate {
        return UIApplication.sharedApplication().delegate as YDAppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.loadData()
        //add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("newMessageReceived:"), name: kNewMessage, object: nil)
    }
    
    func newMessageReceived(aNotification: NSNotification) {
        println("newMessageReceived in ChatOverViewController")
        self.loadData()
    }
    
    func loadData() {
        if self.chats != nil {
            self.chats = nil
        }
        self.chats = NSMutableArray()
        let entity: NSEntityDescription = NSEntityDescription.entityForName("Chat", inManagedObjectContext: self.appDelegate().managedObjectContext!)!
        var fetchRequest: NSFetchRequest = NSFetchRequest()
        //skip Group messages
        var predicate: NSPredicate = NSPredicate(format: "isGroupMessage == %@", NSNumber(bool: false))!
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        fetchRequest.propertiesToFetch = NSArray(object: "jidString")
        fetchRequest.fetchBatchSize = 50
        
        var error: NSError? = nil
        var fetchedObjects: NSArray = self.appDelegate().managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
        
        for obj in fetchedObjects {
            var found: NSMutableDictionary = obj as NSMutableDictionary
            var jid: NSString = found.valueForKey("jidString") as NSString
            //only add the latest one
            self.chats?.addObject(self.LatestChatRecordForJID(jid))
        }
        //reload the table view
        self.mtableView.reloadData()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.chats!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier = "Cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        var chat: Chat = self.chats?.objectAtIndex(indexPath.row) as Chat
        
        var user: XMPPUserCoreDataStorageObject = self.appDelegate().xmppRosterStorage!.userForJID(XMPPJID.jidWithString(chat.jidString), xmppStream: self.appDelegate().xmppStream, managedObjectContext: self.appDelegate().managedObjectContext_roster())
        
        var bgView: UIView = UIView(frame: CGRectMake(0,0,320,60))
        bgView.backgroundColor = UIColor.clearColor()
        if chat.isGroupMessage.boolValue == false {
            var avatarImage: UIImageView = UIImageView(frame: CGRectMake(6, 14, 37, 37))
            avatarImage.backgroundColor = UIColor.clearColor()
            avatarImage.contentMode = UIViewContentMode.ScaleAspectFill
            var avImage: UIImage = self.configurePhotoForCell(cell!,user: user)
            avatarImage.image = avImage
            avatarImage.layer.cornerRadius = 5.0
            avatarImage.layer.masksToBounds = true
            avatarImage.layer.borderColor = UIColor.lightGrayColor().CGColor
            avatarImage.layer.borderWidth = 1.0
            bgView.addSubview(avatarImage)
            
            var arrowView: UIImageView = UIImageView(frame: CGRectMake(286, 13, 27, 45))
            arrowView.backgroundColor = UIColor.clearColor()
            arrowView.image = UIImage(named: "arrow.png")
            bgView.addSubview(arrowView)
            
            var line1: UILabel = UILabel(frame: CGRectMake(58, 5, 220, 25))
            line1.backgroundColor = UIColor.clearColor()
            var cleanName: NSString = chat.jidString.stringByReplacingOccurrencesOfString(kXMPPServer, withString: "", options: NSStringCompareOptions(), range: nil)
            cleanName = cleanName.stringByReplacingOccurrencesOfString("@", withString: "")
            line1.text = cleanName
            line1.font = UIFont.systemFontOfSize(18)
            line1.textColor = UIColor.blackColor()
            bgView.addSubview(line1)
            
            if chat.isNew.boolValue == true {
                var newImageView: UIImageView = UIImageView(image: UIImage(named: "new.png"))
                newImageView.backgroundColor = UIColor.clearColor()
                newImageView.frame = CGRectMake(248, 16, 28, 14)
                bgView.addSubview(newImageView)
                
                var numberLabel: UILabel = UILabel(frame: CGRectMake(257, 13, 30, 15))
                numberLabel.backgroundColor = UIColor.clearColor()
                numberLabel.textAlignment = NSTextAlignment.Right
                numberLabel.font = UIFont.systemFontOfSize(16)
                numberLabel.textColor = UIColor.blackColor()
                //MAKR: !!!!!!!!
                numberLabel.text = NSString(format: "%i", self.countNewMessageForJID(chat.jidString))
                bgView.addSubview(numberLabel)
            }
            var textForSecondLine: NSString = NSString(format: "%@: %@", YDHelper.dayLabelForMessage(chat.messageDate),chat.messageBody)
            
            var line2 = UILabel(frame: CGRectMake(58, 38, 220, 16))
            line2.backgroundColor = UIColor.clearColor()
            line2.text = textForSecondLine
            line2.font = UIFont.systemFontOfSize(12)
            line2.textColor = UIColor.blackColor()
            bgView.addSubview(line2)
        }
        cell?.backgroundView = bgView
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete the conversation
            var chat: Chat = self.chats?.objectAtIndex(indexPath.row) as Chat
            //this is only the latest chat within a conversation but we need to delete all chats in the conversation
            var entity: NSEntityDescription? = NSEntityDescription.entityForName("Chat", inManagedObjectContext: self.appDelegate().managedObjectContext!)
            var fetchRequest: NSFetchRequest = NSFetchRequest()
            var predicate: NSPredicate = NSPredicate(format: "jidString == %@", chat.jidString)!
            fetchRequest.predicate = predicate
            fetchRequest.entity = entity
            
            var error: NSError? = nil
            var fetchedObjects: NSArray = self.appDelegate().managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
            for obj in fetchedObjects {
                //Delete this object
                self.appDelegate().managedObjectContext?.deleteObject(obj as NSManagedObject)
            }
            //Save to CoreData
            error = nil
            if self.appDelegate().managedObjectContext?.save(&error) == false {
                println("error saving"  )
            }
            //reload the array with data
            self.loadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.conversationVC != nil {
            self.conversationVC = nil
        }
        var chat: Chat = self.chats!.objectAtIndex(indexPath.row) as Chat
        self.conversationVC?.showConversationForJIDString(chat.jidString)
        self.navigationController?.pushViewController(self.conversationVC!, animated: true)
    }
    
    func configurePhotoForCell(cell: UITableViewCell, user: XMPPUserCoreDataStorageObject) -> UIImage{
        if user.photo != nil {
            return user.photo
        }else {
            var photoData: NSData? = self.appDelegate().xmppvCardAvatarModule!.photoDataForJID(user.jid)
            if photoData != nil {
                return UIImage(data: photoData!)!
            }else {
                return UIImage(named: "emptyavatar")!
            }
        }
    }
    
    //MARK: helper methods
    func countNewMessageForJID(jidString: NSString) -> Int {
        var ret = 0
        var entity: NSEntityDescription = NSEntityDescription.entityForName("Chat", inManagedObjectContext: self.appDelegate().managedObjectContext!)! as NSEntityDescription
        var fetchRequest: NSFetchRequest? = NSFetchRequest()
        fetchRequest!.entity = entity
        var predicate: NSPredicate = NSPredicate(format: "jidString == %@", jidString)!
        fetchRequest!.predicate = predicate
        var sd: NSSortDescriptor = NSSortDescriptor(key: "messageDate", ascending: false)
        var sortDescriptors: NSArray = NSArray(objects: sd)
        fetchRequest!.sortDescriptors = sortDescriptors
        var error: NSError? = nil
        var fetchedObjects: NSArray? = self.appDelegate().managedObjectContext!.executeFetchRequest(fetchRequest!, error: &error)!
        
        if fetchedObjects!.count > 0 {
            for (var i = 0;i < fetchedObjects?.count; ++i ) {
                var thisChat: Chat = fetchedObjects!.objectAtIndex(i) as Chat
                if thisChat.isNew.boolValue == true {
                    ret++
                }
            }
        }
        fetchedObjects = nil
        fetchRequest = nil
        return ret
    }
    
    func LatestChatRecordForJID(jidString: NSString) -> Chat {
        var hist: Chat?
        var entity: NSEntityDescription = NSEntityDescription.entityForName("Chat", inManagedObjectContext: self.appDelegate().managedObjectContext!)!
        var fetchRequest: NSFetchRequest? = NSFetchRequest()
        fetchRequest!.entity = entity
        var predicate: NSPredicate = NSPredicate(format: "jidString == %@", jidString)!
        fetchRequest!.predicate = predicate
        var sd: NSSortDescriptor = NSSortDescriptor(key: "messageDate", ascending: false)
        var sortDescriptors: NSArray = NSArray(objects: sd)
        fetchRequest!.sortDescriptors = sortDescriptors
        var error: NSError? = nil
        var fetchedObjects: NSArray? = self.appDelegate().managedObjectContext?.executeFetchRequest(fetchRequest!, error: &error)
        if fetchedObjects!.count > 0 {
            hist = fetchedObjects!.objectAtIndex(0) as? Chat
        }
        fetchedObjects = nil
        fetchRequest = nil
        return hist!
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
