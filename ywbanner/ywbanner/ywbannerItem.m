//
//  ywbannerItem.m
//  OCPractice
//
//  Created by 娄耀文 on 2017/9/24.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import "ywbannerItem.h"

@implementation ywbannerItem
@synthesize itemView = _itemView;

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.itemView.frame = self.bounds;
}

#pragma mark - getter & setter
- (UIView *)itemView {
    
    if (_itemView == nil) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}

- (void)setItemView:(UIView *)itemView {
    if (_itemView) {
        [_itemView removeFromSuperview];
    }
    _itemView = itemView;
    [self addSubview:_itemView];
}

@end
