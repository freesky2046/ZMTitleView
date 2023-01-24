//
//  ZMPageView.h
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/21.
//

#import <UIKit/UIKit.h>

@class  ZMPageView;
@protocol ZMPageViewDelegate <NSObject>

- (void)pageViewDidChangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)pageViewDidScroll:(ZMPageView *)pageView
               startIndex:(NSInteger)startIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end


@interface ZMPageView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<ZMPageViewDelegate> delegate;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

//// 初始化的时候要设置正确的尺寸，不支持后面在改frame
- (instancetype)initWithFrame:(CGRect)frame
              viewControllers:(NSArray<UIViewController *> *)viewControllers
             parentController:(UIViewController *)parentVC;
- (UIViewController *)currentVC;

@end


