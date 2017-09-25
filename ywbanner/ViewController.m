//
//  ViewController.m
//  ywbanner
//
//  Created by 娄耀文 on 2017/9/25.
//  Copyright © 2017年 louyw. All rights reserved.
//

#import "ViewController.h"
#import "ywbanner.h"

@interface ViewController () <ywbannerDelegate, ywbannerDataSource>

@property (nonatomic, strong) ywbanner *bannerView;
@property (nonatomic, strong) NSArray  *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ywbanner";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.bannerView];
    
    _dataSource = @[@"http://e.hiphotos.baidu.com/image/pic/item/562c11dfa9ec8a13bf872720fe03918fa1ecc055.jpg",
                    @"http://pic23.nipic.com/20120908/10639194_105138442151_2.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506316059430&di=7bb2ce04a9319f7ab78158b8a7613193&imgtype=0&src=http%3A%2F%2Fwww.zhlzw.com%2FUploadFiles%2FArticle_UploadFiles%2F201204%2F20120412123925693.jpg"];
}

#pragma mark - banner delegate
- (void)ywbanner:(ywbanner *)banner didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"banner: %ld - %ld",banner.tag,index);
}

#pragma mark - banner dataSource
- (NSInteger)numberOfItemsInBannerView:(ywbanner *)banner {
    return _dataSource.count;
}

- (UIView *)ywbanner:(ywbanner *)banner viewOfItemAtIndex:(NSInteger)index {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dataSource objectAtIndex:index]]]];
    return imageView;
}



- (ywbanner *)bannerView {
    
    if (_bannerView == nil) {
        _bannerView = [[ywbanner alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 220)];
        _bannerView.shouldLoop = YES;
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        _bannerView.backgroundColor = [UIColor yellowColor];
    }
    return _bannerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
