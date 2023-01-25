//
//  ZMTitleView.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/18.
//

#import "ZMTitleView.h"

#define kButtonTag 666

@interface ZMTitleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation ZMTitleView

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if(self) {
        [self initProerties];
        [self setupUI];
        self.titles  = titles;
        self.selectedIndex = 0;
    }
    return self;
}

- (void)initProerties {
    self.itemFont = [UIFont systemFontOfSize:15];
    self.normalColor = [UIColor grayColor];
    self.selectColor = [UIColor blackColor];
    self.indicatorColor = [UIColor yellowColor];
    self.itemMargin = 10;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *indicatorView = [[UIView alloc] init];
    [self.scrollView addSubview:indicatorView];
    indicatorView.backgroundColor = self.indicatorColor;
    self.indicatorView = indicatorView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if(self.buttons.count == 0) { /// 初始化的时候还没有button
        return;
    }
    UIButton *lastButton = [self.scrollView viewWithTag:(kButtonTag + _selectedIndex)];
    UIButton *button  = [self.scrollView viewWithTag:(kButtonTag + selectedIndex)];
    [lastButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectColor forState:UIControlStateNormal];
    _selectedIndex = selectedIndex;
    [self.scrollView scrollRectToVisible:CGRectMake(button.center.x - self.scrollView.frame.size.width / 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    if(self.buttons == nil) {
        self.buttons = [NSMutableArray array];
    }
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kButtonTag + i;
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin {
    _itemMargin = itemMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.buttons.count == 0 || self.buttons.count != self.titles.count) {
        return;
    }
    self.scrollView.frame = self.bounds;
    
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
    NSInteger selectedIndex = self.selectedIndex;
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:(selectedIndex + kButtonTag)];
    self.indicatorView.frame = CGRectMake(button.center.x - 40/2 , self.scrollView.bounds.size.height - 4, 40, 4);
}

- (void)buttonAction:(UIButton *)button {
    NSInteger index = button.tag - kButtonTag;
    if(index == self.selectedIndex) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(titleViewDidChangeFromIndex:toIndex:)]) {
        [self.delegate titleViewDidChangeFromIndex:self.selectedIndex toIndex:index];
    }
    self.selectedIndex = index;
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(titleViewWillBeginDrag:)]) {
        [self.delegate titleViewWillBeginDrag:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([self.delegate respondsToSelector:@selector(titleViewDidEndDrag:)]){
        [self.delegate titleViewDidEndDrag:self];
    }
}

@end
