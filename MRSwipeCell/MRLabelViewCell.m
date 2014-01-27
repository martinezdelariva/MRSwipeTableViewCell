//
//  MRLabelViewCell.m
//  MRSwipeCell
//
//  Created by Jose Luis Martinez de la Riva on 24/01/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRLabelViewCell.h"

@interface MRLabelViewCell()
@property (weak, nonatomic) IBOutlet UIView *customFrontView;
@property (strong, nonatomic) UIView *customRightView;
@end

@implementation MRLabelViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Front content
        self.customFrontView = [[[NSBundle mainBundle] loadNibNamed:@"CenterView" owner:self options:nil] objectAtIndex:0];
        
        // Hierarchy
        [self.centerContentView addSubview:self.customFrontView];
        [self.rightContentView addSubview:self.customRightView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark Getters

- (UIView *)customRightView
{
    if (!_customRightView) {
        _customRightView = [[[NSBundle mainBundle] loadNibNamed:@"RightView" owner:self options:nil] objectAtIndex:0];;
    }
    
    return _customRightView;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)tapReveal:(id)sender
{
    [self revealRightView];
}

- (IBAction)tapped:(id)sender
{
    [self toggleRightView:YES];
}


#pragma mark -
#pragma mark MRSwipeCell Protocol

- (float)rightWidth
{
    return CGRectGetWidth(self.customRightView.bounds);
}

- (float)rightParallaxWidth
{
    return 50.0f;
}

@end
