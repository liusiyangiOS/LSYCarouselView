//
//  LSYCarouselView.m
//  PrivateProject
//
//  Created by liusiyang on 2023/12/12.
//

#import "LSYCarouselView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LSYCarouselViewCell : UICollectionViewCell

@property (nonatomic, weak) id data;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LSYCarouselViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end

@interface LSYCarouselView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSInteger _numberOfItems;
    NSInteger _currentRow;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timerAnimate;
@end

@implementation LSYCarouselView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAnimation];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)startAnimationWithContent:(NSArray *)contents{
    if (_contents != contents) {
        _contents = contents;
        [self stopAnimation];
        if (_contents.count <= 1) {
            _currentRow = 0;
            _numberOfItems = _contents.count;
            [_pageControl removeFromSuperview];
            _pageControl = nil;
        }else{
            [self startAnimateTimer];
            _numberOfItems = 1000000;
            _currentRow = _numberOfItems / 2 - (_numberOfItems / 2 % _contents.count);
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = _contents.count;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                _collectionView.contentOffset = CGPointMake(_collectionView.frame.size.width * _currentRow, 0);
                if ([_delegate respondsToSelector:@selector(carouselView:didShowContentAtIndex:)]) {
                    [_delegate carouselView:self didShowContentAtIndex:_currentRow % _contents.count];
                }
            });
        }
        [_collectionView reloadData];
    }
}

- (void)stopAnimation {
    if (_timerAnimate) {
        [_timerAnimate invalidate];
        _timerAnimate = nil;
    }
}

- (void)startAnimateTimer {
    if (self.contents.count <= 1) {
        //没有数据或者只有一条数据
        return;
    }
    if (_timerAnimate) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.timerAnimate = [NSTimer scheduledTimerWithTimeInterval:self.animateInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf scrollNext];
    }];
}

- (void)scrollNext{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentRow + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)updateCurrentRow{
    NSInteger currentRow = _collectionView.contentOffset.x / _collectionView.frame.size.width;
    NSLog(@"---------%ld",currentRow);
    if (_currentRow != currentRow) {
        _currentRow = currentRow;
        _pageControl.currentPage = currentRow % _contents.count;
        if ([_delegate respondsToSelector:@selector(carouselView:didShowContentAtIndex:)]) {
            [_delegate carouselView:self didShowContentAtIndex:currentRow % _contents.count];
        }
    }
}

#pragma mark - notification

- (void)applicationWillEnterForeground {
    [self startAnimateTimer];
}

// APP进后台，关闭定时器
- (void)applicationDidEnterBackground {
    [self stopAnimation];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAnimation];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startAnimateTimer];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updateCurrentRow];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateCurrentRow];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _numberOfItems;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row % _contents.count;
    id data = _contents[index];
    LSYCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell.data != data) {
        cell.data = data;
        if ([_delegate respondsToSelector:@selector(carouselView:configImageViewIfNeed:)]) {
            [_delegate carouselView:self configImageViewIfNeed:cell.imageView];
        }
        if (![data isKindOfClass:UIImage.class] &&
            ![data isKindOfClass:NSString.class]) {
            if (_delegate && [_delegate respondsToSelector:@selector(carouselView:imageContentWithData:)]) {
                data = [_delegate carouselView:self imageContentWithData:data];
            }
        }
        if ([data isKindOfClass:UIImage.class]) {
            cell.imageView.image = data;
        }else if ([data isKindOfClass:NSString.class]){
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data]];
        }else{
            cell.imageView.image = nil;
        }
    }
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row % _contents.count;
    if (_delegate && [_delegate respondsToSelector:@selector(carouselView:didClickContentAtIndex:)]) {
        [_delegate carouselView:self didClickContentAtIndex:index];
    }
}

#pragma mark - setetr & getter

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:LSYCarouselViewCell.class forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _pageControl;
}

-(NSTimeInterval)animateInterval{
    if (_animateInterval == 0) {
        _animateInterval = 5;
    }
    return _animateInterval;
}

@end
