//
//  AddFriendsView.m
//  XBowling3.1
//
//  Created by Click Labs on 3/27/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "AddFriendsView.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@implementation AddFriendsView
{
    UITextField *searchBar;
    UILabel *suggestionlabel;
    BOOL searchOn;
    ASIHTTPRequest *searchRequest;
    UITableView *playersTable;
    BOOL showfriends;
    NSMutableArray *myFriendsArray;
    int numberofbowlersdisplayed;
    int ycoordinateForTable;
    NSMutableArray *playersArray;
    NSString *searchXBowler;
    BOOL addLoadMoreButton;
    id<GAITracker> tracker;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Add Friends"
                                                              action:@"Action"
                                                               label:nil
                                                               value:nil] build]];
    }
    return self;
}

- (void)createFriendsView
{
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    //        headerView.frame=CGRectMake(0, 0, self.frame.size.width, 82);
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImage addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.text=@"Friends";
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
    sideNavigationButton.tag=90;
    [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
  [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
    [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sideNavigationButton];
//    sideNavigationButton.backgroundColor=[UIColor blueColor];
    sideNavigationButton.userInteractionEnabled=true;
    [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];

    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:235/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    shareButton.tag=123;
    shareButton.backgroundColor=[UIColor clearColor];
    shareButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
    [shareButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonFunction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:shareButton];
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"All XBowlers",@"My Friends",  nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.tag=15000;
    segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:171/3 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:900/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height]);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmentedControl setContentPositionAdjustment:UIOffsetMake(0, 1) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    [self addSubview:segmentedControl];
    
    ycoordinateForTable=segmentedControl.frame.size.height+segmentedControl.frame.origin.y;
    [self myfriendsbtnMethod];
}

- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
}

- (void)shareButtonFunction
{
    [delegate showShareView];
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    searchBar.text=@"";
    searchXBowler=@"";
    if (segment.selectedSegmentIndex == 0) {
        //all xbowlers
        [self allXBowlersButtonFunction];
    }
    else{
        //friends
        [self myfriendsbtnMethod];
    }
    [playersTable setContentOffset:CGPointZero animated:NO];
}
#pragma mark - my friends functions
-(void)myfriendsbtnMethod
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
     //method called on  myfriendsbtn clicked
    showfriends=YES;
    [self getAllFriends];
    
}

-(void)getAllFriends
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        
        NSString *siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=100",siteurl,token,apiKey];
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            myFriendsArray=[[NSMutableArray alloc]initWithArray:json];
            NSLog(@"json=%@",myFriendsArray);
            numberofbowlersdisplayed=(int)myFriendsArray.count;
            [self showscrollview:myFriendsArray searchString:nil];
            
        }
        else
            [[DataManager shared]removeActivityIndicator];
    }
    
}
#pragma mark - all xbowlers functions

-(void)allXBowlersButtonFunction
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    showfriends=NO;
    [self getAllXBowlers:nil];
    
}
-(void)getAllXBowlers:(NSString *)searchString
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        
        if(searchString == nil)
            searchString=@"";
        searchXBowler=searchString;
        NSString *siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=20&search=%@",siteurl,token,apiKey,[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            NSMutableArray *allXBowlersArray=[[NSMutableArray alloc]initWithArray:json];
            NSLog(@"allXBowlersArray=%@",allXBowlersArray);
            [self showscrollview:allXBowlersArray searchString:nil];
        }
        else
            [[DataManager shared]removeActivityIndicator];
    }
}

// for search
-(void)allXBowlersAsyncCall:(NSString *)searchString
{
    if (searchRequest) {
        [searchRequest clearDelegatesAndCancel];
    }
    NSString *siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSLog(@"token=%@",token);
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=0&pageSize=20&search=%@",siteurl,token,apiKey,[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSLog(@"enquiryurl=%@",enquiryurl);
    
    searchRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:enquiryurl]];
    [searchRequest setDelegate:self];
    [searchRequest startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)ASIrequest
{
    NSLog(@"data=%@",[[NSString alloc]initWithData:[ASIrequest responseData] encoding:NSUTF8StringEncoding] );
    if([ASIrequest responseData])
    {
         NSArray *filteredXbowlersArray = [NSJSONSerialization JSONObjectWithData:[ASIrequest responseData] options:kNilOptions error:nil];
        NSLog(@"jsonnnnnnnnnn: %@", filteredXbowlersArray);
        [[DataManager shared]removeActivityIndicator];
        [self showscrollview:filteredXbowlersArray searchString:searchBar.text];
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

#pragma mark - Reload table
- (void)showscrollview:(NSArray *)displayArray searchString:(NSString *)search
{
    [suggestionlabel removeFromSuperview];
    if (displayArray.count == 0) {
        
        //suggestionlabel;
        [playersTable removeFromSuperview];
        suggestionlabel= [[UILabel alloc]init];
        suggestionlabel.text=@"No friends are currently available.";
        if(showfriends == NO)
            suggestionlabel.text=@"No result found for your search.";
        suggestionlabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
        suggestionlabel.numberOfLines=2;
        suggestionlabel.lineBreakMode=NSLineBreakByWordWrapping;
        suggestionlabel.textColor=[UIColor whiteColor];
        suggestionlabel.textAlignment=NSTextAlignmentCenter;
        [suggestionlabel setFrame:CGRectMake(0,searchBar.frame.size.height + searchBar.frame.origin.y + 40, self.frame.size.width, 18)];
        suggestionlabel.center=self.center;
        [self addSubview:suggestionlabel];
    }
    else{
          playersArray=[[NSMutableArray alloc]initWithArray:displayArray];
        if (!showfriends) {
            numberofbowlersdisplayed=(int)playersArray.count;
            if (playersArray.count == 20) {
                [playersArray addObject:[NSDictionary new]];
                addLoadMoreButton=YES;
            }
        }
        if (![playersTable isDescendantOfView:self]) {
            [searchBar removeFromSuperview];
            UIView *separator1=(UIView *)[self viewWithTag:101];
            [separator1 removeFromSuperview];
            UIView *separator2=(UIView *)[self viewWithTag:102];
            [separator2 removeFromSuperview];

            UIView *separatorImage=[[UIView alloc]init];
            separatorImage.frame=CGRectMake(0, ycoordinateForTable+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, 0.5);
            separatorImage.tag=101;
            separatorImage.backgroundColor=separatorColor;
            [self addSubview:separatorImage];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:110/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:100/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            UIImageView *searchIcon=[[UIImageView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            searchIcon.center=CGPointMake(searchIcon.center.x, paddingView.frame.size.height/2-1);
            [searchIcon setImage:[UIImage imageNamed:@"search_icon.png"]];
            [paddingView addSubview:searchIcon];
            searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0,separatorImage.frame.size.height+separatorImage.frame.origin.y, self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
            searchBar.tag=1550;
            searchBar.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.4];
            searchBar.font = [UIFont fontWithName:AvenirRegular size:XbH1size];
            searchBar.textColor=[UIColor whiteColor];
            searchBar.placeholder = @"Search";
            searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            searchBar.keyboardType = UIKeyboardTypeDefault;
            searchBar.returnKeyType = UIReturnKeyDone;
            searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
            searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            searchBar.delegate = self;
            searchBar.leftView = paddingView;
            searchBar.leftViewMode = UITextFieldViewModeAlways;
            searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchBar.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:AvenirRegular size:XbH1size]}];
            searchBar.text=searchXBowler;
            [self addSubview:searchBar];
            [searchBar endEditing:YES];
            
            UIView *separatorImage2=[[UIView alloc]init];
            separatorImage2.tag=102;
            separatorImage2.frame=CGRectMake(0, searchBar.frame.size.height+searchBar.frame.origin.y-1, self.frame.size.width, 0.5);
            separatorImage2.backgroundColor=separatorColor;
            [self addSubview:separatorImage2];
            
            playersTable=[[UITableView alloc]init];
            playersTable.frame=CGRectMake(0, searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height]));
            NSLog(@"self.frame.size.height=%f playersTable.frame.origin.y=%f",self.frame.size.height,playersTable.frame.origin.y);
            playersTable.backgroundColor=[UIColor clearColor];
            playersTable.separatorStyle=UITableViewCellSeparatorStyleNone;
            playersTable.delegate=self;
            playersTable.dataSource=self;
            [self addSubview:playersTable];
        }
        else{
            searchBar.text=search;
            [playersTable reloadData];
        }
    }

}

#pragma mark - UITableview Data Source Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    if(cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    else
    {
        UIView *cellBckgd=(UIView*)[cell.contentView viewWithTag:100+indexPath.row];
        [cellBckgd removeFromSuperview];
        cellBckgd=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    
    if (!showfriends && indexPath.row == (playersArray.count - 1) && addLoadMoreButton) {
        //add Load more btn
        UIButton *loadmoreBtn=[[UIButton alloc] init];
        loadmoreBtn.frame=CGRectMake(cellView.frame.origin.x+cellView.frame.size.width/2-30,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], 93,28);
        [loadmoreBtn setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3] buttonframe:self.frame] forState:UIControlStateNormal];
        [loadmoreBtn setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.7] buttonframe:self.frame] forState:UIControlStateHighlighted];
        loadmoreBtn.layer.cornerRadius=loadmoreBtn.frame.size.height/2;
        //loadmoreBtn.titleLabel.text=@"Load More";
        loadmoreBtn.center=CGPointMake(cellView.center.x, cellView.center.y);
        loadmoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [loadmoreBtn setTitle: @"Load More" forState: UIControlStateNormal];
        loadmoreBtn.titleLabel.textColor=[UIColor whiteColor];
        [loadmoreBtn addTarget:self action:@selector(loadmorebowlersMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:loadmoreBtn];
//        addLoadMoreButton=NO;
        return cell;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ \nBowling Avg:%@",[[playersArray objectAtIndex:indexPath.row] objectForKey:kScreenName],[[playersArray objectAtIndex:indexPath.row] objectForKey:@"averageScore"]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
    nameLabel.attributedText=nameString;
    NSLog(@"nameText=%@",nameString);
    [cellView addSubview:nameLabel];
    
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:320/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    frameLabel.text=[NSString stringWithFormat:@"%@, %@",[[playersArray objectAtIndex:indexPath.row] objectForKey:@"regionLongName"],[[playersArray objectAtIndex:indexPath.row] objectForKey:@"countryCode"]];
    frameLabel.lineBreakMode=NSLineBreakByWordWrapping;
    frameLabel.numberOfLines=2;
    frameLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    frameLabel.textColor=[UIColor whiteColor];
    frameLabel.backgroundColor=[UIColor clearColor];
    [cellView addSubview:frameLabel];
    
    //add friend btn on  right side
    UIButton *addFriendButton=[[UIButton alloc]init];
    [addFriendButton setFrame:CGRectMake(cellView.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:300/3 currentSuperviewDeviceSize:self.frame.size.width]), 10, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:300/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:self.frame.size.height])];
    addFriendButton.center=CGPointMake(addFriendButton.center.x,cellView.center.y);
    addFriendButton.layer.cornerRadius=addFriendButton.frame.size.height/2;
    addFriendButton.clipsToBounds=YES;
    addFriendButton.tag=1300+indexPath.row;
    addFriendButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    addFriendButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size: [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addFriendButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
    if (showfriends == NO) {
        [addFriendButton setTitle:@"Add" forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:addFriendButton.frame] forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:addFriendButton.frame] forState:UIControlStateHighlighted];
    }
    else{
        addFriendButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        addFriendButton.titleLabel.numberOfLines=2;
        [addFriendButton setFrame:CGRectMake(cellView.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:320/3 currentSuperviewDeviceSize:self.frame.size.width]), 10, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:320/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:self.frame.size.height])];
        addFriendButton.center=CGPointMake(addFriendButton.center.x,cellView.center.y);
        [addFriendButton setTitle:@"Remove" forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:173.0/255.0 green:70.0/255.0 blue:99.0/255.0 alpha:1.0] buttonframe:addFriendButton.frame] forState:UIControlStateNormal];
        [addFriendButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:173.0/255.0 green:70.0/255.0 blue:99.0/255.0 alpha:0.7] buttonframe:addFriendButton.frame] forState:UIControlStateHighlighted];
    }
    [addFriendButton addTarget:self action:@selector(addRemoveFriendFunction:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:addFriendButton];

    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

#pragma mark - Add/Remove friend
-(void)addRemoveFriendFunction:(UIButton *)sender
{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    if(showfriends == YES)
        [self removeFriendServerCall:sender];
    else
        [self addFriendServerCall:sender];
}

-(void)addFriendServerCall:(UIButton *)sender
{
    NSDictionary *postDict;
    int index=(int)sender.tag - 1300;
//    if(searchImplemented == 1)
//    {
//        NSLog(@"allxbowlers=%@",filteredXbowlersArray);
//        postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"countryCode"]],@"countryCode",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"averageScore"]],@"averageScore",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"countryDisplayName"]],@"countryDisplayName",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"friendId"]],@"friendId",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"isFriend"]],@"isFriend",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"regionLongName"]],@"regionLongName",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"regionShortName"]],@"regionShortName",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:@"userId"]],@"userId",[NSString stringWithFormat:@"%@",[[filteredXbowlersArray objectAtIndex:index]objectForKey:kScreenName]],kScreenName, nil];
//        NSLog(@"dict=%@",postDict);
//    }
//    else
//    {
        NSLog(@"allxbowlers=%@",playersArray);
        
        postDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"countryCode"]],@"countryCode",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"averageScore"]],@"averageScore",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"countryDisplayName"]],@"countryDisplayName",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"friendId"]],@"friendId",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"isFriend"]],@"isFriend",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"regionLongName"]],@"regionLongName",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"regionShortName"]],@"regionShortName",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"userId"]],@"userId",[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:kScreenName]],kScreenName, nil];
        NSLog(@"dict=%@",postDict);
        
//    }
    NSError *error = NULL;
    NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString* dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    
    NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
    
    NSString *siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSLog(@"token=%@",token);
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@",siteurl,token,apiKey];
    NSLog(@"enquiryurl=%@",enquiryurl);
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:kTimeoutInterval];
    [URLrequest setHTTPMethod:@"POST"];
    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [URLrequest setHTTPBody:postdata];
    
    NSError *error2=nil;
    NSHTTPURLResponse *response=nil;
    NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                 encoding:NSUTF8StringEncoding]);
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
    if(responseData)
    {
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 201)
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *addFriendAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Added successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [addFriendAlert show];
            //        [sender setImage:[UIImage imageNamed:@"remove_friend_off.png"] forState:UIControlStateNormal];
            //        [sender setImage:[UIImage imageNamed:@"remove_friend_on.png"] forState:UIControlStateHighlighted];
            //        [sender addTarget:self action:@selector(removeFriendServerCall:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [[DataManager shared]removeActivityIndicator];
            UIAlertView *addFriendAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Already added as your friend." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [addFriendAlert show];
        }
        
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *addFriendAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"An error occurred while adding this friend. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [addFriendAlert show];
        
    }
    
}

-(void)removeFriendServerCall:(UIButton *)sender
{
    NSLog(@"friendsarray=%@",myFriendsArray);
    int index=(int)sender.tag - 1300;
    NSString *friendId;
//    if(searchImplemented == 1)
//        friendId=[NSString stringWithFormat:@"%@",[[filteredFriendsArray objectAtIndex:index]objectForKey:@"friendId"]];
//    else
    friendId=[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:index]objectForKey:@"friendId"]];
    
    NSDictionary *postDict=[[NSDictionary alloc]initWithObjectsAndKeys:friendId,@"id", nil];
    NSLog(@"dict=%@",postDict);
    NSError *error = NULL;
    NSData* data = [NSJSONSerialization dataWithJSONObject:postDict
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    NSString* dataString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    NSData *postdata=[dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postlength=[NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
     NSString *siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
    token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
    NSLog(@"token=%@",token);
    NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@",siteurl,token,apiKey];
    NSLog(@"enquiryurl=%@",enquiryurl);
    NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                        timeoutInterval:kTimeoutInterval];
    [URLrequest setHTTPMethod:@"DELETE"];
    [URLrequest setValue:postlength forHTTPHeaderField:@"Content-Length"];
    [URLrequest setHTTPBody:postdata];
    
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSError *error2=nil;
    NSHTTPURLResponse *response=nil;
    NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                 encoding:NSUTF8StringEncoding]);
    NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
    NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSLog(@"statusCode=%ld",(long)response.statusCode);
    if(response.statusCode == 200 && responseData)
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Removed successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [self getAllFriends];
    }
    else
    {
        [[DataManager shared]removeActivityIndicator];
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"An error occurred. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    
}

#pragma mark - Load More Players
-(void)loadmorebowlersMethod:(UIButton *)sender{
    [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
    int difference;
    difference=10;
//    if(bowlersArray.count<numberofbowlersdisplayed){
//        difference=(int)numberofbowlersdisplayed-(int)bowlersArray.count;
//        numberofbowlersdisplayed=(int)bowlersArray.count;
//    }
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        [[DataManager shared] removeActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Could not connect to the server, please check your internet connection !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
    else
    {
        NSString *siteurl;
        if(searchXBowler.length == 0)
        {
            searchXBowler=@"";
            siteurl = [NSString stringWithFormat:@"%@friend/available",serverAddress];
        }
        else
        {
            siteurl = [NSString stringWithFormat:@"%@friend",serverAddress];
        }
        NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:kUserAccessToken]];
        token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString *apiKey =[NSString stringWithFormat:@"%@",APIKey];
        NSLog(@"token=%@",token);
        NSString *enquiryurl = [NSString stringWithFormat:@"%@?token=%@&apiKey=%@&startIndex=%d&pageSize=20&search=%@",siteurl,token,apiKey,numberofbowlersdisplayed,searchXBowler];
        NSLog(@"enquiryurl=%@",enquiryurl);
        NSMutableURLRequest *URLrequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:enquiryurl]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:kTimeoutInterval];
        [URLrequest setHTTPMethod:@"GET"];
        [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error2=nil;
        NSHTTPURLResponse *response=nil;
        NSLog(@"urlRequest=%@",[[NSString alloc] initWithData:[URLrequest HTTPBody]
                                                     encoding:NSUTF8StringEncoding]);
        NSData *responseData=[NSURLConnection sendSynchronousRequest:URLrequest returningResponse:&response error:&error2];
        NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString = %@",responseString);
        NSLog(@"statusCode=%ld",(long)response.statusCode);
        if(response.statusCode == 200 && responseData)
        {
            [[DataManager shared]removeActivityIndicator];
            NSError *jsonError=nil;
            NSArray *json=[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            [playersArray removeObjectAtIndex:playersArray.count-1];
             [playersArray addObjectsFromArray:json];
            [self showscrollview:playersArray searchString:searchXBowler];
        }
    }
}

#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    searchOn=YES;
    searchXBowler=textField.text;
    addLoadMoreButton=NO;
    [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
    if(textField.text.length > 0)
    {
        if(showfriends)
        {
            NSMutableArray *filteredFriendsArray=[[NSMutableArray alloc]init];
            for (NSDictionary* friend in myFriendsArray)
            {
                NSLog(@"friend=%@",friend);
                NSString *friendName=[friend objectForKey:kScreenName];
                NSRange nameRange = [friendName rangeOfString:textField.text options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound)
                {
                    [filteredFriendsArray addObject:friend];
                }
            }
            [self showscrollview:filteredFriendsArray searchString:textField.text];
            
            [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:0.5];
            
        }
        else
        {

            [textField resignFirstResponder];
            
            NSLog(@"searchString=%@",textField.text);
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            [self allXBowlersAsyncCall:textField.text];
        }
    }
    else{
        if(showfriends)
        {
            [self showscrollview:myFriendsArray searchString:textField.text];
            [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:0.5];
        }
        else{
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            [self allXBowlersAsyncCall:textField.text];
        }
    }
    [searchBar resignFirstResponder];
    return YES;
}
-(void)removeActivityIndicator
{
    [[DataManager shared]removeActivityIndicator];
}
@end
