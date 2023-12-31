//
//  ViewController.m
//  LSYCarouselViewDemo
//
//  Created by liusiyang on 2023/12/15.
//

#import "ViewController.h"
#import "LSYCarouselView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<LSYCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    UIImage *image = [UIImage imageNamed:@"BannerImage"];
    
    LSYCarouselView *carouselView = [[LSYCarouselView alloc] init];
    carouselView.delegate = self;
    carouselView.animateInterval = 2;
    [self.view addSubview:carouselView];
    [carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
//        make.trailing.equalTo(self.view).offset(-0.5);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    [carouselView startAnimationWithContent:@[
        @"https://img1.baidu.com/it/u=1367681958,1204903076&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500",
        image,
        @{
            @"activityId":@"111",
            @"activityName":@"满减大促销!",
            @"imageUrl":@"https://img1.baidu.com/it/u=1865592685,4088896322&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500",
        }
    ]];
}

#pragma mark - LSYCarouselViewDelegate

- (void)carouselView:(LSYCarouselView *)view didShowContentAtIndex:(NSInteger)index{
    NSLog(@"将要显示第%ld个图像",index);
}

- (void)carouselView:(LSYCarouselView *)view didClickContentAtIndex:(NSInteger)index{
    NSLog(@"点击了第%ld个图像",index);
}

- (id)carouselView:(LSYCarouselView *)view imageContentWithData:(id)data{
    return [data objectForKey:@"imageUrl"];
}

-(void)carouselView:(LSYCarouselView *)view configImageViewIfNeed:(UIImageView *)imageView{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
