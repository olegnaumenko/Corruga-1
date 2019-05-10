//
//  SelectPopoverBackgroundView.m
//  spectrum-eye
//
//  Created by Oleg Naumenko on 2/7/17.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

#import "PopoverBackgroundView.h"

@implementation PopoverBackgroundView

+ (CGFloat)arrowHeight
{
    return 10.0;
}

+ (UIEdgeInsets)contentViewInsets
{
    return (UIEdgeInsets){4.0, 4.0, 4.0, 4.0};
}

+ (CGFloat)arrowBase
{
    return 20.0;
}

//-(void)layoutSubviews {
//    [super layoutSubviews];//to enable shadow, remove to get rid of it
//}

- (UIPopoverArrowDirection)arrowDirection
{
    return UIPopoverArrowDirectionUp;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {}

- (CGFloat)arrowOffset
{
    return 20.0;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {}

+ (BOOL)wantsDefaultContentAppearance
{
    return YES;
}
@end
