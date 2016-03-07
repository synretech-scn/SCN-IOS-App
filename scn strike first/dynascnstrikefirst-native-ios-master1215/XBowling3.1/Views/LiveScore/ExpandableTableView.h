//
//  ExpandableTableView.h
//  ExpandableTableView
//
//  Created by Shreya on 11/01/15.
//  Copyright (c) 2015 Shreya. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExpandableTableDelegate<NSObject>
- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view;
- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view;
@end


@interface ExpandableTableView : UITableView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    id<ExpandableTableDelegate> expandableTableDelegate;
}
@property (retain) id<ExpandableTableDelegate> expandableTableDelegate;
@property (nonatomic, assign) id<UITableViewDataSource> tableViewDataSource;
@property (nonatomic, assign) id<UITableViewDelegate> tableViewDelegate;
@property (nonatomic, strong) NSMutableArray* sectionsStates;

/**
 *	This method will display the section whose index is in parameters
 *  If exclusiveSections boolean is YES, this method will close any open section.
 *
 *	@param	sectionIndex	The section you want to show.
 *	@param	animated	YES if you want the opening to be animated.
 */
- (void)openSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated;

/**
 *	This method will close the section whose index is in parameters.
 *
 *	@param	sectionIndex	The section you want to close.
 *	@param	animated	YES if you want the closing to be animated.
 */
- (void)closeSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated;

/**
 *	The will open or close the section whose index is in parameters regarding of its current state.
 *
 *	@param	sectionIndex	The section you want to toggle the visibility.
 *	@param	animated	YES if you want the toggle to be animated.
 */
- (void)toggleSection:(NSUInteger)sectionIndex sectionView:(UITableViewHeaderFooterView *)view animated:(BOOL)animated;

/**
 *	This methods will return YES if the section whose index is in parameters is open.
 *
 *	@param	sectionIndex	The section you want to knwo its visibility.
 *
 *	@return	YES if the section is open.
 */
- (BOOL)isOpenSection:(NSUInteger)sectionIndex;

- (void)collapseAllSections;

@end
