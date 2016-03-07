//
//  CustomNumberPad.m
//  Xbowling
//
//  Created by Click Labs on 7/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "CustomNumberPad.h"
#define  numberCellBackgroundColor [UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0]
#define numberCellHighlightedColor [UIColor colorWithRed:3.0/255.0f green:68.0/255.0f blue:144.0/255.0f alpha:0.5f]
#define disabledCellColor [UIColor grayColor]
@implementation CustomNumberPad
@synthesize numberPadDelegate,buttonLabelsArray;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self){
        self.delaysContentTouches=NO;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self setBackgroundColor:[UIColor clearColor]];

    }
    return self;
}


- (void)setDataSource:(id <UICollectionViewDataSource>)newDataSource
{
    if (newDataSource != self.collectionViewDataSource)
    {
        self.collectionViewDataSource = newDataSource;
        [super setDataSource:self.collectionViewDataSource?self:nil];
    }
}

- (void)setDelegate:(id<UICollectionViewDelegate>)newDelegate
{
    if (newDelegate != self.collectionViewDelegate)
    {
        self.collectionViewDelegate = newDelegate;
        [super setDelegate:self.collectionViewDelegate?self:nil];
    }
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.collectionViewDataSource numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.collectionViewDataSource collectionView:collectionView numberOfItemsInSection:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithRed:36.0/255 green:51.0/255 blue:59.0/255 alpha:1.0];
    
    UILabel *numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    numberLabel.tag = ((indexPath.section+1)*100)+indexPath.row;
    numberLabel.font=[UIFont fontWithName:AvenirRegular size:XbH1size];
    numberLabel.textAlignment=NSTextAlignmentCenter;
    numberLabel.textColor=[UIColor whiteColor];
    if (indexPath.section == 0) {
        numberLabel.text=[NSString stringWithFormat:@"%@",[buttonLabelsArray objectAtIndex:indexPath.row]];
        if ([numberLabel.text isEqualToString:@""]) {
            cell.userInteractionEnabled=NO;
        }
    }
    else{
        cell.backgroundColor=XBBlueButtonBackgndNormalState;
        if (indexPath.row == 0) {
            numberLabel.text=@"X STRIKE";
        }
        else{
            numberLabel.text=@"/ SPARE";
        }
    }
    [cell.contentView addSubview:numberLabel];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section=%ld  row=%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 1) {
        if (screenBounds.size.height > 568) {
            if (screenBounds.size.height == 736) {
                return CGSizeMake(151, 55);
            }
            else{
                return CGSizeMake(131, 55);
            }
        }
        else{
            return CGSizeMake(121, 50);
        }
        
    }
    else
    {
        if (screenBounds.size.height > 568) {
            if (screenBounds.size.height == 736) {
                return CGSizeMake(100, 55);
            }
            else{
                return CGSizeMake(87, 55);
            }
        }
        else{
            return CGSizeMake(80, 50);
        }
    }
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"screenBounds=%f",screenBounds.size.height);
    if (section == 0) {
         if (screenBounds.size.height > 568) {
                 return UIEdgeInsetsMake(2, 35, 2, 35); // top, left, bottom, right
         }
         else{
             return UIEdgeInsetsMake(2, 18, 2, 18); // top, left, bottom, right
         }
    }
    else{
        if (screenBounds.size.height > 568) {
                return UIEdgeInsetsMake(0, 35, 0, 35); // top, left, bottom, right
        }
        else{
            return UIEdgeInsetsMake(0, 18, 0, 18); // top, left, bottom, right
        }
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *numberLabel=(UILabel *)[self viewWithTag:((indexPath.section+1)*100)+indexPath.row];
    if (indexPath.section == 0) {
        if ([numberLabel.text isEqualToString:@"DEL"]) {
            [numberPadDelegate deleteNumberEntry];
        }
        else{
            [numberPadDelegate selectedNumber:numberLabel.text];
        }
    }
    else{
        [numberPadDelegate markStrikeOrSpare:numberLabel.text];
    }
    
    
}

-(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //change color when tapped
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.backgroundColor = numberCellHighlightedColor;
    }
    else
        cell.backgroundColor = XBBlueButtonBackgndHighlightedState;
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    //change back on touch up
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.backgroundColor=numberCellBackgroundColor;
    }
    else{
        cell.backgroundColor= XBBlueButtonBackgndNormalState;
    }
}

#pragma mark - Collection View Flow Layout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}


@end
