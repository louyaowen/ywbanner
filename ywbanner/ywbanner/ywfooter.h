//
//  ywfooter.h
//  ywbanner
//
//  Created by 娄耀文 on 2017/9/27.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ywFooterState) {
    ywFooterNormal = 0, //正常状态
    ywFooterTrigger,    //拖拽至触发位置
};

@interface ywfooter : UICollectionReusableView

@property (nonatomic, assign) ywFooterState state;
@property (nonatomic, strong) UIImageView   *arrowImg;
@property (nonatomic, strong) UILabel       *tipsLable;
@property (nonatomic, strong) NSString      *normalTips;
@property (nonatomic, strong) NSString      *triggerTips;

@end
