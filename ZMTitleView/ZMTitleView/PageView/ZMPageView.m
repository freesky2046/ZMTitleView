//
//  ZMPageView.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/21.
//

#import "ZMPageView.h"

typedef enum : NSUInteger {
    ZMPageViewDragRight,
    ZMPageViewDragLeft,
    ZMPageViewDragBack,
} ZMPageViewDragDirection;

@interface ZMPageView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *childVC;
@property (nonatomic, assign) BOOL isManualDrag; // 当前是否是手动滑动
@property (nonatomic, assign) CGFloat lastOffsetX; // 上一个偏移值

@end

@implementation ZMPageView

- (instancetype)initWithFrame:(CGRect)frame
              viewControllers:(NSArray<UIViewController *> *)viewControllers
             parentController:(UIViewController *)parentVC {
    self = [super initWithFrame:frame];
    if(self) {
        self.parentViewController = parentVC;
        [self setupUI:viewControllers];
        self.selectedIndex = 0;
    }
    return self;
}

- (void)setupUI:(NSArray<UIViewController *> *)viewControllers {
    self.childVC = viewControllers;
    for (UIViewController *vc in viewControllers) {
        [self.parentViewController addChildViewController:vc];
    }
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if(selectedIndex < self.childVC.count && selectedIndex >= 0) {
        _selectedIndex = selectedIndex;
        self.isManualDrag = NO;
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * selectedIndex, 0) animated:NO];
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = self.bounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVC.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    NSInteger index = indexPath.row;
    if(index < self.childVC.count) {
        UIViewController *vc = self.childVC[index];
        [cell.contentView addSubview:vc.view];
        vc.view.frame = cell.contentView.bounds;
        [vc didMoveToParentViewController:self.parentViewController];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEnd];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self scrollViewDidEnd];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isManualDrag = YES;
    self.lastOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isManualDrag){
        return;
    }
    if(self.dragDirection == ZMPageViewDragRight) {
        NSLog(@"右边");
        NSInteger fromIndex = floor(self.lastOffsetX/scrollView.bounds.size.width);
        NSInteger toIndex = fromIndex + 1;
        toIndex = MIN(toIndex, self.childVC.count - 1);
        CGFloat progress =  (scrollView.contentOffset.x - self.lastOffsetX) / scrollView.bounds.size.width;
        if([self.delegate respondsToSelector:@selector(pageViewDidScroll:startIndex:toIndex:progress:)]){
            [self.delegate pageViewDidScroll:self startIndex:fromIndex toIndex:toIndex progress:progress];
        }
    }
    else if(self.dragDirection == ZMPageViewDragLeft) {
        NSLog(@"左边");
    }else {
        NSLog(@"返回");
    }
}

- (ZMPageViewDragDirection)dragDirection {
    
    if(self.collectionView.contentOffset.x - self.lastOffsetX > 0) {
        return ZMPageViewDragRight;
    }
    else if (self.collectionView.contentOffset.x - self.lastOffsetX < 0) {
        return ZMPageViewDragLeft;
    }
    return ZMPageViewDragBack;
}

- (void)scrollViewDidEnd {
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    NSInteger index = floor(contentOffsetX / self.collectionView.frame.size.width);
    index = MAX(index, 0);
    index = MIN(index, self.childVC.count - 1);
    if(index != _selectedIndex) {
        if([self.delegate respondsToSelector:@selector(pageViewDidChangeFromIndex:toIndex:)]){
            [self.delegate pageViewDidChangeFromIndex:_selectedIndex toIndex:index];
        }
        _selectedIndex = index;
    }
}

- (UIViewController *)currentVC {
   UIViewController *vc = self.childVC[self.selectedIndex];
    return vc;
}

@end
