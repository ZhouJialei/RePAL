//
//  YDConversationViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

#import "YDConversationViewController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CoreData/CoreData.h>
#import "YDAppDelegate.h"
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
@interface YDConversationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    float prevLines;
    UIButton *sendButton;
}
@property (nonatomic,strong) NSString *cleanName;
@property (nonatomic,strong) NSString *conversationJidString;
@property (nonatomic,strong) UITableView *mtableView;
@property (nonatomic,strong) NSMutableArray* chats;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIView *sendView;
@property (nonatomic,strong) UITextView *msgText;
@end

@implementation YDConversationViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
 

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
	self.view.backgroundColor=[UIColor whiteColor];
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,63,ScreenWidth,20)];
    self.statusLabel.backgroundColor = [UIColor grayColor];
    self.statusLabel.textColor=[UIColor redColor];
    self.statusLabel.textAlignment=NSTextAlignmentCenter;
    [self.statusLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.statusLabel];
   
    //Add a UITableView
    self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60,ScreenWidth,ScreenHeight-80-56) style:UITableViewStylePlain];
    self.mtableView.delegate=self;
    self.mtableView.dataSource=self;
    self.mtableView.rowHeight=64;
    self.mtableView.scrollsToTop = NO;
    self.mtableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.mtableView.backgroundColor = [UIColor clearColor];
    [self.mtableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:self.mtableView];
    //need a view for sending messages with controls
    self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-56,ScreenWidth,56)];
    self.sendView.backgroundColor=[UIColor lightGrayColor];
    self.msgText = [[UITextView alloc] initWithFrame:CGRectMake(47,10,185,36)];
    self.msgText.backgroundColor = [UIColor whiteColor];
    self.msgText.textColor=[UIColor redColor];
    self.msgText.font=[UIFont boldSystemFontOfSize:12];
    self.msgText.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.msgText.layer.cornerRadius = 10.0f;
    self.msgText.returnKeyType=UIReturnKeyDone;
    self.msgText.showsHorizontalScrollIndicator=NO;
    self.msgText.showsVerticalScrollIndicator=NO;
    
    self.msgText.delegate=self;
    [self.sendView addSubview:self.msgText];
    self.msgText.contentInset = UIEdgeInsetsMake(0,0,0,0);
    prevLines=0.9375f;
    //Add the send button
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(235,10,77,36)];
    sendButton.backgroundColor=[UIColor clearColor];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendbutton.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.sendView addSubview:sendButton];
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,77,36)];
    sendLabel.backgroundColor=[UIColor clearColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.font=[UIFont systemFontOfSize:14];
    sendLabel.textColor=[UIColor whiteColor];
    sendLabel.text = @"Send";
    sendLabel.adjustsFontSizeToFitWidth=YES;
    sendLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [sendButton addSubview:sendLabel];
    [self.view addSubview:self.sendView];
   
}
#pragma mark view appearance
-(void)viewWillAppear:(BOOL)animated
{
    //Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:kNewMessage  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusUpdateReceived:) name:kChatStatus  object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChatStatus  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewMessage object:nil];
    
}
-(void)statusUpdateReceived:(NSNotification *)aNotification
{
    NSString *msgStr=  [[aNotification userInfo] valueForKey:@"msg"] ;
    msgStr = [msgStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",self.cleanName,msgStr];
}
-(void)newMessageReceived:(NSNotification *)aNotification
{
    
    //reload our data
    [self loadData];
}
-(void)showConversationForJIDString:(NSString *)jidString
{
    self.conversationJidString = jidString;
    //将带@server的jid替换为只有名字的字符串(cleanName)
    self.cleanName = [jidString stringByReplacingOccurrencesOfString:kXMPPServer withString:@""];
    self.cleanName=[self.cleanName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    self.statusLabel.text = self.cleanName;
    [self loadData];
}


-(void)loadData
{
    if (self.chats)
        self.chats =nil;
    self.chats = [[NSMutableArray alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chat"
                                              inManagedObjectContext:[self appDelegate].managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidString == %@",self.conversationJidString];
    [fetchRequest setPredicate:predicate];
    NSError *error=nil;
    NSArray *fetchedObjects = [[self appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchedObjects)
        {
        [self.chats addObject:obj];
        //Since they are now visible set the isNew to NO
        Chat *thisChat = (Chat *)obj;
        if ([thisChat.isNew  boolValue])
            thisChat.isNew = [NSNumber numberWithBool:NO];
        }
    //Save changes
    error = nil;
    if (![[self appDelegate].managedObjectContext save:&error])
        {
        NSLog(@"error saving");
        }
    //reload the table view
    [self.mtableView reloadData];
    [self scrollToBottomAnimated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Chat *currentChatMessage = (Chat *)[self.chats objectAtIndex:indexPath.row];
    
    if (![currentChatMessage.hasMedia boolValue])
        {
        
        UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
        int width = 185.0, height = 10000.0;
        NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
        [atts setObject:systemFont forKey:NSFontAttributeName];
        
        CGRect textSize = [self.msgText.text boundingRectWithSize:CGSizeMake(width, height)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:atts
                                                          context:nil];
        float textHeight = textSize.size.height;
        return textHeight+40;
        }
    else
        {
        return 100;
        }
    
}
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
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
        {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        }
	Chat* chat = [self.chats objectAtIndex:indexPath.row];
    UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
    int width = 185.0, height = 10000.0;
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:systemFont forKey:NSFontAttributeName];
    
    CGRect textSize = [self.msgText.text boundingRectWithSize:CGSizeMake(width, height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:atts
                                                      context:nil];
    float textHeight = textSize.size.height;

    //Body
    UITextView *body = [[UITextView alloc] initWithFrame:CGRectMake(70,3,240,textHeight+10)];
    body.backgroundColor = [UIColor clearColor];
    body.editable = NO;
    body.scrollEnabled = NO;
    body.backgroundColor=[UIColor clearColor];
    body.textColor=[UIColor blackColor];
    body.textAlignment=NSTextAlignmentLeft;
    [body setFont:[UIFont  boldSystemFontOfSize:12]];
    body.text = chat.messageBody;
    [body sizeToFit];
    //SenderLabel
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,textHeight +10 ,300,20)];
    senderLabel.backgroundColor=[UIColor clearColor];
    senderLabel.font = [UIFont systemFontOfSize:12];
    senderLabel.textColor=[UIColor blackColor];
    senderLabel.textAlignment=NSTextAlignmentLeft;
    UIImage *bgImage;
    float senderStartX;
    if ([chat.direction isEqualToString:@"IN"])
        { // left aligned
            bgImage = [[UIImage imageNamed:@"leftballoon.png"] stretchableImageWithLeftCapWidth:0  topCapHeight:15];
            body.frame=CGRectMake(10,3,240.0,textHeight+10 );
            senderLabel.frame=CGRectMake(19,textHeight+15,250,13);
            senderLabel.text= [NSString stringWithFormat:@"%@: %@",self.cleanName,[YDHelper dayLabelForMessage:chat.messageDate]];
            senderStartX=19;
        }
    else
        {
        //right aligned
        bgImage = [[UIImage imageNamed:@"rightballoonred.png"] stretchableImageWithLeftCapWidth:0  topCapHeight:15];
        body.frame=CGRectMake(45,3,240.0,textHeight+10);
        senderLabel.frame=CGRectMake(55,textHeight+15,250,13);
        senderLabel.text= [NSString stringWithFormat:@"You %@" ,[YDHelper dayLabelForMessage:chat.messageDate]];
        senderStartX=55;
        }
    CGFloat heightForThisCell =  textHeight + 40;
    UIImageView *balloonHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,320,textHeight+35 )];
    balloonHolder.image = bgImage;
    balloonHolder.backgroundColor=[UIColor clearColor];
    //Create the content holder
    UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0,5,320,heightForThisCell)];
    [cellContentView addSubview:balloonHolder];
    [cellContentView addSubview:body];
    [cellContentView addSubview:senderLabel];
    cell.backgroundView = cellContentView;
	return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark screenupdates
//when you start entering text, the table view should be shortened
-(void)shortenTableView
{
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.2];
        self.mtableView.frame=CGRectMake(0,80,ScreenWidth,210);
        [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];
    prevLines=0.9375f;
}
//when finished entering text the table view should change to normal size
-(void)showFullTableView
{
    
    [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.2];
    self.sendView.frame = CGRectMake(0,ScreenHeight-56,ScreenWidth,56);
    self.mtableView.frame=CGRectMake(0,80,ScreenWidth,ScreenHeight-80-56);
    [UIView commitAnimations];
    [self scrollToBottomAnimated:YES];
}
- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [self.chats count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [self.mtableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    
    UIFont* systemFont = [UIFont boldSystemFontOfSize:12];
    int width = 185.0, height = 10000.0;
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    [atts setObject:systemFont forKey:NSFontAttributeName];
    
    CGRect textSize = [self.msgText.text boundingRectWithSize:CGSizeMake(width, height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:atts
                                                      context:nil];
    float textHeight = textSize.size.height;
    float lines = textHeight / lineHeight;
    // NSLog(@"textViewDidChange h: %0.f  lines %0.f ",textHeight,lines);
    if (lines >=4)
        lines=4;
    if (lines < 1.0)
        lines = 1.0;
     //Send your chat state
         NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
        NSXMLElement *status = [NSXMLElement elementWithName:@"composing" xmlns:@"http://jabber.org/protocol/chatstates"];
        [message addChild:status];
        [[self appDelegate].xmppStream sendElement:message];
 
    if (prevLines!=lines)
        [self shortenTableView];
    
    prevLines=lines;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{ [UIView beginAnimations:@"moveView" context:nil];
    [UIView setAnimationDuration:0.3];
    self.sendView.frame = CGRectMake(0,ScreenHeight-270,ScreenWidth,56);
    [UIView commitAnimations];
    [self shortenTableView];
    [self.msgText becomeFirstResponder];
    //Send your chat state
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
    NSXMLElement *status = [NSXMLElement elementWithName:@"composing" xmlns:@"http://jabber.org/protocol/chatstates"];
    [message addChild:status];
    [[self appDelegate].xmppStream sendElement:message];
 
}

#pragma mark send message
-(IBAction)sendMessage:(id)sender
{
    NSString *messageStr = self.msgText.text;
    if([messageStr length] > 0)
        {
            //send chat message
            
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:messageStr];
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
            [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
            [message addChild:body];
            NSXMLElement *status = [NSXMLElement elementWithName:@"active" xmlns:@"http://jabber.org/protocol/chatstates"];
            [message addChild:status];
            
            [[self appDelegate].xmppStream sendElement:message];
                // We need to put our own message also in CoreData of course and reload the data
                Chat *chat = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Chat"
                                       inManagedObjectContext:[self appDelegate].managedObjectContext];
                chat.messageBody = messageStr;
                chat.messageDate = [NSDate date];
                chat.hasMedia=[NSNumber numberWithBool:NO];
                chat.isNew=[NSNumber numberWithBool:NO];
                chat.messageStatus=@"send";
                chat.direction = @"OUT";
                
                chat.groupNumber=@"";
                chat.isGroupMessage=[NSNumber numberWithBool:NO];
                chat.jidString =  self.conversationJidString;
                
                NSError *error = nil;
                if (![[self appDelegate].managedObjectContext save:&error])
                    {
                    NSLog(@"error saving");
                    }
        }
         self.msgText.text=@"";
        if ([self.msgText isFirstResponder])
            [self.msgText resignFirstResponder ];
 
    //Reload our data
    [self loadData];
    //Restore the Screen
    [self showFullTableView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
