//
//  ZMTitleView.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/18.
//

#import "ZMTitleView.h"

@interface ZMTitleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation ZMTitleView

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if(self) {
        _titles = titles;
        _selectedIndex = 0;
        _itemMargin = 10;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 67895432 + i;
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.buttons.count == 0 || self.buttons.count != self.titles.count) {
        return;
    }
    
    CGFloat contentWidth = 0.f;
    UIButton *lastButton = nil;
    for (NSInteger i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        CGFloat itemWidth = [[self class] getWidthWithString:title font:self.itemFont] + self.itemMargin;
        contentWidth += itemWidth;
        UIButton *button = self.buttons[i];
        CGFloat x = lastButton == nil ? 0 : lastButton.frame.size.width + lastButton.frame.origin.x;
        button.frame = CGRectMake(x, 0, itemWidth, self.scrollView.bounds.size.height);
        lastButton = button;
    }
    contentWidth = fmax(contentWidth, self.scrollView.bounds.size.width);
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.bounds.size.height);
    [self moveIndicatorView];
}

- (void)moveIndicatorView {
    
}

- (void)buttonAction:(UIButton *)button {
        
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
@end
