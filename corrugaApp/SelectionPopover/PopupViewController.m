//
//  SelectPopupViewController.m
//  spectrum-eye
//
//  Created by Oleg Naumenko on 1/24/17.
//  Copyright © 2016 Oleg Naumenko. All rights reserved.
//

#import "PopupViewController.h"
#import "PopoverBackgroundView.h"
//#import "ViewFrameAccessor.h"
#import "SelectViewController.h"

CGFloat const kHeaderHeight = 38.0;
//CGFloat const kCellHeight = 44.0;

//NSInteger const kOutsideViewTag = 3141592;
//
//NSString * const kSelectableValueCell = @"SelectableValueCell";

@interface PopupViewController ()
    <UIPopoverPresentationControllerDelegate, PopupContentViewControllerDelegate>

//@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSArray * values;
@property (nonatomic, strong) UILabel * titleLabel;
//@property (nonatomic, copy) SelectionBlock selectionBlock;
@property (nonatomic, strong) UIView * sourceView;
@property (nonatomic, strong) UIViewController * contentViewController;
//@property (nonatomic, strong) UITapGestureRecognizer * titleTapReco;

@end

@implementation PopupViewController

+ (instancetype) withTitle:(NSString*)title
                    sender:(UIView*)senderView
     contentViewController:(UIViewController<PopupContentViewController>*)viewController
{
    return [[self alloc]initWithTitle:title sender:senderView contentViewController:viewController];
}

- (instancetype) initWithTitle:(NSString*)title
                        sender:(UIView*)senderView
         contentViewController:(UIViewController<PopupContentViewController>*)viewController
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        _titleLabel.backgroundColor = UIColor.orangeColor;
        [_titleLabel sizeToFit];
        
        _autoDismissTimeInterval = 0.0;
        _preferredWidth = MAX(92.0, _titleLabel.frame.size.width + 20);
        
        self.contentViewController = viewController;
        viewController.delegate = self;
        self.modalPresentationStyle = UIModalPresentationPopover;
        
        CGRect sourceRect = CGRectInset(senderView.bounds, 0, 3);
        self.sourceView = senderView;
        self.popoverPresentationController.sourceView = senderView;
        self.popoverPresentationController.sourceRect = sourceRect;
        
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight;
        self.popoverPresentationController.backgroundColor = [UIColor clearColor];
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.popoverBackgroundViewClass = [PopoverBackgroundView class];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.layer.cornerRadius = 6.5;
//    self.view.clipsToBounds = YES;
    
    CGRect titleRect = self.view.bounds;
    titleRect.size.height = kHeaderHeight;
    
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y += kHeaderHeight;
    tableRect.size.height -= kHeaderHeight;
    
    self.titleLabel.frame = titleRect;
    self.contentViewController.view.frame = tableRect;
    
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentViewController.view];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSenderSelected:YES];
    [self updatePreferredContentSize];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self updateDismissTimer];
}

- (void) setSenderSelected:(BOOL)selected
{
    UIView * senderView = self.sourceView;
    if ([senderView isKindOfClass:[UIButton class]]) {
        UIButton * button = (UIButton*)senderView;
        button.selected = selected;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setSenderSelected:NO];
}

- (void)onSwipeDownReco:(id)sender
{
    [self dismiss];
}


#pragma mark UIContentContainer Protocol

- (void) updatePreferredContentSize
{
    self.preferredContentSize = CGSizeMake(MAX (_preferredWidth, self.contentViewController.preferredContentSize.width),
                      self.contentViewController.preferredContentSize.height + kHeaderHeight);
}


#pragma mark UIAdaptivePresentationControllerDelegate

//make popovers non-fullscreen on iPhone

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection
{
    return UIModalPresentationNone;
}


#pragma mark - Dismiss Timer

- (void) updateDismissTimer
{
    if (_autoDismissTimeInterval > 1) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:self.autoDismissTimeInterval];
    }
}

- (void) dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Properties

- (void) setTitleBarColor:(UIColor *)titleBarColor
{
    self.titleLabel.backgroundColor = titleBarColor;
}

- (UIColor*)titleBarColor
{
    return self.view.backgroundColor;
}

- (void) setCanOverlapSourceViewRect:(BOOL)canOverlapSourceViewRect
{
    //not supported below ios 9
    if ([self.popoverPresentationController respondsToSelector:@selector(setCanOverlapSourceViewRect:)]) {
        self.popoverPresentationController.canOverlapSourceViewRect = canOverlapSourceViewRect;
    }
}

- (BOOL) canOverlapSourceViewRect
{
    //not supported below ios 9
    if ([self.popoverPresentationController respondsToSelector:@selector(canOverlapSourceViewRect)]) {
        return self.popoverPresentationController.canOverlapSourceViewRect;
    }
    return NO;
}

- (void)contentViewControllerDidSelect
{
//    [self dismiss];
    [self updateDismissTimer];
}

@end

