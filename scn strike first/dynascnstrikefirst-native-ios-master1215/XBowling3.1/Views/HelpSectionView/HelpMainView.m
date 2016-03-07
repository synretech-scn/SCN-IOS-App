//
//  HelpMainView.m
//  XBowling3.1
//
//  Created by Click Labs on 4/6/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "HelpMainView.h"

@implementation HelpMainView
{
    ExpandableTableView *mainTableView;
    NSArray *sectionsArray;
    NSArray *helpSubSectionsArray;
    NSMutableArray *openSectionsArray;   //Array of index of open sections
    NSArray *sectionsIconsArray;
    NSArray *helpSubSectionIconsArray;
    UIWebView *mainWebView;
    UIView *footerViewForWebview;

}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self createHelpView];
    }
    return self;
}

- (void)createHelpView
{
    openSectionsArray=[NSMutableArray new];
    sectionsArray=[[NSArray alloc]initWithObjects:@"Help",@"Feedback",@"About Us",@"Terms of Service",@"Privacy Policy",@"Copyright Policy", nil];
    helpSubSectionsArray=[[NSArray alloc]initWithObjects:@"Tutorials",@"Rules",@"Support",@"FAQ", nil];
     helpSubSectionIconsArray=[[NSArray alloc]initWithObjects:@"tutorials.png",@"rules.png",@"support.png",@"faq.png", nil];
     sectionsIconsArray=[[NSArray alloc]initWithObjects:@"help.png",@"feedback.png",@"about_us.png",@"term_of_service.png",@"privacy_policy.png",@"copyright.png", nil];
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=XBHeaderColor;
    [self addSubview:headerView];
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
    [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:150 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:194 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.text=@"Help";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.center=CGPointMake(headerView.center.x, headerLabel.center.y);
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    mainTableView=[[ExpandableTableView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height],self.frame.size.width,self.frame.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.height])) style:UITableViewStyleGrouped];
    mainTableView.backgroundColor=[UIColor clearColor];
    [mainTableView setDataSource:self];
    [mainTableView setDelegate:self];
    mainTableView.expandableTableDelegate=self;
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:mainTableView];
}

#pragma mark - Side Menu
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}

#pragma mark - TableView data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:0.5 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"HeaderHeight=%f",[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:210/3 currentSuperviewDeviceSize:screenBounds.size.height];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBase=(UIButton*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBase removeFromSuperview];
        cellBase=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIImageView *cellView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cellView.tag=indexPath.row+100;
//    cellView.backgroundColor=[UIColor clearColor];
    [cellView setImage:[UIImage imageNamed:@"nav_2.png"]];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];

    UIImageView *sectionIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 5, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:146/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:141/3 currentSuperviewDeviceSize:screenBounds.size.width])];
//    if (section == 4) {
//        sectionIcon.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 5, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:141/3 currentSuperviewDeviceSize:screenBounds.size.width]);
//    }
    [sectionIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[helpSubSectionIconsArray objectAtIndex:indexPath.row]]]];
    sectionIcon.center=CGPointMake(sectionIcon.center.x, cellView.center.y);
    [cellView addSubview:sectionIcon];
    
    UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(sectionIcon.frame.size.width+sectionIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:500/3 currentSuperviewDeviceSize:screenBounds.size.width],cellView.frame.size.height)];
    headerlabel.backgroundColor=[UIColor clearColor];
    headerlabel.textColor=[UIColor whiteColor];
    headerlabel.text=[NSString stringWithFormat:@"%@",[helpSubSectionsArray objectAtIndex:indexPath.row]];
    headerlabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:XbH1size];
    [cellView addSubview:headerlabel];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [helpSubSectionsArray count];
    }
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView *myHeader =[[UITableViewHeaderFooterView alloc]init];
    if(myHeader == nil)
    {
        myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    }
    else
    {
        UIImageView *headerBase=(UIImageView*)[myHeader viewWithTag:200+section];
        [headerBase removeFromSuperview];
        headerBase=nil;
    }
    CGRect frame = [tableView rectForSection:section];
    UIImageView *headerView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    headerView.tag=200+section;
    headerView.backgroundColor=[UIColor colorWithRed:6.0/255 green:24.0/255 blue:44.0/255 alpha:1.0];
    [headerView setImage:[UIImage imageNamed:@"nav_1.png"]];
    
    UIImageView *sectionIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 5, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:146/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:141/3 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sectionIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[sectionsIconsArray objectAtIndex:section]]]];
    sectionIcon.center=CGPointMake(sectionIcon.center.x, headerView.center.y);
    [headerView addSubview:sectionIcon];
    
    UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(sectionIcon.frame.size.width+sectionIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], 0,headerView.frame.size.width-(sectionIcon.frame.size.width+sectionIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width]),headerView.frame.size.height)];
    headerlabel.backgroundColor=[UIColor clearColor];
    headerlabel.textColor=[UIColor whiteColor];
    headerlabel.text=[NSString stringWithFormat:@"%@",[sectionsArray objectAtIndex:section]];
    headerlabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:XbH1size];
    [headerView addSubview:headerlabel];
    if (section == 4) {
        sectionIcon.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 5, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:141/3 currentSuperviewDeviceSize:screenBounds.size.width]);
        sectionIcon.center=CGPointMake(sectionIcon.center.x, headerView.center.y);
        headerlabel.frame=CGRectMake(sectionIcon.frame.size.width+sectionIcon.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:90/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:500/3 currentSuperviewDeviceSize:screenBounds.size.width],headerView.frame.size.height);
    }
    if (section == 0) {
        UIImageView *plusIndicator=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(115+30)/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:57/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:31/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        plusIndicator.tag=300;
        plusIndicator.center=CGPointMake(plusIndicator.center.x, headerView.center.y);
        [plusIndicator setImage:[UIImage imageNamed:@"down_arrow.png"]];
        [headerView addSubview:plusIndicator];
    }
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [headerView addSubview:separatorLine];
    
    [myHeader addSubview:headerView];
    myHeader.tag=headerView.tag;
    return myHeader;
    /*static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView *myHeader =[[UITableViewHeaderFooterView alloc]init];
    if(myHeader == nil)
    {
        myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    }
    else
    {
        UIImageView *headerBase=(UIImageView*)[myHeader viewWithTag:200+section];
        [headerBase removeFromSuperview];
        headerBase=nil;
    }
    //    static NSString *HeaderIdentifier = @"header";
    //
    //    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    //    if(!myHeader) {
    //        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
    //    }
    CGRect frame = [tableView rectForSection:section];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:240/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    headerView.tag=200+section;
    headerView.backgroundColor=[UIColor blueColor];
//    [headerView setImage:[UIImage imageNamed:@"nav_1.png"]];
    UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200/3 currentSuperviewDeviceSize:screenBounds.size.width],headerView.frame.size.height)];
    headerlabel.backgroundColor=[UIColor redColor];
    headerlabel.textColor=[UIColor whiteColor];
//    headerlabel.text=[NSString stringWithFormat:@"Lane %d",[[[lanesSummaryArray objectAtIndex:section] objectForKey:@"laneNumber"] intValue]];
    headerlabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerlabel];
    UIImageView *plusIndicator=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:(115+30)/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    plusIndicator.tag=300;
    if ([openSectionsArray containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
        [plusIndicator setImage:[UIImage imageNamed:@"minus.png"]];
    }
    else
    {
        [plusIndicator setImage:[UIImage imageNamed:@"plus.png"]];
    }
    [headerView addSubview:plusIndicator];
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [headerView addSubview:separatorLine];
    [myHeader addSubview:headerView];
    myHeader.tag=headerView.tag;
    return myHeader;*/

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(mainWebView)
        {
            [mainWebView removeFromSuperview];
            mainWebView.delegate=nil;
            mainWebView=nil;
        }
        mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
        mainWebView.delegate=self;
        NSURL *url;

        if(indexPath.row == 0)
        {
            //tutorials
            url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=tutorials&VenueId=15103"];
        }
        
        if(indexPath.row == 1)
        {
            url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=rules&VenueId=15103"];
        }
        
        if(indexPath.row == 2)
        {
            url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=support&VenueId=15103"];
        }
        
        if(indexPath.row == 3)
        {
            url = [NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=faq&VenueId=15103"];
        }
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [mainWebView loadRequest:requestObj];
        [self addSubview:mainWebView];
        
        footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
        //    [footerViewForWebview setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
        footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [closeButton setTitle:@"Done" forState:UIControlStateNormal];
        closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        closeButton.frame = CGRectMake(self.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
        closeButton.tintColor = [UIColor whiteColor];
        closeButton.layer.borderWidth=0.2;
        closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
        [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
        [footerViewForWebview addSubview:closeButton];
        
        [self addSubview:footerViewForWebview];

    }
    
}

#pragma mark - Expandable TableView Delegate Methods
- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    if (sectionIndex == 0) {
        [openSectionsArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
    }
    else{
        [self showWebView:sectionIndex];
    }
}

- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view
{
    [openSectionsArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)sectionIndex]];
}

#pragma mark - WebView
- (void)showWebView:(NSUInteger)section
{
    if(mainWebView)
    {
        [mainWebView removeFromSuperview];
        mainWebView.delegate=nil;
        mainWebView=nil;
        [footerViewForWebview removeFromSuperview];
        footerViewForWebview=nil;
    }
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    mainWebView.delegate=self;
    NSURL *url;
    if(section == 1)
    {
        NSLog(@"feedback called");
        url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=feedback&VenueId=15103"];
        
    }
    
    if(section == 2)
    {
        url = [NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=aboutus&VenueId=15103"];
    }
    
    if(section == 3)
    {
        
        url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=terms&VenueId=15103"];
    }
    
    if(section == 4)
    {
        url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=privacy&VenueId=15103"];
    }
    
    if(section == 5)
    {
        url=[NSURL URLWithString:@"http://xbowling-mobile.trafficmanager.net/Home/Generic?Name=copyright&VenueId=15103"];
    }
    
    NSLog(@"url=%@",url);
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mainWebView loadRequest:requestObj];
    [self addSubview:mainWebView];
    
    footerViewForWebview=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height])];
    //    [footerViewForWebview setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    footerViewForWebview.backgroundColor=[UIColor colorWithRed:51/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"Done" forState:UIControlStateNormal];
    closeButton.titleLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
    closeButton.frame = CGRectMake(self.frame.size.width-80,0,70, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:screenBounds.size.height]);
    closeButton.tintColor = [UIColor whiteColor];
    closeButton.layer.borderWidth=0.2;
    closeButton.layer.borderColor=(__bridge CGColorRef)([UIColor blueColor]);
    [closeButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
    [footerViewForWebview addSubview:closeButton];
    
    [self addSubview:footerViewForWebview];
}

#pragma mark - WebView Methods
-(void)dismissWebView
{
    [footerViewForWebview removeFromSuperview];
    footerViewForWebview=nil;
    
    [mainWebView loadHTMLString:@"" baseURL:nil];
    [mainWebView stopLoading];
    [mainWebView setDelegate:nil];
    
    [mainWebView removeFromSuperview];
    mainWebView=nil;
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[DataManager shared]removeActivityIndicator];
}

-(void)webViewDidFinishLoad:(UIWebView *) portal
{
    [[DataManager shared]removeActivityIndicator];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //    [self performSelector:@selector(removeIndicator) withObject:nil afterDelay:1.2];
}

@end
