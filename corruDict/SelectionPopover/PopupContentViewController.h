//
//  PopupContentViewController.h
//  spectrum-eye
//
//  Created by oleg.naumenko on 9/2/18.
//  Copyright © 2018 Oleg Naumenko. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PopupContentViewControllerDelegate <NSObject>

- (void) contentViewControllerDidSelect;

@end


@protocol PopupContentViewController <NSObject>

@property (nonatomic, weak) id <PopupContentViewControllerDelegate> delegate;

@end
