//
//  ywbanner.m
//  OCPractice
//
//  Created by 娄耀文 on 2017/9/24.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import "ywbanner.h"
#import "ywbannerItem.h"

#define YW_FOOTER_WIDTH 80.0 //footer width

@interface ywbanner () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *ywCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *ywLayout;
@property (nonatomic, strong) ywfooter *footer;

@property (nonatomic, strong) NSTimer   *timer;
@property (nonatomic, assign) NSInteger itemsCount;

@end

@implementation ywbanner

@synthesize shouldLoop         = _shouldLoop;
@synthesize automaticScroll    = _automaticScroll;
@synthesize autoScrollInterval = _autoScrollInterval;
@synthesize pageControl        = _pageControl;

static NSString *banner_Item   = @"ywbannerItem";
static NSString *banner_Footer = @"ywbannerFooter";

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
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.ywLayout.itemSize = self.bounds.size;
    self.ywLayout.footerReferenceSize = CGSizeMake(YW_FOOTER_WIDTH, self.frame.size.height);
    self.ywCollectionView.frame = self.bounds;
    [self.ywCollectionView setContentInset:UIEdgeInsetsZero];
    [self.ywCollectionView reloadData];
    
    [self initDefaultIndex];
}

#pragma mark - 重载
- (void)reloadData {
    if (!self.dataSource || self.itemsCount == 0) {
        return;
    }
    self.pageControl.numberOfPages = self.itemsCount;
    [self.ywCollectionView reloadData];
}

- (void)initDefaultIndex {
    if (self.itemsCount == 0) {
        return;
    }
    self.pageControl.currentPage = 0;
    if (self.shouldLoop) {
        [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else {
        [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    [self reloadData];
    [self startTimer];
}

#pragma mark - timer
- (void)startTimer {
    
    if (!_automaticScroll || self.itemsCount <= 1) {
        return;
    }
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollToNextItem {
    
    NSIndexPath *currentIndexPath = [[self.ywCollectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    
    if (self.shouldLoop) {
        
        [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    } else {
        
        if ((currentItem % self.itemsCount) == self.itemsCount - 1) {
            // the last one
            [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } else {
            [self.ywCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.shouldLoop) {
        return self.itemsCount * 3;
    } else {
        return self.itemsCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ywbannerItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_Item forIndexPath:indexPath];
    if ([_dataSource respondsToSelector:@selector(ywbanner:viewOfItemAtIndex:)]) {
        cell.itemView = [_dataSource ywbanner:self viewOfItemAtIndex:indexPath.row % self.itemsCount];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath {
    
    UICollectionReusableView *footer = nil;
    if(kind == UICollectionElementKindSectionFooter) {
        
        footer = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_Footer forIndexPath:theIndexPath];
        self.footer = (ywfooter *)footer;
        
        // 配置footer的提示语
        if ([self.dataSource respondsToSelector:@selector(ywbanner:titleForFooler:)]) {
            self.footer.normalTips  = [self.dataSource ywbanner:self titleForFooler:ywFooterNormal];
            self.footer.triggerTips = [self.dataSource ywbanner:self titleForFooler:ywFooterTrigger];
        }
    }
    if (self.showFooter) {
        self.footer.hidden = NO;
    } else {
        self.footer.hidden = YES;
    }
    return footer;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([_delegate respondsToSelector:@selector(ywbanner:didSelectedItemAtIndex:)]) {
        [_delegate ywbanner:self didSelectedItemAtIndex:indexPath.row % self.itemsCount];
    }
}


/**
 *  更新currentPage & 切换当前cell到中间实现循环
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger index;
    if (cell.frame.origin.x > collectionView.contentOffset.x) {
        /* 右滑 */
        index = ABS(ceilf(collectionView.contentOffset.x/self.bounds.size.width));
    } else {
        /* 左滑 */
        index = ABS(floorf(collectionView.contentOffset.x/self.bounds.size.width));
    }
    if (self.shouldLoop && self.itemsCount != 1) {
        if (index >= self.itemsCount * 2) {
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        } else if (index < self.itemsCount) {
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsCount + index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    self.pageControl.currentPage = index % self.itemsCount;
}

#pragma mark - scrollView delegate
/* 用户开始滑动 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

/* 用户停止滑动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
}

#pragma mark - footer
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.showFooter) return;
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemsCount - 1)));

    if (footerDisplayOffset > 0) {
        // 开始出现footer
        if (footerDisplayOffset > YW_FOOTER_WIDTH) {
            if (lastOffset > 0) return;
            self.footer.state = ywFooterTrigger;
        } else {
            if (lastOffset < 0) return;
            self.footer.state = ywFooterNormal;
        }
        lastOffset = footerDisplayOffset - YW_FOOTER_WIDTH;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!self.showFooter) return;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemsCount - 1)));
    if (footerDisplayOffset > YW_FOOTER_WIDTH) {
        if ([self.delegate respondsToSelector:@selector(ywBannerFooterDidTrigger:)]) {
            [self.delegate ywBannerFooterDidTrigger:self];
        }
    }
}

#pragma mark - dataSource
- (NSInteger)itemsCount {
    
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInBannerView:)]) {
        return [_dataSource numberOfItemsInBannerView:self];
    }
    return 0;
}

- (void)setDataSource:(id<ywbannerDataSource>)dataSource {
    
    _dataSource = dataSource;
    [self initDefaultIndex];
}

/**
 *  是否无限循环
 */
- (BOOL)shouldLoop {
    if (self.itemsCount <= 1 || self.showFooter) {
        return NO;
    }
    return _shouldLoop;
}

- (void)setShouldLoop:(BOOL)shouldLoop {
    _shouldLoop = shouldLoop;
    [self initDefaultIndex];
}

/**
 *  是否自动滚动
 */
- (BOOL)automaticScroll {
    if (self.itemsCount <= 1) {
        return NO;
    }
    return _automaticScroll;
}

- (void)setAutomaticScroll:(BOOL)automaticScroll {
    _automaticScroll = automaticScroll;
    if (automaticScroll) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

/**
 *  是否显示footer
 */
- (void)setShowFooter:(BOOL)showFooter {
    _showFooter = showFooter;
    [self initDefaultIndex];
}


/**
 *  自动滚动时间间隔
 */
- (CGFloat)autoScrollInterval {
    if (!_autoScrollInterval) {
        _autoScrollInterval = 2.0; //default 2s
    }
    return _autoScrollInterval;
}

- (void)setAutoScrollInterval:(CGFloat)autoScrollInterval {
    _autoScrollInterval = autoScrollInterval;
    [self startTimer];
}

- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0,
                                        self.bounds.size.height - 36,
                                        self.bounds.size.width,
                                        36); /* default frame */
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return _pageControl;
}

- (void)setPageControl:(UIPageControl *)pageControl {

    [_pageControl removeFromSuperview];
    _pageControl = pageControl;
    
    // 添加新pageControl
    _pageControl.userInteractionEnabled = NO;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    [self initDefaultIndex];
}

#pragma mark - collectionView
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
        
        /* register cell */
        [_ywCollectionView registerClass:[ywbannerItem class] forCellWithReuseIdentifier:banner_Item];
        /* register footer */
        [_ywCollectionView registerClass:[ywfooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_Footer];
        //_ywCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, -YW_FOOTER_WIDTH);
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
