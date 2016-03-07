//
//  HomeView.m
//  Xbowling
//
//  Created by Click Labs on 5/12/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView
{
    UITableView *optionsTable;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void)createHomeView
{
    
}

- (void)refreshMenu
{
     [optionsTable reloadData];
}
@end
