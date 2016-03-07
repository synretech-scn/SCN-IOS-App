//
//  GraphsViewController.m
//  XBowling3.1
//
//  Created by Click Labs on 3/13/15.
//  Copyright (c) 2015 Click Labs. All rights reserved.
//

#import "GraphsViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface GraphsViewController ()
{
    GraphsView *graphView;
    BOOL showFilter;
    id<GAITracker> tracker;
}

@end

@implementation GraphsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Graph Section"
                                                          action:@"Action"
                                                           label:nil
                                                           value:nil] build]];
    graphView=[[GraphsView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    graphView.delegate=self;
    [self.view addSubview:graphView];
}

#pragma mark - Graph Delegate Methods
- (void)removeGraphView
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showLandscape"];
    if (showFilter == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"graphRemoved" object:nil];
    }
    [self performSelector:@selector(backdelay) withObject:nil afterDelay:0.01];
}

-(void)backdelay
{
    [self.navigationController popViewControllerAnimated:YES];
    if (showFilter == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFilter" object:nil];
        showFilter=NO;
    }
}

- (void)showFilterView
{
    showFilter=YES;
    [self removeGraphView];
}
- (void)showSelectedSection:(UIButton *)selectedSection
{
    [self removeGraphView];
}
- (void)showSelectedCategory:(UISegmentedControl *)segment
{
    [self removeGraphView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
