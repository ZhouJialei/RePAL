//
//  YDConversationViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

//两个问题
//第一为老问题，如何处理动态高度，并且在保证美观的前提下嵌入图片

#import "YDConversationViewController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CoreData/CoreData.h>
#import "YDAppDelegate.h"
#import "ConversationCell.h"
#pragma mark hello world
static  NSString * const conversationCellIdentifier = @"conversationCell";
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
@interface YDConversationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    float prevLines;
    //UIButton *sendButton;
}
@property (weak, nonatomic) IBOutlet UITextView *msgText;
@property (weak, nonatomic) IBOutlet UITableView *mtableView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSString *cleanName;
@property (nonatomic,strong) NSString *conversationJidString;
@property (nonatomic,strong) NSMutableArray* chats;

//@property (nonatomic,strong) UITextView *msgText;
@end

@implementation YDConversationViewController
- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}
 

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
	//self.view.backgroundColor=[UIColor whiteColor];

   /*
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
    */
    /*
    self.msgText = [[UITextView alloc] initWithFrame:CGRectMake(47,10,185,36)];
    self.msgText.backgroundColor = [UIColor whiteColor];
    self.msgText.textColor=[UIColor redColor];
    self.msgText.font=[UIFont boldSystemFontOfSize:12];
    //UIViewAutoresizingFlexibleHeight:视图随父视图的高度成比例变化
    //UIViewAutoresizingFlexibleTopMargin:视图上边界随父视图成比例变化
    self.msgText.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.msgText.layer.cornerRadius = 10.0f;
    //returnKeyType:键盘返回键类型
    self.msgText.returnKeyType=UIReturnKeyDone;
    self.msgText.showsHorizontalScrollIndicator=NO;
    self.msgText.showsVerticalScrollIndicator=NO;
    
    self.msgText.delegate=self;
    [self.sendView addSubview:self.msgText];
     */
    //self.msgText.contentInset = UIEdgeInsetsMake(0,0,0,0);
    //prevLines=0.9375f;
    //Add the send button
    /*
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(235,10,77,36)];
    sendButton.backgroundColor=[UIColor clearColor];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendbutton.png"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.sendView addSubview:sendButton];
     */
    /*
    UILabel *sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,77,36)];
    sendLabel.backgroundColor=[UIColor clearColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.font=[UIFont systemFontOfSize:14];
    sendLabel.textColor=[UIColor whiteColor];
    sendLabel.text = @"Send";
    sendLabel.adjustsFontSizeToFitWidth=YES;
    sendLabel.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    //[sendButton addSubview:sendLabel];
    [self.view addSubview:self.sendView];
   */
}

-(void)dismissKeyboard {
    [self.msgText resignFirstResponder];
}

#pragma mark keyboard notifications
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //move the tableView
    //self.mtableView.frame=CGRectMake(0,0,ScreenWidth,453-kbSize.height);
    [UITableView beginAnimations:@"MoveView" context:nil];
    [UITableView setAnimationDuration:0.2f];
    self.mtableView.frame=CGRectMake(0,0,ScreenWidth,453-kbSize.height);
    [UITableView commitAnimations];
    
    //move the sendView
    //self.sendView.frame = CGRectMake(0, 453-kbSize.height, ScreenWidth, 56);
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.sendView.frame = CGRectMake(0, 453-kbSize.height, ScreenWidth, 56);
    [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];
    
    //Send your chat state
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
    NSXMLElement *status = [NSXMLElement elementWithName:@"composing" xmlns:@"http://jabber.org/protocol/chatstates"];
    [message addChild:status];
    [[self appDelegate].xmppStream sendElement:message];
}

-(void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    /*
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
     */
    //reset the tableView
    [UITableView beginAnimations:@"MoveView" context:nil];
    [UITableView setAnimationDuration:0.2f];
    self.mtableView.frame=CGRectMake(0,0,ScreenWidth,453);
    [UITableView commitAnimations];
    
    //reset the sendView
    //self.sendView.frame = CGRectMake(0, 453-kbSize.height, ScreenWidth, 56);
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.sendView.frame = CGRectMake(0, 453, ScreenWidth, 56);
    [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];

}
/*
-(void)textViewDidBeginEditing:(UITextView *)textViewY
{
    self.mtableView.frame=CGRectMake(0,60,ScreenWidth,210);
    [UITableView beginAnimations:@"MoveView" context:nil];
    [UITableView setAnimationDuration:0.2f];
    self.mtableView.frame=CGRectMake(0,60,ScreenWidth,210);
    [UITableView commitAnimations];
    
    self.sendView.frame = CGRectMake(0, 270, ScreenWidth, 56);
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.sendView.frame = CGRectMake(0, 270, ScreenWidth, 56);
    [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];
}
*/

#pragma mark view appearance
#pragma mark 没能完全滚动到消息底部 待处理
-(void)viewWillAppear:(BOOL)animated
{
    //Add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:kNewMessage  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusUpdateReceived:) name:kChatStatus  object:nil];
    [self registerForKeyboardNotifications];
    //使mtableView每次显示都滚动到最近的聊天记录上
    if (self.chats.count > 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chats.count-1 inSection:0];
        [self.mtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }    
    //添加键盘的监听事件
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
     */
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
    return [self heightForConversationCellAtIndexPath:indexPath];
 /*
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
 */
}


-(CGFloat)heightForConversationCellAtIndexPath:(NSIndexPath *)indexPath {
    static ConversationCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.mtableView dequeueReusableCellWithIdentifier:conversationCellIdentifier];
    });
    
    [self configureConversationCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

-(CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
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
    return [self conversationCellAtIndexPath:indexPath];
    
    /*
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
    */
}

-(ConversationCell *)conversationCellAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [self.mtableView dequeueReusableCellWithIdentifier:conversationCellIdentifier forIndexPath:indexPath];
    [self configureConversationCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureConversationCell:(ConversationCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Chat* chat = [self.chats objectAtIndex:indexPath.row];
    //set the text for textLabel
    cell.textLabel.text = chat.messageBody;
    //set the alignment and the senderLabel depending on the direction
    if ([chat.direction isEqualToString:@"IN"]) {
        //left aligned
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.senderLabel.textAlignment = NSTextAlignmentLeft;
        cell.senderLabel.text= [NSString stringWithFormat:@"%@: %@",self.cleanName,[YDHelper dayLabelForMessage:chat.messageDate]];
        
    }else {
        //right aligned
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.senderLabel.textAlignment = NSTextAlignmentRight;
        cell.senderLabel.text= [NSString stringWithFormat:@"You %@" ,[YDHelper dayLabelForMessage:chat.messageDate]];
    }
    //finally set the backgroundView
#pragma mark please implement this
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark screenupdates
#pragma mark need to deal the text input with storyboard
/*
//when you start entering text, the table view should be shortened
-(void)shortenTableView
{
    [UIView beginAnimations:@"moveView" context:nil];
    //动画持续时间
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
*/
- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [self.chats count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [self.mtableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
/*
#pragma mark keyboard
-(void)keyboardDidShow:(NSNotification *)notification
{
    //get the height of the keyboard
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //set the position of the sendview
        //set the animation
    [UIView beginAnimations:nil context:nil];
        //set the duration
    [UIView setAnimationDuration:0.2];
        //set the frame of the view,moving up
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-56, 320, 56)];
    
    [UIView commitAnimations];
}

-(void)keyboardDidHidden
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    //set the frame of the view,moving down
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height - 56, 320, 56)];
    [UIView commitAnimations];
}
*/


/*
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
*/
#pragma mark send message
-(IBAction)sendMessage:(id)sender
{
    NSString *messageStr = self.msgText.text;
    
#pragma mark warning!!!!!changed
//    NSString *toStr = [self.conversationJidString stringByReplacingOccurrencesOfString:kXMPPServer withString:kXMPPDomain];
    
    if([messageStr length] > 0)
        {
            //send chat message
            
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:messageStr];
            NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
            [message addAttributeWithName:@"type" stringValue:@"chat"];
#pragma mark warning!!!!!!changed
            [message addAttributeWithName:@"to" stringValue:self.conversationJidString];
            [message addChild:body];
//            NSXMLElement *status = [NSXMLElement elementWithName:@"active" xmlns:@"http://jabber.org/protocol/chatstates"];
//            [message addChild:status];
            
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
    //[self showFullTableView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
