//
//  YDContactsViewController.m
//  PAL
//
//  Created by ZhouJialei on 15/2/2.
//  Copyright (c) 2015年 ZhouJialei. All rights reserved.
//

#import "YDContactsViewController.h"
#import "YDConversationViewController.h"
#import <CoreData/CoreData.h>
#import "YDAppDelegate.h"
#import "DDLog.h"
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
@interface YDContactsViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}
@property (strong, nonatomic) IBOutlet UITableView *mtableView;

@property (nonatomic,strong) YDConversationViewController* conversationVC;
@end

@implementation YDContactsViewController

- (YDAppDelegate *)appDelegate
{
	return (YDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    self.view.backgroundColor=[UIColor whiteColor];
    self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,86,ScreenWidth,ScreenHeight - 86-40) style:UITableViewStylePlain];

     self.mtableView .delegate=self;
     self.mtableView .dataSource=self;
     self.mtableView .rowHeight=38.0;
    
     self.mtableView .separatorStyle=UITableViewCellSeparatorStyleNone;
     self.mtableView .backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mtableView];
     */
    //Add the invite button
    /*
    UIButton* inviteButton = [[UIButton alloc] initWithFrame:CGRectMake(20,ScreenHeight - 86-40,280,25)];
    inviteButton.backgroundColor=[UIColor blueColor];
    inviteButton.layer.borderWidth = 1.0f;
    inviteButton.layer.borderColor = [[UIColor grayColor] CGColor];
    inviteButton.layer.cornerRadius = 5.0f;
    [inviteButton addTarget:self action:@selector(inviteUser:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,280,25)];
    inviteLabel.backgroundColor=[UIColor clearColor];
    [inviteLabel setFont:[UIFont systemFontOfSize:16]];
    inviteLabel.text=@"Invite";
    inviteLabel.adjustsFontSizeToFitWidth=YES;
    inviteLabel.textAlignment=NSTextAlignmentCenter;
    inviteLabel.textColor=[UIColor whiteColor];
    [inviteButton addSubview:inviteLabel];
    [self.view addSubview:inviteButton];
     */
}
-(IBAction)inviteUser:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Enter the user name" message:@"e.g peter" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
    [alert show];
}
#pragma mark delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
        {
        UITextField* username = [alertView textFieldAtIndex:0];
        NSString *jidString = [NSString stringWithFormat:@"%@@%@",username.text,kXMPPServer];
       [[self appDelegate] sendInvitationToJID:jidString withNickName:username.text];
        }
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//管理coredata fetch request返回的对象
//控制tableView与fetchedResults通信的controller，连接NSFetchedResultsController与UITableViewController
//能回答所有UITableView,datasource，protocol的问题，唯一不能回答的是cellForRowAtIndexPath(利用objectAtIndexPath可以解决)
- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
        {
        //NSManagedObjectContext(托管对象上下文):数据库，managedObjectContext_roster即为所指定的数据库
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
		
        //NSEntityDescription(实体描述):表，XMPPUserCoreDataStorageObject即为表名
        //从指定的managedObjectContext_roster数据库中提取XMPPUserCoreDataStorageObject这张表
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		//排序，对于特定数组，按照给定键值升(降)序排序
        //按照sectionNum升序排序
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		//按照displayName升序排序
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
        //NSFetchRequest(请求):命令集，创建一个空命令
        //fetchrequest描述了详细的查询规则，还可以添加查询结果的排序描述
        //fetchedResultsController根据已创建完的fetch request创建
        //其任务为使用fetch request保证其所关联的数据的新鲜性
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        //给该命令集指定一个表
		[fetchRequest setEntity:entity];
        //指定排序规则
		[fetchRequest setSortDescriptors:sortDescriptors];
        //每次从数据库加载10条数据来筛选数据
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum" //表示每个managedObject所在的section
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
            {
			DDLogError(@"Error performing fetch: %@", error);
            }
        
        }
	
	return fetchedResultsController;
}
#pragma mark NSFetchedResultsControllerDelegate
//当fetchedResultsController完成对数据的修改时调用，更新表格
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.mtableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewCell helpers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	
	if (user.photo != nil)
        {
		cell.imageView.image = user.photo;
        }
	else
        {
		NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"emptyavatar"];
        }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[[self fetchedResultsController] sections] count];
}

//默认只有Available，Away,Offline三个header，可扩展
- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
        {
        //NSFetchedResultsSectionInfo,由NSFetchedResultController组装成的对象，用于封装section的对象集合
        //类成员：indexTitle，name，numberofObject，objects
        //name指section名，indexTitle指索引名，numberofObjects指section下面的对象数量
        //objects为对象数组
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
            {
                case 0  : return @"Available";
                case 1  : return @"Away";
                default : return @"Offline";
            }
        }
	
	return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
        {
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
		return sectionInfo.numberOfObjects;
        }
	
	return 0;
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
	//objectAtIndexPath:给出一个index，返回该row所显示的NSManagedObject
	XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	cell.textLabel.text = user.displayName;
	[self configurePhotoForCell:cell user:user];
	
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Get our contact record
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    DDLogInfo(@"user %@",user.jidStr);
    
    if (self.conversationVC)
        self.conversationVC = nil;
    
    self.conversationVC = [[YDConversationViewController alloc]init];
    [self.conversationVC showConversationForJIDString:user.jidStr];
    self.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:self.conversationVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
 
	
	[super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
