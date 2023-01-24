//
//  SubViewController.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/22.
//

#import "SubViewController.h"

@interface SubViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self randomColor];
  

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView = tableView;
    [tableView reloadData];
    /// 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.items = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8"];
        [self.tableView reloadData];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UIColor *)randomColor  {
    CGFloat red = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    CGFloat blue = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
    return color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear 子");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear 子");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(subViewControllerDidScroll:)]) {
        [self.delegate subViewControllerDidScroll:scrollView];
    }
}

@end
