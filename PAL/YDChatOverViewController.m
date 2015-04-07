//
//  YDChatOverViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CoreData/CoreData.h>
#import "YDChatOverViewController.h"
#import "YDAppDelegate.h"
#import "YDConversationViewController.h"
#import "MessageCell.h"
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
@interface YDChatOverViewController()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) YDConversationViewController *conversationVC;
@property (weak, nonatomic) IBOutlet UITableView *mtableView;
@property (nonatomic,strong) NSMutableArray* chats;

/*
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *lineOne;
@property (weak, nonatomic) IBOutlet UILabel *lineTwo;
@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
*/

@end
@implementation YDChatOverViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //Add a UITableView
    [self loadData];
    //Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:kNewMessage  object:nil];

}
-(IBAction)startNewConversation:(id)sender
{
    DDLogVerbose(@"startNewConversation");
}
-(void)newMessageReceived:(NSNotification *)aNotification
{
    DDLogVerbose(@"newMessageReceived in YDChatOverViewController");
    //reload our data
    [self loadData];
}

-(void)loadData
{
    if (self.chats)
        self.chats =nil;
    self.chats = [[NSMutableArray alloc]init];
    //从数据库取到Chat表
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //将数据库中所有不是群消息的消息取得
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isGroupMessage == %@",[NSNumber numberWithBool:NO]];
    //fetch distinct only jidString attribute
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    //setDistinctResults，只取不同值
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setResultType:NSDictionaryResultType];
    //根据jidString来获取
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"jidString"]];
    [fetchRequest setFetchBatchSize:50];
    
    NSError *error=nil;
    //取得所有符合条件的消息，遍历
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchedObjects)
        {
        NSMutableDictionary *found = (NSMutableDictionary *)obj;
        NSString *jid = [found valueForKey:@"jidString"];
        //only add the latest one
        [self.chats addObject:[self LatestChatRecordForJID:jid]];
        }
    //reload the table view
    [self.mtableView reloadData];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    Chat* chat = [self.chats objectAtIndex:indexPath.row];
    
    XMPPUserCoreDataStorageObject *user = [[self appDelegate ].xmppRosterStorage userForJID:
                                           [XMPPJID jidWithString:chat.jidString]
                                                                                 xmppStream:[self appDelegate ].xmppStream
                                                                       managedObjectContext:[self appDelegate ]. managedObjectContext_roster];

    if (![[chat isGroupMessage] boolValue])
    {
        //set the avatar for the message cell
        UIImage *avImage = [self configurePhotoForCell:cell user:user];
        cell.avatarImage.image = avImage;
        cell.avatarImage.layer.cornerRadius = 5.0;
        cell.avatarImage.layer.masksToBounds = YES;
        cell.avatarImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.avatarImage.layer.borderWidth = 1.0;
        
        //show the sender's clear name
        NSString *cleanName = [chat.jidString stringByReplacingOccurrencesOfString:kXMPPServer withString:@""];
        cleanName=[cleanName stringByReplacingOccurrencesOfString:@"@" withString:@""];
        cell.lineOne.text = cleanName;
        //if the message is new message, then show the new image and the number of it.
        if ([chat.isNew  boolValue])
        {
            //int numberOfNewMessages = [self countNewMessagesForJID:currentChatThread.jidString];
            cell.numberOfNewMessage.text=[NSString stringWithFormat:@"%i",[self countNewMessagesForJID:chat.jidString]];
            cell.isNew.hidden = NO;
            cell.numberOfNewMessage.hidden = NO;
        }
        //if not, hide them
        else
        {
            cell.isNew.hidden = YES;
            cell.numberOfNewMessage.hidden = YES;
        }
        //show the date of the message cell
        NSString *textForSecondLine = [NSString stringWithFormat:@"%@: %@",[YDHelper dayLabelForMessage:chat.messageDate],chat.messageBody];
        cell.lineTwo.text = textForSecondLine;
    }
    return cell;
}
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the conversation.
        Chat* chat = [self.chats objectAtIndex:indexPath.row];
        //this is only the latest chat within a conversation but we need to delete all chats in the conversation
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                                  inManagedObjectContext:[self appDelegate].managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@",chat.jidString];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        NSError *error=nil;
        NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *obj in fetchedObjects)
            {
            //Delete this object
              [[self appDelegate].managedObjectContext deleteObject:obj];
            }
        //Save to CoreData
         error = nil;
        if (![[self appDelegate].managedObjectContext save:&error])
            {
            DDLogError(@"error saving");
            }
        //reload the array with data
        [self loadData];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.conversationVC)
        self.conversationVC = nil;
    Chat* chat = [self.chats objectAtIndex:indexPath.row];
    self.conversationVC = [[YDConversationViewController alloc]init];
    [self.conversationVC showConversationForJIDString:chat.jidString];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.conversationVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isNew.hidden = YES;
    cell.numberOfNewMessage.hidden = YES;
}
- (UIImage *)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	if (user.photo != nil)
        {
		return  user.photo;
        }
	else
        {
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			return  [UIImage imageWithData:photoData];
		else
			return  [UIImage imageNamed:@"emptyavatar"];
        }
}
#pragma mark helper methods
-(int)countNewMessagesForJID:(NSString *)jidString
{
    //先从数据库中取得所有来自同一jid的消息，然后对isNew标志位为真的消息计数
    int ret=0;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@",jidString];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"messageDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count]>0)
        {
        for (int i=0; i<[fetchedObjects count]; i++) {
            Chat *thisChat = (Chat *)[fetchedObjects objectAtIndex:i];
            if ([thisChat.isNew  boolValue])
                ret++;
        }
        
        }
    fetchedObjects=nil;
    fetchRequest=nil;
    return ret;
}
//将来自jidString的最近一条消息add到chat中
-(Chat *)LatestChatRecordForJID:(NSString *)jidString
{
    
    Chat *hist;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@",jidString];
    [fetchRequest setPredicate:predicate];
    //降序排列
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"messageDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //取最近一条
    if ([fetchedObjects count]>0)
        {
        hist  = (Chat *)[fetchedObjects objectAtIndex:0];
        }
    fetchedObjects=nil;
    fetchRequest=nil;
    return hist;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
