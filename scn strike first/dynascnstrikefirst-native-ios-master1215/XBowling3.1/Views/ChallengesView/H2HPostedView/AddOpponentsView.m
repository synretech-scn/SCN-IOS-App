//
//  AddOpponentsView.m
//  XBowling3.1
//
//  Created by Click Labs on 2/11/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "AddOpponentsView.h"

@implementation AddOpponentsView
{
    NSMutableArray *opponentsArray;
    UITableView *opponentsTable;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
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
        
        //Add Opponent
        UIButton *addOpponentButton=[[UIButton alloc]init];
        addOpponentButton.tag=15000;
        addOpponentButton.frame=CGRectMake(0,self.frame.size.height-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:58.3 currentSuperviewDeviceSize:self.frame.size.height]);
        [addOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base.png"] forState:UIControlStateNormal];
        [addOpponentButton setImage:[UIImage imageNamed:@"enter_challenge_base_on.png"] forState:UIControlStateHighlighted];
        [addOpponentButton addTarget:self action:@selector(addOpponentFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addOpponentButton];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, addOpponentButton.frame.size.width, addOpponentButton.frame.size.height)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"      Add Opponent";
        titleLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size ];
        [addOpponentButton addSubview:titleLabel];
        
        UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(addOpponentButton.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
        arrow.tag=902;
        arrow.center=CGPointMake(arrow.center.x, addOpponentButton.frame.size.height/2);
        [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
        [addOpponentButton addSubview:arrow];
    }
    return self;
}
- (void)displayOpponents:(NSMutableArray *)array
{
    opponentsArray=[[NSMutableArray alloc]initWithArray:array];
    UIView *noteView=(UIView*)[self viewWithTag:5500];
    [noteView removeFromSuperview];
    if (opponentsArray.count > 0) {
        UILabel *noteLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:screenBounds.size.height]+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:86/3 currentSuperviewDeviceSize:screenBounds.size.height])];
        noteLabel.backgroundColor=[UIColor colorWithRed:11/255 green:91/255 blue:253/255 alpha:0.4];
        noteLabel.text=@"   Click to compare opponent's frame with yours.";
        noteLabel.textColor=[UIColor whiteColor];
        noteLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:48/3 currentSuperviewDeviceSize:screenBounds.size.height]];
        [self addSubview:noteLabel];
        
        opponentsTable=[[UITableView alloc]init];
        opponentsTable.frame=CGRectMake(0, noteLabel.frame.size.height+noteLabel.frame.origin.y, self.frame.size.width, screenBounds.size.height - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(112+71) currentSuperviewDeviceSize:screenBounds.size.height] - [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:116/3 currentSuperviewDeviceSize:screenBounds.size.height]);
        NSLog(@"self.frame.size.height=%f opponentsTable.frame.origin.y=%f",self.frame.size.height,opponentsTable.frame.origin.y);
        opponentsTable.backgroundColor=[UIColor clearColor];
        opponentsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        opponentsTable.delegate=self;
        opponentsTable.dataSource=self;
        [self addSubview:opponentsTable];
    }
    else{
        UIView *noteView=[[UIView alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:82 currentSuperviewDeviceSize:screenBounds.size.height] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height], self.frame.size.width, screenBounds.size.height - ([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:(82+71) currentSuperviewDeviceSize:screenBounds.size.height] + [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.height]))];
        noteView.tag=5500;
        noteView.backgroundColor=[UIColor clearColor];
        [self addSubview:noteView];
        
        UILabel *mainTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, noteView.frame.size.width, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70 currentSuperviewDeviceSize:screenBounds.size.height] )];
        mainTextLabel.backgroundColor=[UIColor clearColor];
        mainTextLabel.text=@"Add opponents to play against posted \ngames across the world!";
        mainTextLabel.textAlignment=NSTextAlignmentCenter;
        mainTextLabel.numberOfLines=3;
        mainTextLabel.textColor=[UIColor whiteColor];
        mainTextLabel.font=[UIFont fontWithName:AvenirRegular size:XbH2size];
        [noteView addSubview:mainTextLabel];
        
        UILabel *stepsHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, mainTextLabel.frame.size.height+mainTextLabel.frame.origin.y, noteView.frame.size.width, mainTextLabel.frame.size.height)];
        stepsHeaderLabel.backgroundColor=[UIColor clearColor];
        stepsHeaderLabel.text=@"How it works:";
        stepsHeaderLabel.numberOfLines=3;
        stepsHeaderLabel.textColor=[UIColor whiteColor];
        stepsHeaderLabel.textAlignment=NSTextAlignmentCenter;
        stepsHeaderLabel.font=[UIFont fontWithName:AvenirDemi size:XbH1size];
        [noteView addSubview:stepsHeaderLabel];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [paragraphStyle setHeadIndent:15];
        UILabel *stepsLabel=[[UILabel alloc]initWithFrame:CGRectMake( [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:60/3 currentSuperviewDeviceSize:screenBounds.size.width], stepsHeaderLabel.frame.size.height+stepsHeaderLabel.frame.origin.y, noteView.frame.size.width-[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:120/3 currentSuperviewDeviceSize:screenBounds.size.width],noteView.frame.size.height - mainTextLabel.frame.size.height)];
        stepsLabel.backgroundColor=[UIColor clearColor];
        NSMutableAttributedString *stepsLabelText=[[NSMutableAttributedString alloc] initWithString:@"1. On the next screen you will see opponents you can select, including their average and handicap. \n\n2. Check the box beside the bowler you wish to compete against, then tap ""Select Opponent"". \n\n3. Select the competition level. Higher levels require more credits to enter, and you get more reward points if you win them." attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
        [stepsLabelText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [stepsLabelText length])];
        stepsLabel.attributedText=stepsLabelText;
        stepsLabel.textColor=[UIColor whiteColor];
        stepsLabel.numberOfLines=20;
        [noteView addSubview:stepsLabel];
        [stepsLabel sizeToFit];

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
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
    cellView.tag=indexPath.row+100;
    cellView.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:cellView];
    cell.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake([[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:40/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:530/3 currentSuperviewDeviceSize:screenBounds.size.width], cellView.frame.size.height)];
    //    nameLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:70/3 currentSuperviewDeviceSize:self.frame.size.height]];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.backgroundColor=[UIColor clearColor];
    nameLabel.numberOfLines=0;
    NSMutableAttributedString *nameString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[[opponentsArray objectAtIndex:indexPath.row] objectForKey:@"userScreenName"]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH2size]}];
    
    NSMutableAttributedString *nameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" \nRegion: %@",[[opponentsArray objectAtIndex:indexPath.row] objectForKey:@"userRegion"]] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH2size]}];
    [nameString appendAttributedString:nameLabelText];
    [nameString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [nameString length])];
    nameLabel.attributedText=nameString;
    NSLog(@"nameText=%@",nameString);
    [cellView addSubview:nameLabel];
    
//    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:187/3 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:813/3 currentSuperviewDeviceSize:screenBounds.size.width], 0.5)];
//    separatorLine.tag=901;
//    separatorLine.backgroundColor=[UIColor whiteColor];
//    separatorLine.alpha=0.6;
//    [cellView addSubview:separatorLine];
    
    UILabel *frameLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width+nameLabel.frame.origin.x+[[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:5/3 currentSuperviewDeviceSize:screenBounds.size.width], 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:280/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    
    // Display score in standard format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
//    NSString *formattedString =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[playersArray objectAtIndex:indexPath.row] objectForKey:@"score"] floatValue]]];
     NSString *score =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[opponentsArray objectAtIndex:indexPath.row] objectForKey:@"userAverage"] floatValue]]];
     NSString *handicap =  [formatter stringFromNumber:[NSNumber numberWithFloat:[[[opponentsArray objectAtIndex:indexPath.row] objectForKey:@"userHandicap"] floatValue]]];
    NSMutableAttributedString *latestPlayedFrameAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@",score,handicap] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH2size]}];
    NSMutableAttributedString *frameLabelText=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",@"Avg/Handicap"] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:XbH3size]}];
    [latestPlayedFrameAttributedString appendAttributedString:frameLabelText];
//    [latestPlayedFrameAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [latestPlayedFrameAttributedString length])];
    
    frameLabel.attributedText=latestPlayedFrameAttributedString;
    frameLabel.backgroundColor=[UIColor clearColor];
    frameLabel.textColor=[UIColor whiteColor];
    frameLabel.textAlignment=NSTextAlignmentCenter;
    frameLabel.numberOfLines=0;
    [cellView addSubview:frameLabel];
    
    UILabel *scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(frameLabel.frame.size.width + frameLabel.frame.origin.x , 0, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:280/3 currentSuperviewDeviceSize:screenBounds.size.width], frame.size.height)];
    NSMutableAttributedString *scoreAttributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%@",[[[opponentsArray objectAtIndex:indexPath.section] objectForKey:@"userScore"] intValue],handicap] attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirDemi size:XbH2size]}];
    NSAttributedString *scoreLabelText=[[NSAttributedString alloc] initWithString:@"\nScore/Handicap" attributes:@{NSFontAttributeName: [UIFont fontWithName:AvenirRegular size:XbH3size]}];
    [scoreAttributedString appendAttributedString:scoreLabelText];
    scoreLabel.backgroundColor=[UIColor clearColor];
    scoreLabel.attributedText=scoreAttributedString;
    scoreLabel.textColor=[UIColor whiteColor];
    scoreLabel.numberOfLines=0;
    scoreLabel.textAlignment=NSTextAlignmentCenter;
    [cellView addSubview:scoreLabel];
    
    UIImageView *arrow=[[UIImageView alloc]initWithFrame:CGRectMake(cellView.frame.size.width - 15, [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:30 currentSuperviewDeviceSize:screenBounds.size.height], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.width targetSubviewSize:9 currentSuperviewDeviceSize:screenBounds.size.width], [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:15 currentSuperviewDeviceSize:screenBounds.size.height])];
    arrow.tag=1000+indexPath.row;
    arrow.center=CGPointMake(arrow.center.x, cellView.frame.size.height/2);
    [arrow setImage:[UIImage imageNamed:@"arrow.png"]];
    [cellView addSubview:arrow];
    
    UIView *separatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.frame.size.height-0.5, tableView.frame.size.width, 0.5)];
    separatorLine.tag=901;
    separatorLine.backgroundColor=[UIColor whiteColor];
    separatorLine.alpha=0.6;
    [cellView addSubview:separatorLine];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return opponentsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int height;
    if(screenBounds.size.height == 480)
        height = 60;
    else
        height = [[DataManager shared]getValueFromTargetSize:TARGET_SIZE.height targetSubviewSize:190/3 currentSuperviewDeviceSize:screenBounds.size.height];
    return height;
}

#pragma mark - UITableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate showFrameViewOfPlayer:[opponentsArray objectAtIndex:indexPath.row]];
}

- (void)addOpponentFunction:(UIButton *)sender
{
    [delegate addMoreOpponents];
}

- (void)backButtonFunction
{
    [delegate removeAddOpponentView];
}

@end
