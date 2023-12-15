//
//  LSYCarouselView.h
//  PrivateProject
//
//  Created by liusiyang on 2023/12/12.
//

#import <UIKit/UIKit.h>
@class LSYCarouselView;
NS_ASSUME_NONNULL_BEGIN

@protocol LSYCarouselViewDelegate <NSObject>

@optional
/** 一般用于埋点 */
- (void)carouselView:(LSYCarouselView *)view didShowContentAtIndex:(NSInteger)index;

- (void)carouselView:(LSYCarouselView *)view didClickContentAtIndex:(NSInteger)index;

- (void)carouselView:(LSYCarouselView *)view setImageView:(UIImageView *)imageV withData:(id)data;

@end

@interface LSYCarouselView : UIView

/** 轮播的时间间隔,默认2s */
@property (assign, nonatomic) NSTimeInterval animateInterval;

@property (nonatomic, strong, readonly) NSArray *contents;

@property (weak, nonatomic) id<LSYCarouselViewDelegate> delegate;

/**
 默认会将数组中的元素当成imageUrl或image进行解析
 如果不是这两种,则需要实现代理自行解析赋值
 */
- (void)startAnimationWithContent:(NSArray *)contents;

@end

NS_ASSUME_NONNULL_END
