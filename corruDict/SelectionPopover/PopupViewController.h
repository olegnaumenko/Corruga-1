//
//  SelectPopupViewController.h
//  spectrum-eye
//
//  Created by Oleg Naumenko on 1/24/17.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupContentViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface PopupViewController : UIViewController

+ (instancetype)withTitle:(NSString*)title
                   sender:(UIView*)senderView
    contentViewController:(UIViewController<PopupContentViewController>*)viewController;

- (instancetype)initWithTitle:(NSString*)title
                       sender:(UIView*)senderView
        contentViewController:(UIViewController<PopupContentViewController>*)viewController;

//@property (nonatomic, assign) NSInteger currentSelectionIndex;
@property (nonatomic, assign) CGFloat preferredWidth;
//@property (nonatomic, assign) NSTextAlignment cellTextAlignment;
@property (nonatomic, assign) NSTimeInterval autoDismissTimeInterval; // if < 1.0 - don't auto - dismiss
@property (nonatomic, assign) BOOL canOverlapSourceViewRect;
@property (nonatomic, assign) UIViewController * dimBackgroundViewController;

@property (nonatomic, strong) UIColor * titleBarColor;

@end

NS_ASSUME_NONNULL_END
