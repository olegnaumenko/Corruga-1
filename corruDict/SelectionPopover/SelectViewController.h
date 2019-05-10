//
//  SelectViewController.h
//  spectrum-eye-ios
//
//  Created by oleg.naumenko on 9/2/18.
//  Copyright © 2018 Oleg Naumenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupContentViewController.h"
//#import "VOXPopoverPreseter.h"

NS_ASSUME_NONNULL_BEGIN


typedef BOOL(^SelectionBlock)(NSInteger index);
typedef void(^RangeSelectionBlock)(NSInteger index, NSMutableArray<NSArray<NSNumber*>*>* allValues);

@interface SelectViewController : UIViewController<PopupContentViewController>

+ (instancetype) withValues:(NSArray*)values
               currentIndex:(NSUInteger)selectedIndex
             selectionBlock:(SelectionBlock)selectionHandler;

- (instancetype)initWithValues:(NSArray*)values
                 currentIndex:(NSUInteger)selectedIndex
                selectionBlock:(SelectionBlock)selectionHandler;

@property (nonatomic, assign) NSInteger currentSelectionIndex;
@property (nonatomic, assign) NSTextAlignment cellTextAlignment;
@property (nonatomic, readonly) NSArray * values;

@property (nonatomic, readonly) UITableView * tableView;

@end

NS_ASSUME_NONNULL_END
