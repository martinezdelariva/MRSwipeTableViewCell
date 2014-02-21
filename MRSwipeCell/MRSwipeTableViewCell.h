//
//  MRSwipeTableViewCell.h
//  MRSwipeTableViewCell
//
//  Created by Jose Luis Martinez de la Riva on 24/01/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRSwipeTableViewCell;

typedef NS_ENUM (NSUInteger, MRSwipeTableViewCellState) {
    MRSwipeTableViewCellStateCenter,
    MRSwipeTableViewCellStateRight,
    MRSwipeTableViewCellStatePreparingForReuse
};

// Protocol
@protocol MRSwipeTableViewCellProtocol <NSObject>
/*
 Right view width.
 Override this method in order make room to scroll right view.
 */
- (float)rightWidth;

/*
 Parallax width.
 Value must the beetween 0 and rightWidth:
 Override this method to apply parallax effect while scrolling
 */
- (float)rightParallaxWidth;
@end

// Delegate Protocol
@protocol MRSwipeCellDelegate <NSObject>
@optional
- (void)didShowRightView:(MRSwipeTableViewCell *)cell;
- (void)didHideRightView:(MRSwipeTableViewCell *)cell;
@end

@interface MRSwipeTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UIView *centerContentView;
@property (strong, nonatomic, readonly) UIView *rightContentView;
@property (assign, nonatomic, readonly) MRSwipeTableViewCellState state;
@property (weak, nonatomic) id<MRSwipeCellDelegate> delegate;

// Right view
- (void)showRightView:(BOOL)animated;
- (void)closeRightView:(BOOL)animated;
- (void)toggleRightView:(BOOL)animated;
- (void)revealRightView;
- (void)setInitialRightViewState:(MRSwipeTableViewCellState)state;

@end


//
//  MRScrollView
//
//  Created by Jose Luis Martinez de la Riva on 20/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

@interface MRScrollView : UIScrollView

@end
