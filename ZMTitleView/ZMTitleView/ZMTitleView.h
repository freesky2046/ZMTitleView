//
//  ZMTitleView.h
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/18.
//

#import <UIKit/UIKit.h>

@class ZMTitleView;

@protocol ZMTitleViewDelegate <NSObject>

- (void)titleViewWillBeginDrag:(ZMTitleView *)titleView;
- (void)titleViewDidEndDrag:(ZMTitleView *)titleView;
- (void)titleViewDidChangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface ZMTitleView : UIView
/*
 定制UI样式
 */
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, assign) CGFloat itemMargin;

// 标题
@property (nonatomic, strong) NSArray<NSString *> *titles;// --->标题会让布局更新

// 选中的哪一个
@property (nonatomic, assign) NSInteger selectedIndex; /// --------> setter

@property (nonatomic, weak) id<ZMTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray<NSString *> *)titles;
@end


