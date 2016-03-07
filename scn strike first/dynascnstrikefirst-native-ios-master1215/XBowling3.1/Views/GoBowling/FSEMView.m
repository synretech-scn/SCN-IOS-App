//
//  FSEMView.m
//  Xbowling
//
//  Created by Click Labs on 5/15/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "FSEMView.h"

#define  numberCellBackgroundColor [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0]
#define numberCellHighlightedColor [UIColor colorWithRed:3.0/255.0f green:68.0/255.0f blue:144.0/255.0f alpha:0.5f]
#define disabledCellColor [UIColor grayColor]


@implementation FSEMView
{
    CustomNumberPad *mainCollectionView;
    NSString *baseView;
    
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor=[UIColor clearColor];
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        mainCollectionView = [[CustomNumberPad alloc]initWithFrame:CGRectMake(20, 20, self.frame.size.width - 40,self.frame.size.height) collectionViewLayout:layout];
        mainCollectionView.numberPadDelegate=self;
        mainCollectionView.buttonLabelsArray=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"DEL", nil];
        [mainCollectionView setDataSource:self];
        [mainCollectionView setDelegate:self];
        [self addSubview:mainCollectionView];
        [self updateStrikeOrSpareBasedOnCurrentThrow:@"disableSpare"];

    }
    return self;
}


- (void)updateStrikeOrSpareBasedOnCurrentThrow:(NSString *)status
{
    UICollectionViewCell *strikeCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UICollectionViewCell *spareCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if ([status isEqualToString:@"disableStrike"]) {
        strikeCell.backgroundColor= disabledCellColor;
        strikeCell.userInteractionEnabled=NO;
        spareCell.backgroundColor=XBBlueButtonBackgndNormalState;
        spareCell.userInteractionEnabled=YES;
    }
    else if ([status isEqualToString:@"disableSpare"]) {
        spareCell.backgroundColor=disabledCellColor;
        spareCell.userInteractionEnabled=NO;
        strikeCell.backgroundColor=XBBlueButtonBackgndNormalState;
        strikeCell.userInteractionEnabled=YES;
    }
   
}

- (void)updateScoreFrameBasedOnPreviousThrowScore:(NSString *)score currentFrame:(NSUInteger)frameNumber currentThrow:(NSUInteger)throwNumber
{
    if (throwNumber == 1) {
        for (int i = 0; i<9; i++) {
            UICollectionViewCell *numberCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if ((i+1)==score.integerValue) {
                numberCell.backgroundColor=numberCellHighlightedColor;
                numberCell.userInteractionEnabled=YES;
            }
            else{
                numberCell.backgroundColor=numberCellBackgroundColor;
                numberCell.userInteractionEnabled=YES;
            }
        }
    }
    else{
        if ([score isEqualToString:@"F"]) {
            //enable all numbers
            for (int i = 0; i<9; i++) {
                UICollectionViewCell *numberCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                numberCell.backgroundColor=numberCellBackgroundColor;
                numberCell.userInteractionEnabled=YES;
            }
        }
        else if ([score isEqualToString:@"X"])
        {
            //disable all for 1-9 frames & for 10th frame enable all
            for (int i = 0; i<9; i++) {
                UICollectionViewCell *numberCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (frameNumber < 10) {
                    numberCell.backgroundColor=disabledCellColor;
                    numberCell.userInteractionEnabled=NO;
                }
                else{
                    numberCell.backgroundColor=numberCellBackgroundColor;
                    numberCell.userInteractionEnabled=YES;
                }
            }
        }
        else{
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showScoreForThirdThrow"]){
                for (int i = 0; i<9; i++) {
                    UICollectionViewCell *numberCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if ((i+1)==[[[NSUserDefaults standardUserDefaults]valueForKey:@"thirdThrowScore"] integerValue]) {
                        numberCell.backgroundColor=numberCellHighlightedColor;
                        numberCell.userInteractionEnabled=YES;
                    }
                    else{
                        numberCell.backgroundColor=numberCellBackgroundColor;
                        numberCell.userInteractionEnabled=YES;
                    }
                }
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"thirdThrowScore"];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showScoreForThirdThrow"];
                
            }
            else{
                int ball2  = 10 - (int)score.integerValue;
                for (int i = 0; i<9; i++) {
                    UICollectionViewCell *numberCell = [mainCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                    if((i+1)<ball2){
                        numberCell.backgroundColor=numberCellBackgroundColor;
                        numberCell.userInteractionEnabled=YES;
                    }
                    else{
                        numberCell.backgroundColor=disabledCellColor;
                        numberCell.userInteractionEnabled=NO;
                    }
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"showScoreForSecondThrow"]) {
                        if ((i+1)==[[[NSUserDefaults standardUserDefaults]valueForKey:@"secondThrowScore"] integerValue]) {
                            numberCell.backgroundColor=numberCellHighlightedColor;
                            numberCell.userInteractionEnabled=YES;
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"secondThrowScore"];
                            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showScoreForSecondThrow"];
                        }
                    }
                }
 
            }

        }
    }
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 12;
    }
    else{
        return 2;
    }
}

//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
//    
//    cell.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
//
//    UILabel *numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
//    numberLabel.tag = ((indexPath.section+1)*100)+indexPath.row;
//    numberLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
//    numberLabel.textAlignment=NSTextAlignmentCenter;
//    numberLabel.textColor=[UIColor whiteColor];
//    if (indexPath.section == 0) {
//        numberLabel.text=[NSString stringWithFormat:@"%@",[buttonsLabelsArray objectAtIndex:indexPath.row]];
//        if ([numberLabel.text isEqualToString:@""]) {
//            cell.userInteractionEnabled=NO;
//        }
////        if ([numberLabel.text isEqualToString:@"DEL"]) {
////            UIImageView *deleteImageView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 16, cell.frame.size.height - 9, 32, 18)];
////            [deleteImageView setImage:[UIImage imageNamed:@"back_cross_icon.png"]];
////            deleteImageView.userInteractionEnabled=YES;
////            [cell.contentView addSubview:deleteImageView];
////        }
//    }
//    else{
//        cell.backgroundColor=XBBlueButtonBackgndNormalState;
//        if (indexPath.row == 0) {
//            numberLabel.text=@"X STRIKE";
//        }
//        else{
//            numberLabel.text=@"/ SPARE";
//        }
//    }
//    [cell.contentView addSubview:numberLabel];
//    
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"section=%ld  row=%ld",(long)indexPath.section,(long)indexPath.row);
//    if (indexPath.section == 1) {
//        return CGSizeMake(121, 50);
//    }
//    else
//        return CGSizeMake(80, 50);
//}
//
//#pragma mark collection view cell paddings
//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if (section == 0) {
//         return UIEdgeInsetsMake(2, 18, 2, 18); // top, left, bottom, right
//    }
//    else{
//         return UIEdgeInsetsMake(0, 18, 0, 18); // top, left, bottom, right
//    }
//   
//}
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UILabel *numberLabel=(UILabel *)[self viewWithTag:((indexPath.section+1)*100)+indexPath.row];
//    if (indexPath.section == 0) {
//        if ([numberLabel.text isEqualToString:@"DEL"]) {
//            [delegate deleteScoreEntry];
//        }
//        else{
//            [delegate selectedScore:numberLabel.text];
//        }
//    }
//    else{
//        [delegate markStrikeOrSpare:numberLabel.text];
//    }
//    
//    
//}
//
//-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    //change color when tapped
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        cell.backgroundColor = numberCellHighlightedColor;
//    }
//    else
//        cell.backgroundColor = XBBlueButtonBackgndHighlightedState;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    //change back on touch up
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        cell.backgroundColor=numberCellBackgroundColor;
//    }
//    else{
//        cell.backgroundColor= XBBlueButtonBackgndNormalState;
//    }
//}

- (void)selectedNumber:(NSString *)score
{
    [delegate selectedScore:score];
}

- (void)deleteNumberEntry
{
    [delegate deleteScoreEntry];
}

- (void)markStrikeOrSpare:(NSString *)value
{
    [delegate markStrikeOrSpare:value];
}
@end
