//
//  ywbanner.m
//  OCPractice
//
//  Created by 娄耀文 on 2017/9/24.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import "ywbanner.h"
#import "ywbannerItem.h"

@interface ywbanner () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *ywCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *ywLayout;

@property (nonatomic, assign) NSInteger itemsCount;

@end

@implementation ywbanner

@synthesize shouldLoop = _shouldLoop;

static NSString *banner_Item = @"ywbannerItem";

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {

    [self addSubview:self.ywCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ywLayout.itemSize = self.bounds.size;
    self.ywCollectionView.frame = self.bounds;
    [self.ywCollectionView reloadData];
    [self initDefaultIndex];
}

#pragma mark - 重载
- (void)reloadData {
    if (!self.dataSource || self.itemsCount == 0) {
        return;
    }
    [self.ywCollectionView reloadData];
}

- (void)initDefaultIndex {
    if (self.itemsCount == 0) {
        return;
    }
    if (self.shouldLoop) {
        [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else {
        [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}


#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.shouldLoop) {
        return self.itemsCount * 3;
    } else {
        return self.itemsCount * 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ywbannerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_Item forIndexPath:indexPath];
    if ([_dataSource respondsToSelector:@selector(ywbanner:viewOfItemAtIndex:)]) {
        cell.itemView = [_dataSource ywbanner:self viewOfItemAtIndex:indexPath.row % self.itemsCount];
    }
    return cell;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([_delegate respondsToSelector:@selector(ywbanner:didSelectedItemAtIndex:)]) {
        [_delegate ywbanner:self didSelectedItemAtIndex:indexPath.row % self.itemsCount];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  更新currentPage & 切换当前cell到中间实现复用
     */
    //NSIndexPath *index = [[collectionView indexPathsForVisibleItems] firstObject];
    NSInteger index;
    if (cell.frame.origin.x > collectionView.contentOffset.x) {
        /* 右滑 */
        index = ABS(ceilf(collectionView.contentOffset.x/self.bounds.size.width));
    } else {
        /* 左滑 */
        index = ABS(floorf(collectionView.contentOffset.x/self.bounds.size.width));
    }
    if (index >= self.itemsCount * 2) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (index < self.itemsCount) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount + index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - dataSource
- (NSInteger)itemsCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInBannerView:)]) {
        return [_dataSource numberOfItemsInBannerView:self];
    }
    return 0;
}

#pragma mark - scrollView delegate
/* 用户开始滑动 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

/* 用户停止滑动 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark - dataSource
- (BOOL)shouldLoop {
    if (self.itemsCount <= 1) {
        return NO;
    }
    return _shouldLoop;
}

- (void)setShouldLoop:(BOOL)shouldLoop {
    _shouldLoop = shouldLoop;
    [self reloadData];
}

#pragma mark - getter
- (UICollectionView *)ywCollectionView {
    
    if (_ywCollectionView == nil) {
        _ywCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.ywLayout];
        _ywCollectionView.pagingEnabled = YES;
        _ywCollectionView.alwaysBounceHorizontal = YES;
        _ywCollectionView.showsHorizontalScrollIndicator = NO;
        _ywCollectionView.scrollsToTop = NO;
        _ywCollectionView.backgroundColor = [UIColor clearColor];
        _ywCollectionView.delegate = self;
        _ywCollectionView.dataSource = self;
        
        /* 注册Cell */
        [_ywCollectionView registerClass:[ywbannerItem class] forCellWithReuseIdentifier:banner_Item];
    }
    return _ywCollectionView;
}

- (UICollectionViewFlowLayout *)ywLayout {
    
    if (_ywLayout == nil) {
        _ywLayout = [[UICollectionViewFlowLayout alloc] init];
        _ywLayout.minimumInteritemSpacing = 0;
        _ywLayout.minimumLineSpacing = 0;
        _ywLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _ywLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _ywLayout;
}





@end
