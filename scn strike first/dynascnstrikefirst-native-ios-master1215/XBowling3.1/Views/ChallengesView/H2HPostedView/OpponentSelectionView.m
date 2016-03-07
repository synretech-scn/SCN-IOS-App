//
//  OpponentSelectionView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/10/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "OpponentSelectionView.h"

@implementation OpponentSelectionView
{
     UITextField *searchBar;
    NSMutableArray *playersArray;
    NSMutableDictionary *selectedOpponentDict;
    int selectedOpponentIndex;
    BOOL showfriends;
    NSString *challengeType;
    UITableView *playersTable;
    UILabel *headerLabel;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selectedOpponentIndex=9999;
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
        
        headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
        headerLabel.backgroundColor=[UIColor clearColor];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.textColor=[UIColor whiteColor];
        headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [headerView addSubview:headerLabel];
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
        
        NSArray *itemArray = [NSArray arrayWithObjects: @"All XBowlers",@"My Friends",  nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.tag=16000;
        segmentedControl.frame = CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:800/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:115/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = 0;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    nil];
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *highlightedAttributes =[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:AvenirRegular size:XbH2size], NSFontAttributeName,
                                              [UIColor whiteColor], NSForegroundColorAttributeName,
                                              nil];
        [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
//        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
        [self addSubview:segmentedControl];
        
        UIButton *nextButton=[[UIButton alloc]init];
        [nextButton setFrame:CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width]), headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:300/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:110/3 currentSuperviewDeviceSize:self.frame.size.height])];
        nextButton.layer.cornerRadius=nextButton.frame.size.height/2;
        nextButton.clipsToBounds=YES;
        [nextButton setBackgroundImage:[[DataManager shared]setColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:250.0/255 alpha:1.0] buttonframe:nextButton.frame] forState:UIControlStateNormal];
        [nextButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:nextButton.frame] forState:UIControlStateHighlighted];
        nextButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextButton setTitle:@"Next" forState:UIControlStateNormal];
        nextButton.contentEdgeInsets=UIEdgeInsetsMake(2.0, 0.0, 0.0, 0.0);
        //        [nextButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
        //    nextButton.hidden=YES;
        [nextButton addTarget:self action:@selector(selectOpponentFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        UIView *separatorImage=[[UIView alloc]init];
        separatorImage.frame=CGRectMake(0, segmentedControl.frame.size.height+segmentedControl.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, 0.5);
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
//        if(showfriends == NO)
//        {
//            allXBowlersBtn.selected=YES;
//        }
//        else
//        {
//            myFriendsBtn.selected=YES;
//            
//        }
//        if (search) {
//            searchBar.text=[NSString stringWithFormat:@"%@",search];
//            [searchBar becomeFirstResponder];
//        }
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
        [self addSubview:searchBar];
        [searchBar endEditing:YES];

        UIView *separatorImage2=[[UIView alloc]init];
        separatorImage2.tag=102;
        separatorImage2.frame=CGRectMake(0, searchBar.frame.size.height+searchBar.frame.origin.y-1, self.frame.size.width, 0.5);
        separatorImage2.backgroundColor=separatorColor;
        [self addSubview:separatorImage2];
        
        //Select Opponent
        UIButton *selectOpponentButton=[[UIButton alloc]init];
        selectOpponentButton.tag=15000;
        selectOpponentButton.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [selectOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [selectOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [selectOpponentButton addTarget:self action:@selector(selectOpponentFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectOpponentButton];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, selectOpponentButton.frame.size.width, selectOpponentButton.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"      Select Opponent";
        titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height] ];
        [selectOpponentButton addSubview:titleLabel];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(selectOpponentButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, selectOpponentButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [selectOpponentButton addSubview:arrow];
        
    }
    return self;
}

- (void)displayPlayers:(NSMutableArray *)players searchString:(NSString *)search showingFreinds:(int)showFriends challengeType:(NSString *)type
{
    challengeType=type;
    if ([challengeType isEqualToString:@"H2HPosted"]) {
        headerLabel.text=@"H2H Posted";
    }
    else{
        headerLabel.text=@"H2H Live";
    }
    playersArray=[[NSMutableArray alloc]initWithArray:players];
    if ([players count] == 0) {
        [searchBar removeFromSuperview];
        UIView *separator1=(UIView *)[self viewWithTag:101];
        [separator1 removeFromSuperview];
        UIView *separator2=(UIView *)[self viewWithTag:102];
        [separator2 removeFromSuperview];

        UILabel *noFriendsLabel=[[UILabel alloc]init];
        noFriendsLabel.tag=4500;
        noFriendsLabel.textColor = [UIColor whiteColor];
        noFriendsLabel.textAlignment=NSTextAlignmentCenter;
        noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
        noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
        noFriendsLabel.lineBreakMode= NSLineBreakByWordWrapping;
        noFriendsLabel.numberOfLines=2;
        if ([challengeType isEqualToString:@"H2HPosted"]) {
        noFriendsLabel.text=@"No opponents are currently available.";
        }
        else
            noFriendsLabel.text=@"No live games are currently available.";

        [self addSubview:noFriendsLabel];
        
    }
    else
    {
        playersTable=[[UITableView alloc]init];
        playersTable.frame=CGRectMake(0, searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:71 currentSuperviewDeviceSize:screenBounds.size.height]));
        NSLog(@"self.frame.size.height=%f playersTable.frame.origin.y=%f",self.frame.size.height,playersTable.frame.origin.y);
        playersTable.backgroundColor=[UIColor clearColor];
        playersTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        playersTable.delegate=self;
        playersTable.dataSource=self;
        [self addSubview:playersTable];
    }
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 1)
    {
        // code for the My friends button
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:kUserAccessToken]];
            token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *urlString;
            if ([challengeType isEqualToString:@"H2HPosted"]) {
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/posted/available/friends?bowlingGameId=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],  APIKey, token];
            }
            else{
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/live/available/friends?bowlingGameId=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],  APIKey, token];
            }
            
            NSLog(@"urlString %@",urlString);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:kTimeoutInterval];
            [request setHTTPMethod: @"GET"];
            NSError *error;
            NSHTTPURLResponse *urlResponse = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            if (data)
            {
                playersArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                dispatch_async( dispatch_get_main_queue(), ^{
                     [[DataManager shared] removeActivityIndicator];
                    NSLog(@"responseeeee %lu",(unsigned long)playersArray.count);
                    showfriends=YES;
                    [playersTable reloadData];
                    UILabel *noteLabel=(UILabel *)[self viewWithTag:4500];
                    [noteLabel removeFromSuperview];
                    if (playersArray.count == 0) {
                        UILabel *noFriendsLabel=[[UILabel alloc]init];
                        noFriendsLabel.tag=4500;
                        noFriendsLabel.textColor = [UIColor whiteColor];
                        noFriendsLabel.textAlignment=NSTextAlignmentCenter;
                        noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                        noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
                        noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
                        noFriendsLabel.lineBreakMode= NSLineBreakByWordWrapping;
                        noFriendsLabel.numberOfLines=2;
                        noFriendsLabel.text=@"No opponents are currently available.";
//                        noFriendsLabel.backgroundColor=[UIColor redColor];
                        [self addSubview:noFriendsLabel];
                    }
                });
            }
        });
    }
    else{
        //code for all xbowlers button
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:kUserAccessToken]];
            token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            NSString *urlString;
            if ([challengeType isEqualToString:@"H2HPosted"]) {
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/posted/available?bowlingGameId=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],  APIKey, token];
            }
            else{
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/live/available?bowlingGameId=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],  APIKey, token];
                
            }
            NSLog(@"urlString %@",urlString);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:kTimeoutInterval];
            
            [request setHTTPMethod: @"GET"];
            NSError *error;
            NSHTTPURLResponse *urlResponse = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            if (data)
            {
                playersArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"opponentsArray %@", playersArray);
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    [[DataManager shared] removeActivityIndicator];
                    showfriends=NO;
                    [playersTable reloadData];
                    UILabel *noteLabel=(UILabel *)[self viewWithTag:4500];
                    [noteLabel removeFromSuperview];
                    if (playersArray.count == 0) {
                        UILabel *noFriendsLabel=[[UILabel alloc]init];
                        noFriendsLabel.tag=4500;
                        noFriendsLabel.textColor = [UIColor whiteColor];
                        noFriendsLabel.textAlignment=NSTextAlignmentCenter;
                        noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                        noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
                        noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
                        noFriendsLabel.lineBreakMode= NSLineBreakByWordWrapping;
                        noFriendsLabel.numberOfLines=2;
                        noFriendsLabel.text=@"No opponents are currently available.";
//                        noFriendsLabel.backgroundColor=[UIColor redColor];
                        [self addSubview:noFriendsLabel];
                    }

                });
            }
        });

    }
}

#pragma mark - Reload Table
-(void)reloadOpponentsTable
{
    selectedOpponentIndex=9999;
    [playersTable reloadData];
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
    
    UIButton *baseBtn=[[UIButton alloc]init];
    baseBtn.tag=1500 + indexPath.row;
//    if(screenBounds.size.height == 480)
//        baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:660/3 currentSuperviewDeviceSize:screenBounds.size.width] , 27);
//    else
    baseBtn.frame=CGRectMake(0, 0,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height);
    [baseBtn setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
    [baseBtn setImage:[UIImage imageNamed:@"checked_box.png"] forState:UIControlStateSelected];
    [baseBtn setBackgroundColor:[UIColor clearColor]];
    [baseBtn setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:45/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:4/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    [baseBtn addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:baseBtn];
    if ((baseBtn.tag - 1500) == selectedOpponentIndex) {
        baseBtn.selected=YES;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
   
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.height] , [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height/2-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.height])];
    nameLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.text=[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cellView addSubview:nameLabel];
    
      UILabel *gameNameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], nameLabel.frame.size.height+nameLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height/2-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height])];
    gameNameLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
    gameNameLabel.textColor=[UIColor whiteColor];
    gameNameLabel.backgroundColor=[UIColor clearColor];
    gameNameLabel.text=[NSString stringWithFormat:@"%@",[[playersArray objectAtIndex:indexPath.row] objectForKey:@"creatorUserName"]];
    [cellView addSubview:gameNameLabel];
    
    
    [paragraphStyle setLineSpacing:7];
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:702/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    
    // Display score in standard format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    NSString *formattedString;
    if ([challengeType isEqualToString:@"H2HPosted"]) {
        formattedString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[playersArray objectAtIndex:indexPath.row] objectForKey:@"creatorHandicap"] floatValue]]];
    }
    else{
        formattedString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[playersArray objectAtIndex:indexPath.row] objectForKey:@"creditWager"] floatValue]]];
    }
    
    NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",formattedString] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    
    NSMutableAttributedString *frameLabelText;
     if ([challengeType isEqualToString:@"H2HPosted"]) {
         frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Handicap"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
     }
     else{
         frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Credits"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];

     }
 
    [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
    [latestPlayedFrameAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [latestPlayedFrameAttributedString length])];
    
    frameLabel.attributedText=latestPlayedFrameAttributedString;
    frameLabel.backgroundColor=[UIColor clearColor];
    frameLabel.textColor=[UIColor whiteColor];
    frameLabel.textAlignment=NSTextAlignmentCenter;
    frameLabel.numberOfLines=0;
    [cellView addSubview:frameLabel];
    
    UILabel *expiryLabel=[[UILabel alloc]initWithFrame:CGRectMake(frameLabel.frame.size.width+frameLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:230/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    
    // Display score in standard format
    NSMutableAttributedString *expiryDateAttributedString,*expiryLabelText;
    if ([challengeType isEqualToString:@"H2HPosted"]) {
        expiryDateAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self differenceFromCurrentDate:[[playersArray objectAtIndex:indexPath.row] objectForKey:@"expirationDateTime"]]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    
        expiryLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Expires"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    }
    else{
        int credits,rewards;
        credits = (int)[[[playersArray objectAtIndex:indexPath.row] objectForKey:@"creditWager"] integerValue];
        switch (credits) {
            case 10:
                rewards = 700;
                break;
                
            case 25:
                rewards = 1800;
                break;
                
            case 50:
                rewards = 3700;
                break;
                
            case 100:
                rewards = 7600;
                break;
                
            case 500:
                rewards = 40000;
                break;
                
            case 1000:
                rewards = 90000;
                break;
                
            default:
                rewards = 0;
                break;
        }

        expiryDateAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",rewards] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        
        expiryLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Rewards"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    }

    [expiryDateAttributedString appendAttributedString:expiryLabelText];
    [expiryDateAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [expiryDateAttributedString length])];
    
    expiryLabel.attributedText=expiryDateAttributedString;
    expiryLabel.backgroundColor=[UIColor clearColor];
    expiryLabel.textColor=[UIColor whiteColor];
    expiryLabel.textAlignment=NSTextAlignmentCenter;
    expiryLabel.numberOfLines=0;
    [cellView addSubview:expiryLabel];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
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

#pragma mark - UITableview Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (void)backButtonFunction
{
    [delegate removeOpponentSelectionView];
}

#pragma mark - Opponent Selection
- (void)checkboxSelected:(UIButton *)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        selectedOpponentDict=nil;
        selectedOpponentIndex=9999;
    }
    else{
        sender.selected=YES;
        selectedOpponentDict=[[NSMutableDictionary alloc]initWithDictionary:[playersArray objectAtIndex:(sender.tag - 1500)]];
        selectedOpponentIndex=(int)(sender.tag - 1500);
    }
    for (int i=0; i<playersArray.count; i++) {
        if (1500+i != sender.tag) {
            UIButton *checkboxBtn=(UIButton *)[self viewWithTag:1500+i];
            checkboxBtn.selected=NO;
        }
    }
}

- (void)selectOpponentFunction:(UIButton *)sender
{
    if (selectedOpponentDict.count > 0) {
        [[DataManager shared]activityIndicatorAnimate:@"Loading..."];
        [delegate selectedOpponent:selectedOpponentDict];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Tap the box beside an opponent. You must select an opponent before you can continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

#pragma mark - Get Hours Difference between Dates
- (NSString *)differenceFromCurrentDate:(NSString *)givenDate
{
    NSString *difference;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date= [[givenDate componentsSeparatedByString:@"T"] objectAtIndex:0];
    NSString *time= [[givenDate componentsSeparatedByString:@"T"] objectAtIndex:1];
    NSLog(@"date==%@ ==time==%@",date,time);
    NSString*full=[[date stringByAppendingString:@" "] stringByAppendingString:time];
    NSLog(@"full==%@",full);
    NSDate *given=[[NSDate alloc]init];
    given=[dateFormat dateFromString:full];
    NSDate *current=[NSDate date];
    NSString *dateString = [dateFormat stringFromDate:current];
    NSLog(@"date: %@", given);
    NSDate *currentInUTC=[[NSDate alloc]init];
    currentInUTC=[dateFormat dateFromString:dateString];
    NSLog(@"currentInUTC=%@",currentInUTC);
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *components = [c components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSYearCalendarUnit fromDate:currentInUTC toDate:given options:0];
    NSInteger diff = components.hour;
    NSUInteger days = [components day];
    NSUInteger minutes = [components minute];
    NSUInteger years = [components year];
    NSLog(@"calender1=%ld",(long)diff);
    NSLog(@"calender2=%ld",(long)days);
    NSLog(@"calender3=%ld",(long)minutes);
    
    
    if (years > 0) {
        if (years == 1) {
            difference=[NSString stringWithFormat:@"%lu year",(unsigned long)years];
        }
        else{
            difference=[NSString stringWithFormat:@"%lu years",(unsigned long)years];
        }
    }
    else if (days > 0) {
        if (days == 1) {
            difference=[NSString stringWithFormat:@"%lu day",(unsigned long)days];
        }
        else{
            difference=[NSString stringWithFormat:@"%lu days",(unsigned long)days];
        }
    }
    else if (diff == 0) {
        if (minutes == 1) {
            difference=[NSString stringWithFormat:@"%lu min",(unsigned long)minutes];
        }
        else{
            difference=[NSString stringWithFormat:@"%lu mins",(unsigned long)minutes];
        }
    }
    else{
        if (diff == 1) {
            difference=[NSString stringWithFormat:@"%lu hr",(unsigned long)diff];
        }
        else{
            difference=[NSString stringWithFormat:@"%lu hrs",(unsigned long)diff];
        }
    }
    return difference;
}

#pragma mark - UITextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
        [[DataManager shared] activityIndicatorAnimate:@"Loading..."];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSString *token = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:kUserAccessToken]];
            token=[token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            token=[token stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *urlString;
            if(showfriends==YES)
            {
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/posted/available/friends/search?bowlingGameId=%@&search=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],searchBar.text,  APIKey, token];
            }
            else{
                urlString = [NSString stringWithFormat:@"%@bowlinggame/%@/competition/posted/available/search?bowlingGameId=%@&search=%@&apiKey=%@&token=%@", serverAddress,[userDefaults objectForKey:kbowlingGameId],[userDefaults objectForKey:kbowlingGameId],searchBar.text,  APIKey, token];
            }
            
            NSLog(@"urlString %@",urlString);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:kTimeoutInterval];
            
            [request setHTTPMethod: @"GET"];
            
            NSError *error;
            NSHTTPURLResponse *urlResponse = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
            
            if (data)
            {
                playersArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[DataManager shared] removeActivityIndicator];
                    selectedOpponentIndex=9999;
                    [selectedOpponentDict removeAllObjects];
                    [playersTable reloadData];
                    UILabel *noteLabel=(UILabel *)[self viewWithTag:4500];
                    [noteLabel removeFromSuperview];
                    if (playersArray.count == 0) {
                        UILabel *noFriendsLabel=[[UILabel alloc]init];
                        noFriendsLabel.tag=4500;
                        noFriendsLabel.textColor = [UIColor whiteColor];
                        noFriendsLabel.textAlignment=NSTextAlignmentCenter;
                        noFriendsLabel.font =[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:54/3 currentSuperviewDeviceSize:screenBounds.size.height]];
                        noFriendsLabel.frame=CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:20 currentSuperviewDeviceSize:screenBounds.size.width],searchBar.frame.size.height+searchBar.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:screenBounds.size.height],self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], 40);
                        noFriendsLabel.center=CGPointMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:200 currentSuperviewDeviceSize:screenBounds.size.width], self.center.y);
                        noFriendsLabel.lineBreakMode= NSLineBreakByWordWrapping;
                        noFriendsLabel.numberOfLines=2;
                        if ([challengeType isEqualToString:@"H2HPosted"]) {
                            noFriendsLabel.text=@"No opponents are currently available.";

                        }
                        else{
                            noFriendsLabel.text=@"No games are currently available.";

                        }
                        [self addSubview:noFriendsLabel];
                    }

                });
            }
            
        });
    return YES;
}

@end
