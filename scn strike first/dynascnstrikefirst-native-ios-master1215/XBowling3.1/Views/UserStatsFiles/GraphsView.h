//
//  GraphsView.h
//  XBowling3.1
//
//  Created by Click Labs on 3/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomActionSheet.h"
#import "DataManager.h"
#import "Keys.h"
#import "DropDownImageView.h"
#import "ASIHTTPRequest.h"
#import "PCPieChart.h"
#import "LineGraph.h"
#import "BarChart.h"

@protocol graphDelegate<NSObject>
- (void)removeGraphView;
- (void)showFilterView;
@end

@interface GraphsView : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,customActionSheetDelegate,UIScrollViewDelegate>
{
    id<graphDelegate> delegate;
}
@property (retain) id<graphDelegate>  delegate;

@end
