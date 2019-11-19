//
//  SelectViewController.m
//  spectrum-eye-ios
//
//  Created by oleg.naumenko on 9/2/18.
//  Copyright © 2018 Oleg Naumenko. All rights reserved.
//

#import "SelectViewController.h"

CGFloat const kCellHeight = 44.0;

NSString * const kSelectableValueCell = @"SelectableValueCell";

@interface SelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy)   SelectionBlock selectionBlock;

@end

@implementation SelectViewController

@synthesize delegate;

+ (instancetype) withValues:(NSArray*)values
                  currentIndex:(NSUInteger)selectedIndex
                selectionBlock:(SelectionBlock)selectionHandler
{
    return [[self alloc] initWithValues:values currentIndex:selectedIndex selectionBlock:selectionHandler];
}

- (instancetype)initWithValues:(NSArray*)values
                  currentIndex:(NSUInteger)selectedIndex
                selectionBlock:(SelectionBlock)selectionHandler
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _values = values;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _selectionBlock = selectionHandler;
        _currentSelectionIndex = selectedIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect tableRect = self.view.bounds;
    
    self.tableView.frame = tableRect;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSelectableValueCell];
    self.tableView.bounces = NO;
    
    [self.view addSubview:self.tableView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath * ip = [NSIndexPath indexPathForRow: self.currentSelectionIndex inSection:0];
    if (self.values.count > ip.row) {
        [self.tableView selectRowAtIndexPath: ip animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark - UITableView Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id value = self.values[indexPath.row];
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSelectableValueCell];
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray * arr = (NSArray*)value;
        if (arr.count > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", arr[0]];
        } if (arr.count > 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", arr[1]];
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", value];
    }

    cell.textLabel.textAlignment = self.cellTextAlignment;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.backgroundColor = UIColor.clearColor;
    if (@available(iOS 13.0, *)) {
        cell.textLabel.textColor = UIColor.labelColor;
        cell.detailTextLabel.textColor = UIColor.secondaryLabelColor;
    } else {
        cell.textLabel.textColor = UIColor.darkTextColor;
        cell.detailTextLabel.textColor = UIColor.grayColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectionIndex = indexPath.row;
    BOOL dismiss = YES;
    if (self.selectionBlock) {
        dismiss = _selectionBlock(self.currentSelectionIndex);
    }
    [self.delegate contentViewControllerDidSelect];
}

- (CGSize) preferredContentSize
{
    NSUInteger cellCount = self.values.count ? : 2;
    return CGSizeMake(100, cellCount * kCellHeight + 10);
}

- (CGFloat)presentableControllerContentHeight
{
    return self.preferredContentSize.height;
}

@end

