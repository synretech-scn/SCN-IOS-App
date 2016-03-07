//
//  ComparisonView.h
//  XBowling3.1
//
//  Created by Shreya on 16/03/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "Keys.h"
@protocol ComparisonDelegate<NSObject>
- (void)removeComparisonView;
@end


@interface ComparisonView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<ComparisonDelegate> delegate;
}
@property (retain) id<ComparisonDelegate>  delegate;
- (void)createComparisonViewWithData:(NSArray *)array andOpponentName:(NSString *)name;
@end
