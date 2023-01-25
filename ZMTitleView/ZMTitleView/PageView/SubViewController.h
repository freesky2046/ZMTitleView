//
//  SubViewController.h
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SubViewController;

@protocol SubViewControllerDelegate <NSObject>
- (void)subViewControllerDidScroll:(UIScrollView *)scrollView;
@end

@interface SubViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<SubViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL subCanScroll;

@end

NS_ASSUME_NONNULL_END
