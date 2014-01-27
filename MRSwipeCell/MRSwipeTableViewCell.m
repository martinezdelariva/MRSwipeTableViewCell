//
//  MRSwipeCell.m
//  MRSwipeCell
//
//  Created by Jose Luis Martinez de la Riva on 24/01/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRSwipeTableViewCell.h"

@interface MRSwipeTableViewCell () <UIScrollViewDelegate>
// Views
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *centerContentView;
@property (strong, nonatomic) UIView *rightContentView;
@property (strong, nonatomic) UIDynamicAnimator *animator;

// Helper properties
@property (assign, nonatomic) MRSwipeTableViewCellState state;
@property (strong, nonatomic) NSNumber *rightContentViewOriginX;
@property (assign, nonatomic) BOOL isMovingRight;
@end

@implementation MRSwipeTableViewCell

- (void)awakeFromNib
{
    [self setUp];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self setUp];
    }
    return self;
}

- (void)setUp
{
    // Right view
    self.rightContentView = [[UIView alloc] init];
    self.rightContentView.frame = ({
        CGRect frame = self.contentView.bounds;
        frame.size.width = [self rightWidth];
        frame.origin.x += CGRectGetWidth(self.contentView.bounds) - [self rightWidth] + [self rightParallaxWidth];
        self.rightContentViewOriginX = [NSNumber numberWithInteger:frame.origin.x];
        frame;
    });
    
    // Center view
    self.centerContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    // ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(
        CGRectGetWidth(self.centerContentView.bounds) + [self rightWidth],
        CGRectGetHeight(self.contentView.bounds)
    );
    
    // Hierarchy
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.rightContentView];
    [self.scrollView addSubview:self.centerContentView];
    
    // Initialize variables
    self.isMovingRight = NO;
    self.state = MRSwipeTableViewCellStateCenter;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
    
    self.state = MRSwipeTableViewCellStatePreparingForReuse;
	[self.scrollView setContentOffset:CGPointZero animated:NO];
    self.state = MRSwipeTableViewCellStateCenter;
}

#pragma mark -
#pragma Protected Methods

/*
 Right view width.
 Override this method in order make room to scroll right view.
*/
- (float)rightWidth
{
    return 0.0f;
}

/*
 Parallax width.
 Value must the beetween 0 and rightWidth:
 Override this method to apply parallax effect while scrolling
*/
- (float)rightParallaxWidth
{
    return 0.0f;
}

- (void)updateState
{
    if (self.scrollView.contentOffset.x == 0.0f) {
        self.state = MRSwipeTableViewCellStateCenter;
    } else {
        self.state = MRSwipeTableViewCellStateRight;
    }
}

#pragma mark -
#pragma ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Delegate
    if (self.state != MRSwipeTableViewCellStatePreparingForReuse) {
        // Right view did show
        if (self.scrollView.contentOffset.x == CGRectGetWidth(self.rightContentView.bounds)
            ) {
            if ([self.delegate respondsToSelector:@selector(didShowRightView:)]) {
                [self.delegate didShowRightView:self];
            }
        }
        
        // Right view did hide
        if (self.scrollView.contentOffset.x == 0.0f) {
            if ([self.delegate respondsToSelector:@selector(didHideRightView:)]) {
                [self.delegate didHideRightView:self];
            }
        }
    }

    // Right view offset
    self.rightContentView.frame = ({
        CGRect frame = self.rightContentView.frame;
        // Avoid scroll
        frame.origin.x = [self.rightContentViewOriginX integerValue] + self.scrollView.contentOffset.x;
        // Add parallax
        NSInteger increment =
        (self.scrollView.contentOffset.x * [self rightParallaxWidth]) / CGRectGetWidth(self.rightContentView.frame);
        frame.origin.x -= increment;
        frame;
    });
    
    // State
    [self updateState];
}

#pragma mark -
#pragma Public Methods

- (void)showRightView:(BOOL)animated
{
    CGPoint point = CGPointMake(CGRectGetWidth(self.rightContentView.bounds), 0);
    [self.scrollView setContentOffset:point animated:animated];

//    self.state = MRSwipeCellStateRight;
}

- (void)closeRightView:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointZero animated:animated];
  
//    self.state = MRSwipeCellStateCenter;
}

- (void)toggleRightView:(BOOL)animated
{
    if (self.state == MRSwipeTableViewCellStateCenter) {
        [self showRightView:animated];
    } else if (self.state == MRSwipeTableViewCellStateRight) {
        [self closeRightView:animated];
    }
}

- (void)revealRightView
{
    if (self.state == MRSwipeTableViewCellStateCenter) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGPoint point = CGPointMake(CGRectGetWidth(self.rightContentView.bounds) / 6, 0);
            [self.scrollView setContentOffset:point];
        } completion:^(BOOL finished) {
            self.state = MRSwipeTableViewCellStatePreparingForReuse;
            [UIView animateWithDuration:0.1 animations:^{
                [self.scrollView setContentOffset:CGPointZero];
            } completion:^(BOOL finished) {
                self.state = MRSwipeTableViewCellStateCenter;
            }];
        }];
    }
}

- (void)setInitialRightViewState:(MRSwipeTableViewCellState)aState
{
    self.state = MRSwipeTableViewCellStatePreparingForReuse;
    
    if (aState == MRSwipeTableViewCellStateCenter) {
        [self closeRightView:NO];
    } else if (aState == MRSwipeTableViewCellStateRight) {
        [self showRightView:NO];
    }
}

@end
