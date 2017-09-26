//
//  ywbanner.h
//  OCPractice
//
//  Created by 娄耀文 on 2017/9/24.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ywbannerDelegate, ywbannerDataSource;
@interface ywbanner : UIView

/**
 *  循环播放 default = NO
 */
@property (nonatomic, assign) BOOL shouldLoop;
/**
 *  自动滚动 default = NO
 */
@property (nonatomic, assign) BOOL automaticScroll;

/**
 *  自动滚动时间间隔 default = 2s
 */
@property (nonatomic, assign) CGFloat autoScrollInterval;

/**
 *  pageControl 可自定义配置
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<ywbannerDelegate>   delegate;
@property (nonatomic, weak) id<ywbannerDataSource> dataSource;
@end

@protocol ywbannerDelegate <NSObject>
@optional
- (void)ywbanner:(ywbanner *)banner didSelectedItemAtIndex:(NSInteger)index;

@end

@protocol ywbannerDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInBannerView:(ywbanner *)banner;
- (UIView  *)ywbanner:(ywbanner *)banner viewOfItemAtIndex:(NSInteger)index;

@end
