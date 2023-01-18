//
//  ZMTitleView.h
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/18.
//

#import <UIKit/UIKit.h>


@interface ZMTitleView : UIView
/*
 定制UI样式
 */
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, assign) CGFloat itemMargin;

// 标题
@property (nonatomic, strong) NSArray<NSString *> *titles;

// 选中的哪一个
@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray<NSString *> *)titles;
@end


