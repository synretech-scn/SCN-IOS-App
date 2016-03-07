//
//  BuyCreditsView.m
//  XBowling3.1
//
//  Created by Click Labs on 3/3/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "BuyCreditsView.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@implementation BuyCreditsView
{
    NSMutableArray *points;
    NSMutableArray *percent;
    NSMutableArray *dollar;
    NSArray *creditPackagesArray;
    UITableView *packagesTable;
    UILabel *creditsBalanceLabel;
    id<GAITracker> tracker;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
      
    }
    return self;
}
- (void)creditPackages:(NSArray *)packagesArray
{
    creditPackagesArray=[[NSArray alloc]initWithArray:packagesArray];
    points=[[NSMutableArray alloc]init];
    percent=[[NSMutableArray alloc]init];
    dollar=[[NSMutableArray alloc]init];
    for(int count=0;count<packagesArray.count;count++)
    {
        [ points addObject:[NSString stringWithFormat:@"%@",[[packagesArray objectAtIndex:count] objectForKey:@"baseCredits"]]];
        //finding percentage from credits and basecredits given in json
        int percentage=(int)([[[packagesArray objectAtIndex:count] objectForKey:@"credits"]integerValue]-[[[packagesArray objectAtIndex:count] objectForKey:@"baseCredits"]integerValue])*100/(int)[[[packagesArray objectAtIndex:count] objectForKey:@"baseCredits"]integerValue];
        [percent addObject:[NSString stringWithFormat:@"%d",percentage ]];
        //changing  json data to float and then formatting it upto 2 decimal points
        float dollarvalue= [[[packagesArray objectAtIndex:count] objectForKey:@"priceUsPennies"]integerValue];
        dollarvalue=dollarvalue/100;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setAllowsFloats:YES];
        NSNumber *number = [NSNumber numberWithFloat:dollarvalue];
        NSString  *dollarvalueinstring=[formatter stringFromNumber:number];
        [dollar addObject:dollarvalueinstring];
    }

}

- (void)createCreditsViewForBaseView:(NSString *)baseViewName
{
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroundImage.userInteractionEnabled=YES;
    [backgroundImage setImage:[UIImage imageNamed:@"bg.png"]];
    [self addSubview:backgroundImage];
    
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:self.frame.size.height]);
    headerView.backgroundColor=XBHeaderColor;
    headerView.userInteractionEnabled=YES;
    [backgroundImage addSubview:headerView];
    
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:105 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:16 currentSuperviewDeviceSize:self.frame.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:205 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height)];
    headerLabel.backgroundColor=[UIColor clearColor];
    //modi
    //headerLabel.text=@"Buy More Credits";
    headerLabel.text=@"Credits Details";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:screenBounds.size.height]];
    [headerView addSubview:headerLabel];
    
    if ([baseViewName isEqualToString:@"MainMenu"]) {
        UIButton *sideNavigationButton=[[UIButton alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:40 currentSuperviewDeviceSize:screenBounds.size.height])];
        [sideNavigationButton setBackgroundColor:[UIColor clearColor]];
        sideNavigationButton.tag=802;
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [sideNavigationButton setImage:[UIImage imageNamed:@"menu_on.png"] forState:UIControlStateHighlighted];
        [sideNavigationButton setImageEdgeInsets:UIEdgeInsetsMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:screenBounds.size.height],[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:6.35 currentSuperviewDeviceSize:screenBounds.size.width])];
        [sideNavigationButton addTarget:self action:@selector(sideMenuFunction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:sideNavigationButton];
        sideNavigationButton.userInteractionEnabled=true;
        [sideNavigationButton addSubview:[[DataManager shared]notificationRedLabel:CGRectMake(sideNavigationButton.frame.size.width-15,-5,25 ,25)]];
    }
    else{
        //Challenges
        UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:170/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_onclick.png"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backButtonFunction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backButton];
    }
    
     creditsBalanceLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.width], headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:10 currentSuperviewDeviceSize:self.frame.size.height], (self.frame.size.width - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:15 currentSuperviewDeviceSize:self.frame.size.width]),[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:50 currentSuperviewDeviceSize:self.frame.size.height])];
    creditsBalanceLabel.backgroundColor=[UIColor clearColor];
    creditsBalanceLabel.textColor=[UIColor whiteColor];
    creditsBalanceLabel.text=@"Credits Balance:";
    creditsBalanceLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    [self addSubview:creditsBalanceLabel];

    
    if (creditPackagesArray.count > 0) {
        packagesTable=[[UITableView alloc]init];
        packagesTable.frame=CGRectMake(0, creditsBalanceLabel.frame.size.height+creditsBalanceLabel.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - (headerView.frame.size.height+headerView.frame.origin.y+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height]));
        NSLog(@"self.frame.size.height=%f packagesTable.frame.origin.y=%f",self.frame.size.height,packagesTable.frame.origin.y);
        packagesTable.backgroundColor=[UIColor clearColor];
        packagesTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        packagesTable.delegate=self;
        packagesTable.dataSource=self;
        [self addSubview:packagesTable];
        if (creditPackagesArray.count <6) {
            packagesTable.scrollEnabled=NO;
        }
        else{
            packagesTable.scrollEnabled=YES;
        }
        
        //add
        
        packagesTable.hidden=true;
    }
}

-(void)buyPackageButtonFunction:(UIButton *)sender
{
   int selectedPackage=(int)(sender.tag - 6500);
    if (!tracker) {
        tracker = [[GAI sharedInstance] defaultTracker];

    }
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:[NSString stringWithFormat:@"Buy Credits:%@",[creditPackagesArray objectAtIndex:selectedPackage]]
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    [delegate buyPackageAtIndex:selectedPackage];
}


- (void)getCredits
{
    NSDictionary *creditsDict = [delegate userCredits];
    creditsBalanceLabel.text=[NSString stringWithFormat:@"Credits Balance: %ld",(long)[[creditsDict objectForKey:@"credits"] integerValue]];
    
}

#pragma mark - Remove Credits Screen
-(void)backButtonFunction
{
    [delegate removeBuyCreditsView];
}

#pragma mark - Side Menu
- (void)sideMenuFunction:(UIButton *)sender
{
    [delegate showMainMenu:sender];
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
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:250/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor clearColor];
    
    // coin imgview
    UIImageView *coinImgView = [[UIImageView alloc] initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:172/3 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:176/3 currentSuperviewDeviceSize:screenBounds.size.height])];
    coinImgView.image = [UIImage imageNamed:@"coin.png"];
    coinImgView.center=CGPointMake(coinImgView.center.x, cellView.center.y);
    coinImgView.backgroundColor=[UIColor clearColor];
    [cellView addSubview:coinImgView];
    
    //Credits label
    NSString *discountPercent=[NSString stringWithFormat:@"%@ + %@%% Free",[points objectAtIndex:indexPath.row],[percent objectAtIndex:indexPath.row]];
    long int resultvalue=[[points objectAtIndex:indexPath.row]integerValue]*[[percent objectAtIndex:indexPath.row]integerValue]/100+[[points objectAtIndex:indexPath.row]integerValue];
    NSLog(@"value==%ld",resultvalue);
    NSString *creditsString=[NSString stringWithFormat:@"%ld Credits",resultvalue];
    
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake(coinImgView.frame.origin.x+coinImgView.frame.size.width+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:590/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height)];
    NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",discountPercent] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    if ([[percent objectAtIndex:indexPath.row] integerValue] == 0) {
        NSMutableAttributedString *frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",creditsString] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        frameLabel.attributedText=frameLabelText;
    }
    else{
        NSMutableAttributedString *frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",creditsString] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]]}];
        [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
        [latestPlayedFrameAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[NSString stringWithFormat:@"\n%@",creditsString] length])];
        frameLabel.attributedText=latestPlayedFrameAttributedString;
    }
    frameLabel.backgroundColor=[UIColor clearColor];
    frameLabel.textColor=[UIColor whiteColor];
    frameLabel.textAlignment=NSTextAlignmentLeft;
    frameLabel.numberOfLines=0;
    [cellView addSubview:frameLabel];
    
    //View button
    UIButton *viewButton=[[UIButton alloc]init];
    [viewButton setFrame:CGRectMake(cellView.frame.size.width - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:self.frame.size.width] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width]), 10, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:310/3 currentSuperviewDeviceSize:self.frame.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:self.frame.size.height])];
    viewButton.center=CGPointMake(viewButton.center.x,cellView.center.y);
    viewButton.layer.cornerRadius=viewButton.frame.size.height/2;
    viewButton.clipsToBounds=YES;
    viewButton.tag=6500+indexPath.row;
    viewButton.titleLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    [viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *titleString=[NSString stringWithFormat:@"$ %@",[dollar objectAtIndex:indexPath.row]];
    viewButton.titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
    [viewButton setTitle:titleString forState:UIControlStateNormal];
    viewButton.contentEdgeInsets=UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
    [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndNormalState buttonframe:viewButton.frame] forState:UIControlStateNormal];
    [viewButton setBackgroundImage:[[DataManager shared]setColor:XBBlueButtonBackgndHighlightedState buttonframe:viewButton.frame] forState:UIControlStateHighlighted];
    [viewButton addTarget:self action:@selector(buyPackageButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:viewButton];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return creditPackagesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:290/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

@end
