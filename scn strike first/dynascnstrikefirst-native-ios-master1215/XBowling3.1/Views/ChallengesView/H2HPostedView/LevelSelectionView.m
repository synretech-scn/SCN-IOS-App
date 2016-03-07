//
//  LevelSelectionView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/11/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "LevelSelectionView.h"

@implementation LevelSelectionView
{
    NSArray *creditsArray;
    NSArray *pointsArray;
    NSUInteger selectedLevel;
    UILabel *creditsBalanceLabel;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selectedLevel=9999;
        creditsArray=[[NSArray alloc]initWithObjects:@"Free",@"10",@"25",@"50",@"100",@"500",@"1000", nil];
        pointsArray=[[NSArray alloc]initWithObjects:@"Glory",@"1,000",@"3,200",@"6,500",@"14,000",@"75,000",@"170,000", nil];
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
        headerLabel.text=@"H2H Posted";
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
        
//        UIButton *enterButton=[[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
//        enterButton.backgroundColor=[UIColor clearColor];
//        enterButton.titleLabel.font = [UIFont fontWithName:AvenirRegular size:XbH2size];
//        enterButton.titleLabel.numberOfLines=2;
//        [enterButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
//        [enterButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        enterButton.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
////        enterButton.titleLabel.text=@"Enter\nChallenge";
//        [enterButton setTitle:@"Enter\nChallenge" forState:UIControlStateNormal];
//        [enterButton setTitleColor:XBWhiteTitleButtonNormalStateColor forState:UIControlStateNormal];
//        [enterButton setTitleColor:XBWhiteTitleButtonHighlightedStateColor forState:UIControlStateHighlighted];
//        [enterButton addTarget:self action:@selector(selectLevelFunction:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:enterButton];

        creditsBalanceLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:230 currentSuperviewDeviceSize:self.frame.size.width],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:25 currentSuperviewDeviceSize:self.frame.size.height])];
        creditsBalanceLabel.backgroundColor=[UIColor clearColor];
        creditsBalanceLabel.textColor=[UIColor whiteColor];
        creditsBalanceLabel.text=@"Credits Balance:";
        creditsBalanceLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [self addSubview:creditsBalanceLabel];
        
//        UIButton *buyCreditsButton=[[UIButton alloc]init];
//        [buyCreditsButton setFrame:CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.width]), headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
//        buyCreditsButton.layer.cornerRadius=buyCreditsButton.frame.size.height/2;
//        buyCreditsButton.clipsToBounds=YES;
//        [buyCreditsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:buyCreditsButton.frame] forState:UIControlStateNormal];
//        [buyCreditsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:buyCreditsButton.frame] forState:UIControlStateHighlighted];
//        buyCreditsButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
//        [buyCreditsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [buyCreditsButton setTitle:@"Buy Credits" forState:UIControlStateNormal];
//        buyCreditsButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 2.0, 0.0, 0.0);
////        [buyCreditsButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
//        //    buyCreditsButton.hidden=YES;
//        [buyCreditsButton addTarget:self action:@selector(buyCreditsButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buyCreditsButton];
        
        UIButton *buyCreditsButton=[[UIButton alloc]init];
        [buyCreditsButton setFrame:CGRectMake(0, creditsBalanceLabel.frame.size.height+creditsBalanceLabel.frame.origin.y, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:360/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:130/3 currentSuperviewDeviceSize:self.frame.size.height])];
//        [buyCreditsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:buyCreditsButton.frame] forState:UIControlStateNormal];
//        [buyCreditsButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:buyCreditsButton.frame] forState:UIControlStateHighlighted];
        buyCreditsButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Buy Credits"];
        [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH2size] range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,[commentString length])];
        [buyCreditsButton setAttributedTitle:commentString forState:UIControlStateNormal];
        NSMutableAttributedString *highlightedString = [[NSMutableAttributedString alloc] initWithString:@"Buy Credits"];
        [highlightedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:AvenirRegular size:XbH2size] range:NSMakeRange(0, [highlightedString length])];
        [highlightedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [highlightedString length])];
         [highlightedString addAttribute:NSForegroundColorAttributeName value:XBWhiteTitleButtonHighlightedStateColor range:NSMakeRange(0,[highlightedString length])];
         [buyCreditsButton setAttributedTitle:highlightedString forState:UIControlStateHighlighted];
        [buyCreditsButton addTarget:self action:@selector(buyCreditsButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buyCreditsButton];
        
        
        UIButton *enterButton=[[UIButton alloc]init];
        [enterButton setFrame:CGRectMake(self.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:470/3 currentSuperviewDeviceSize:self.frame.size.width]), headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40/3 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:470/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
        enterButton.layer.cornerRadius=enterButton.frame.size.height/2;
        enterButton.clipsToBounds=YES;
        [enterButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:buyCreditsButton.frame] forState:UIControlStateNormal];
        [enterButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:buyCreditsButton.frame] forState:UIControlStateHighlighted];
        enterButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [enterButton setTitle:@"Enter Challenge" forState:UIControlStateNormal];
        enterButton.contentEdgeInsets=UIEdgeInsetsMake(2.5, 2.0, 0.0, 0.0);
        //        [buyCreditsButton setBackgroundColor:[UIColor colorWithRed:0.0/255 green:118.0/255 blue:254.0/255 alpha:0.6]];
        //    buyCreditsButton.hidden=YES;
        [enterButton addTarget:self action:@selector(selectLevelFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enterButton];
        
        UITableView *levelTable=[[UITableView alloc]init];
        levelTable.frame=CGRectMake(0, buyCreditsButton.frame.size.height+buyCreditsButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:20/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (buyCreditsButton.frame.size.height+buyCreditsButton.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:71 currentSuperviewDeviceSize:screenBounds.size.height]));
        NSLog(@"self.frame.size.height=%f levelTable.frame.origin.y=%f",self.frame.size.height,levelTable.frame.origin.y);
        levelTable.backgroundColor=[UIColor clearColor];
        levelTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        levelTable.delegate=self;
        levelTable.dataSource=self;
        [self addSubview:levelTable];
        
        //Select Level
        UIButton *selectLevelButton=[[UIButton alloc]init];
        selectLevelButton.tag=15000;
        selectLevelButton.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [selectLevelButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [selectLevelButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [selectLevelButton addTarget:self action:@selector(selectLevelFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectLevelButton];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, selectLevelButton.frame.size.width, selectLevelButton.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"      Enter Challenge";
        titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size ];
        [selectLevelButton addSubview:titleLabel];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(selectLevelButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, selectLevelButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [selectLevelButton addSubview:arrow];
        
    }
    return self;
}

- (void)getCredits
{
    NSDictionary *creditsDict = [delegate userCredits];
    creditsBalanceLabel.text=[NSString stringWithFormat:@"Credits Balance: %ld",(long)[[creditsDict objectForKey:@"credits"] integerValue]];

}
- (void)buyCreditsButtonFunction:(UIButton *)sender
{
    [delegate showBuyCreditsView];
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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, cellView.frame.size.width, frame.size.height)];
    //    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Level %ld",(long)indexPath.row] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH1size]}];
   
    NSMutableAttributedString *nameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" \nWin Glory | Free"] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    if (indexPath.row > 0) {
        nameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" \nWin %@ Points | %@ Credits",[pointsArray objectAtIndex:indexPath.row],[creditsArray objectAtIndex:indexPath.row]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    }
    [nameString appendAttributedString:nameLabelText];
    [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
    nameLabel.attributedText=nameString;
//    NSLog(@"nameText=%@",nameString);
    [cellView addSubview:nameLabel];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:174/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
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

#pragma mark - Opponent Selection
- (void)checkboxSelected:(UIButton *)sender
{
    if ([sender isSelected]) {
        sender.selected=NO;
        selectedLevel=9999;
    }
    else{
        sender.selected=YES;
        selectedLevel=sender.tag - 1500;

    }
    for (int i=0; i<pointsArray.count; i++) {
        if (1500+i != sender.tag) {
            UIButton *checkboxBtn=(UIButton *)[self viewWithTag:1500+i];
            checkboxBtn.selected=NO;
        }
    }
}

- (void)selectLevelFunction:(UIButton *)sender
{
    if (selectedLevel != 9999) {
       [delegate selectedLevel:[[creditsArray objectAtIndex:selectedLevel] intValue]];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Please select a level to proceed further." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    
}

- (void)backButtonFunction
{
    [delegate removeLevelView];
}

@end
