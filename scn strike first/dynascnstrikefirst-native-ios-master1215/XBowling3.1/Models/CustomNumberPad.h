//
//  CustomNumberPad.h
//  Xbowling
//
//  Created by Click Labs on 7/17/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keys.h"
#import "DataManager.h"

@protocol NumberPadDelegate<NSObject>
- (void)selectedNumber:(NSString *)score;
- (void)deleteNumberEntry;
- (void)markStrikeOrSpare:(NSString *)value;
@end

@interface CustomNumberPad : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    id<NumberPadDelegate> numberPadDelegate;
}
@property (retain) id<NumberPadDelegate> numberPadDelegate;
@property (nonatomic, assign) id<UICollectionViewDataSource> collectionViewDataSource;
@property (nonatomic, assign) id<UICollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, strong) NSMutableArray *buttonLabelsArray;
@end
