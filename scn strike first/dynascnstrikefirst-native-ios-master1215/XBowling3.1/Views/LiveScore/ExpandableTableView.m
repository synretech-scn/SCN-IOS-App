//
//  ExpandableTableView.m
//  ExpandableTableView
//
//  Created by Shreya on 11/01/15.
//  Copyright (c) 2015 Shreya. All rights reserved.
//

#import "ExpandableTableView.h"

@implementation ExpandableTableView
@synthesize expandableTableDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.sectionsStates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.sectionsStates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.sectionsStates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDataSource:(id <UITableViewDataSource>)newDataSource
{
    if (newDataSource != self.tableViewDataSource)
    {
        self.tableViewDataSource = newDataSource;
        [self.sectionsStates removeAllObjects];
        [super setDataSource:self.tableViewDataSource?self:nil];
    }
}

- (void)setDelegate:(id<UITableViewDelegate>)newDelegate
{
    if (newDelegate != self.tableViewDelegate)
    {
        self.tableViewDelegate = newDelegate;
        [super setDelegate:self.tableViewDelegate?self:nil];
    }
}

- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated
{
    if (sectionIndex >= [self.sectionsStates count])
    {
        return;
    }
    
    if ([[self.sectionsStates objectAtIndex:sectionIndex] boolValue])
    {
        return;
    }
    [self setSectionAtIndex:sectionIndex open:YES];
    if (animated)
    {
        NSArray* indexPathsToInsert = [self indexPathsForRowsInSectionAtIndex:sectionIndex];
        [self insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [self reloadData];
    }
    if ([expandableTableDelegate respondsToSelector:@selector(openSection:sectionView:)]) {
        [expandableTableDelegate openSection:sectionIndex sectionView:view];
    }
   
}

- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated
{
    [self setSectionAtIndex:sectionIndex open:NO];
    
    if (animated)
    {
        NSArray* indexPathsToDelete = [self indexPathsForRowsInSectionAtIndex:sectionIndex];
        [self deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [self reloadData];
    }
    if ([expandableTableDelegate respondsToSelector:@selector(closeSection:sectionView:)]) {
        [expandableTableDelegate closeSection:sectionIndex sectionView:view];
    }

}

- (void)toggleSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated
{
    if (sectionIndex >= [self.sectionsStates count])
    {
        return;
    }
    
    BOOL sectionIsOpen = [[self.sectionsStates objectAtIndex:sectionIndex] boolValue];
    
    if (sectionIsOpen)
    {
        [self closeSection:sectionIndex sectionView:view animated:animated];
    }
    else
    {
        [self openSection:sectionIndex sectionView:view animated:animated];
    }
}

- (BOOL)isOpenSection:(NSUInteger)sectionIndex
{
    if (sectionIndex >= [self.sectionsStates count])
    {
        return NO;
    }
    return [[self.sectionsStates objectAtIndex:sectionIndex] boolValue];
}

#pragma mark - DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return [self.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.sectionsStates objectAtIndex:section] boolValue])
    {
        return [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int nbSection = (int)[self.tableViewDataSource numberOfSectionsInTableView:tableView];
    
    while (nbSection < [self.sectionsStates count])
    {
        [self.sectionsStates removeLastObject];
    }
    
    while (nbSection > [self.sectionsStates count])
    {
        [self.sectionsStates addObject:@NO];
    }
    
    return nbSection;
}

#pragma mark - Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
    NSArray* gestures = view.gestureRecognizers;
    BOOL tapGestureFound = NO;
    for (UIGestureRecognizer* gesture in gestures)
    {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
        {
            tapGestureFound = YES;
            break;
        }
    }
    
    if (!tapGestureFound)
    {
        [view setTag:section];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    }
    return view;
}

#pragma mark - Private methods

#pragma mark Handle Section Header Tap
- (void)handleTapGesture:(UITapGestureRecognizer*)tap
{
    UITableViewHeaderFooterView *tapView=(UITableViewHeaderFooterView *)tap.view;
    NSInteger index = tap.view.tag;
    if (index >= 0)
    {
        [self toggleSection:(NSUInteger)index sectionView:tapView animated:YES];
    }
}

#pragma mark Get indexPath of rows of given Section
- (NSArray*)indexPathsForRowsInSectionAtIndex:(NSUInteger)sectionIndex
{
    if (sectionIndex >= [self.sectionsStates count])
    {
        return nil;
    }
    
    NSInteger numberOfRows = [self.tableViewDataSource tableView:self numberOfRowsInSection:sectionIndex];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < numberOfRows ; i++)
    {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
    }
    
    return array;
}

#pragma mark Set state of given section
- (void)setSectionAtIndex:(NSUInteger)sectionIndex open:(BOOL)open
{
    if (sectionIndex >= [self.sectionsStates count])
    {
        return;
    }
    [self.sectionsStates replaceObjectAtIndex:sectionIndex withObject:@(open)];
}

#pragma mark Get index of opened Section
- (NSUInteger)openedSection
{
    for (NSUInteger index = 0 ; index < [self.sectionsStates count] ; index++)
    {
        if ([[self.sectionsStates objectAtIndex:index] boolValue])
        {
            return index;
        }
    }
    
    return NSNotFound;
}

#pragma mark To collapse all sections
- (void)collapseAllSections
{
    for (NSUInteger index = 0 ; index < [self.sectionsStates count] ; index++)
    {
        [self.sectionsStates replaceObjectAtIndex:index withObject:@(NO)];
    }
    [self reloadData];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
