//
//  ZMPageView.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/21.
//

#import "ZMPageView.h"

@interface ZMPageView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, strong) NSArray<UIViewController *> *childVC;

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

- (void)scrollViewDidEnd {
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    NSInteger index = (contentOffsetX / self.collectionView.frame.size.width);
    index = MAX(index, 0);
    index = MIN(index, self.childVC.count - 1);
    if(index != _selectedIndex) {
        if([self.delegate respondsToSelector:@selector(pageViewDidChangeFromIndex:toIndex:)]){
            [self.delegate pageViewDidChangeFromIndex:_selectedIndex toIndex:index];
        }
        _selectedIndex = index;
    }
}

@end
