//
//  YDAppDelegate.h
//  YDChat
//
//  Created by Peter van de Put on 08/12/2013.
//  Copyright (c) 2013 YourDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDLeftMenuViewController.h"
#import "YDSlideMenuContainerViewController.h"
#import "YDHomeViewController.h"
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@interface YDAppDelegate : UIResponder <UIApplicationDelegate,YDLeftMenuViewControllerDelegate,YDSlideMenuContainerViewControllerDelegate,XMPPRosterDelegate>
{
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
}
//是否已经登陆
@property int isLogged;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  UINavigationController* navigationController;
@property (strong,nonatomic)  YDHomeViewController *rootViewController;
@property(strong,nonatomic)   YDLeftMenuViewController* leftMenuViewController;
@property(strong,nonatomic)   YDSlideMenuContainerViewController *container;
//XMPP
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
//CoreData
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;

//public methods
- (BOOL)connect;
- (void)disconnect;
-(void)sendInvitationToJID:(NSString *)_jid withNickName:(NSString *)_nickName;
-(void)credentialsStored;

#pragma mark Side Menu delegates
-(void)toggleLeftMenu;

@end
