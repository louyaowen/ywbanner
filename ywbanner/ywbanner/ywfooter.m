//
//  ywfooter.m
//  ywbanner
//
//  Created by 娄耀文 on 2017/9/27.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import "ywfooter.h"

@interface ywfooter ()

@end

@implementation ywfooter

@synthesize normalTips  = _normalTips;
@synthesize triggerTips = _triggerTips;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrowImg];
        [self addSubview:self.tipsLable];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - setState
- (void)setState:(ywFooterState)state {
    _state = state;
    if (state == ywFooterNormal) {
        
        self.tipsLable.text = self.normalTips;
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImg.transform = CGAffineTransformMakeRotation(0);
        }];
    } else if (state == ywFooterTrigger) {
        
        self.tipsLable.text = self.triggerTips;
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImg.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

#pragma mark - getter & setter
- (NSString *)normalTips {
    
    if (_normalTips == nil) {
        _normalTips = @"拖动查看详情";
    }
    return _normalTips;
}

- (NSString *)triggerTips {
    
    if (_triggerTips == nil) {
        _triggerTips = @"释放查看详情";
    }
    return _triggerTips;
}

- (void)setNormalTips:(NSString *)normalTips {
    _normalTips = normalTips;
    if (self.state == ywFooterNormal) {
        self.tipsLable.text = normalTips;
    }
}

- (void)setTriggerTips:(NSString *)triggerTips {
    _triggerTips = triggerTips;
    if (self.state == ywFooterTrigger) {
        self.tipsLable.text = triggerTips;
    }
}

- (UIImageView *)arrowImg {
    
    if (_arrowImg == nil) {
        UIImage *img = [UIImage imageNamed:@"ywbanner.bundle/arrowImg.png"];
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.frame = CGRectMake(self.bounds.size.width/2 - img.size.width - 3,
                                    (self.bounds.size.height - img.size.height)/2,
                                     img.size.width,
                                     img.size.height);
        _arrowImg.image = img;
    }
    return _arrowImg;
}

- (UILabel *)tipsLable {
    
    if (_tipsLable == nil) {
        _tipsLable = [[UILabel alloc] init];
        _tipsLable.frame = CGRectMake(self.bounds.size.width/2 + 3,
                                      0,
                                      13,
                                      self.bounds.size.height);
        _tipsLable.font = [UIFont systemFontOfSize:13];
        _tipsLable.numberOfLines = 0;
        _tipsLable.textColor = [UIColor grayColor];
    }
    return _tipsLable;
}


@end



