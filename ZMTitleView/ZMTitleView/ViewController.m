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

@interface ViewController ()<ZMTitleViewDelegate, ZMPageViewDelegate>

@property (nonatomic, strong) ZMTitleView *titleView;
@property (nonatomic, strong) ZMPageView *pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   NSArray *titles =  @[@"11",@"22",@"33",
                                                                                                                                        @"44",@"55",@"66",
                                                                                                                                        @"77",@"88",@"99",
                                                                                                                                        @"100",@"111"
                                                                                                                                        
   ];
    ZMTitleView *titleView = [[ZMTitleView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44) title:titles];
    titleView.delegate = self;
    titleView.itemMargin = 30;
    [self.view addSubview:titleView];
    self.titleView = titleView;

    NSMutableArray *vcs = [NSMutableArray array];
    for (NSString *title in titles) {
        UIViewController *vc = [[SubViewController alloc] init];
        vc.view.backgroundColor = [self  randomColor];
        [vcs addObject:vc];
     }
    ZMPageView *pageView = [[ZMPageView alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height + titleView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, 400) viewControllers:vcs parentController:self];
    [self.view addSubview:pageView];
    pageView.delegate = self;
    self.pageView = pageView;
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

- (UIColor *)randomColor  {
    CGFloat red = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    CGFloat blue = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1];
    return color;
}

@end
