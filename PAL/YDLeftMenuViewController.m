//
//  SideMenuViewController.m
//
//  Created by Peter van de Put 
//  Copyright (c) 2013 Peter van de Put. All rights reserved.

#import "YDLeftMenuViewController.h"
 #import "YDHelper.h"
 
#import <QuartzCore/QuartzCore.h>
#import "YDMenuItem.h"
 
 
@interface YDLeftMenuViewController()<UITableViewDataSource,UITableViewDelegate>

{
    
}
 

@property(nonatomic,strong) UITableView* mTableView;
 

@end

@implementation YDLeftMenuViewController

 

- (void)viewDidLoad
{
    [super viewDidLoad];
	 
    self.view.backgroundColor=[UIColor whiteColor];
     self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,66,tablewidth,[[UIScreen mainScreen] bounds].size.height - 60) style:UITableViewStylePlain];
    self.mTableView.delegate=self;
    self.mTableView.dataSource=self;
    self.mTableView.rowHeight=40;
    self.mTableView.backgroundColor=[UIColor whiteColor];
    self.mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.mTableView];
     
     
    
    
        //dropshadow
    self.view.clipsToBounds = NO;
    self.view.layer.masksToBounds = NO;
    CALayer *sublayer = [CALayer layer];
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.backgroundColor=[UIColor blackColor].CGColor;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.frame = CGRectMake(tablewidth-3, 0, 4, [[UIScreen mainScreen] bounds].size.height);
    [self.view.layer addSublayer:sublayer];
     
}




#pragma mark table view delegates

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftTableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YDMenuItem* item = [self.menuItems objectAtIndex:indexPath.row];
    
    UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tablewidth,40)];
    cellContentView.backgroundColor=[YDHelper colorWithHexString:item.backgroundColorHexString];
    
    if ([item.imageName length] >0)
    {
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4,4,32,32)];
    imgView.backgroundColor=[UIColor clearColor];
    imgView.image=[UIImage imageNamed:item.imageName];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
    [cellContentView addSubview:imgView];
    }
    
    
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,0,tablewidth -50,40)];
    titleLabel.textColor=[YDHelper colorWithHexString:item.textColorHexString];
    titleLabel.backgroundColor=[UIColor clearColor];

    titleLabel.text = item.menuTitle;
    [cellContentView addSubview:titleLabel];
    
   
    
    //Adding a dropshadow. Not sure about size and radius
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setShadowOffset:CGSizeMake(1,1)];
    [cell.layer setShadowRadius:1.0];
    [cell.layer setShadowOpacity:1.0];
  
     cell.backgroundView = cellContentView;
    }
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDMenuItem* item = [self.menuItems objectAtIndex:indexPath.row];
    [self.delegate leftMenuSelectionItemClick:item];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count]  ;
}

 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
