//
//  ViewController.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/18.
//
#import "ZMTitleView.h"
#import "ViewController.h"
#import "ZMPageView.h"
#import "SubViewController.h"
#import "ZMMainTableView.h"

@interface ViewController ()<ZMTitleViewDelegate, ZMPageViewDelegate, UITableViewDelegate, UITableViewDataSource, SubViewControllerDelegate>

@property (nonatomic, strong) ZMMainTableView *mainTableView;
@property (nonatomic, strong) ZMTitleView *titleView;
@property (nonatomic, strong) ZMPageView *pageView;
@property (nonatomic, assign) BOOL mainCanScroll;
@property (nonatomic, assign) BOOL subCanScroll;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ZMMainTableView *tableView = [[ZMMainTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    
    UIView *headerView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self titleViewHeight] + [self imageViewHeight])];
    headerView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headerView;
    
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self imageViewHeight])];
    imageView.backgroundColor = [UIColor grayColor];
    [headerView addSubview:imageView];

   NSArray *titles =  @[@"11",@"22",@"33"];
    ZMTitleView *titleView = [[ZMTitleView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44) title:titles];
    titleView.delegate = self;
    titleView.itemMargin = 30;
    [headerView addSubview:titleView];
    self.titleView = titleView;

    NSMutableArray *vcs = [NSMutableArray array];
    for (NSString *title in titles) {
        SubViewController *vc = [[SubViewController alloc] init];
        vc.delegate = self;
        [vcs addObject:vc];
     }
    ZMPageView *pageView = [[ZMPageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - [self titleViewHeight]) viewControllers:vcs parentController:self];
    pageView.delegate = self;
    self.pageView = pageView;
    self.mainCanScroll = YES;
    tableView.noSimultaneouslyView = pageView.collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"父 viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"父 viewDidAppear");
}

- (void)titleViewWillBeginDrag:(ZMTitleView *)titleView {
    NSLog(@"willDrag");
}

- (void)titleViewDidEndDrag:(ZMTitleView *)titleView {
    NSLog(@"didDrag");
}

/// 只有手动触发的titleView改变才回调这里，代码调用赋值的并不调用这里
- (void)titleViewDidChangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"from %ld", fromIndex);
    NSLog(@"to %ld", toIndex);
    self.pageView.selectedIndex = toIndex;
}

- (void)pageViewDidChangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"from %ld", fromIndex);
    NSLog(@"to %ld", toIndex);
    self.titleView.selectedIndex = toIndex;
}

- (CGFloat)subPageHeight {
    return [UIScreen mainScreen].bounds.size.height  ;
}

- (CGFloat)titleViewHeight {
    return 40;
}

- (CGFloat)imageViewHeight {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height - [self titleViewHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(self.pageView.superview == nil) {
        [cell.contentView addSubview:self.pageView];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.mainTableView) {
        if(!self.mainCanScroll) {
            self.mainTableView.contentOffset = CGPointMake(0, [self imageViewHeight]);
            self.subCanScroll = YES;
        }
        else if (self.mainTableView.contentOffset.y >= [self imageViewHeight]) {
            self.mainTableView.contentOffset = CGPointMake(0, [self imageViewHeight]);
            self.mainCanScroll = NO;
            self.subCanScroll = YES;
        }else {
           
        }
    }else {
        if(!self.subCanScroll) {
            self.subTableView.contentOffset = CGPointMake(0, 0);
        }
        else if (self.subTableView.contentOffset.y <= 0) {
            self.mainCanScroll = YES;
            self.subCanScroll = NO;
        }else {
            
        }
    }
}

- (void)subViewControllerDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (UITableView *)subTableView {
   SubViewController *sub = (SubViewController *)[self.pageView currentVC];
    return sub.tableView;
}

@end
