//
//  ZMPageView.h
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/21.
//

#import <UIKit/UIKit.h>

@protocol ZMPageViewDelegate <NSObject>

- (void)pageViewDidChangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end


@interface ZMPageView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<ZMPageViewDelegate> delegate;

//// 初始化的时候要设置正确的尺寸，不支持后面在改frame
- (instancetype)initWithFrame:(CGRect)frame
              viewControllers:(NSArray<UIViewController *> *)viewControllers
             parentController:(UIViewController *)parentVC;


@end


