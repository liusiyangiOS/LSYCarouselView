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
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
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
@end

@implementation LSYCarouselView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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
        //stopAnimation
        if (_contents.count <= 1) {
            _numberOfItems = _contents.count;
        }else{
            //startAnimation
            _numberOfItems = 1000000;
            [_collectionView reloadData];
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_numberOfItems/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentRow = [_collectionView indexPathsForVisibleItems].firstObject.row;
    if (_currentRow != currentRow && [_delegate respondsToSelector:@selector(carouselView:didShowContentAtIndex:)]) {
        [_delegate carouselView:self didShowContentAtIndex:currentRow % _contents.count];
    }
    _currentRow = [_collectionView indexPathsForVisibleItems].firstObject.row;
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
        if ([data isKindOfClass:UIImage.class]) {
            cell.imageView.image = data;
        }else if ([data isKindOfClass:NSString.class]){
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data]];
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(carouselView:setImageView:withData:)]) {
                [_delegate carouselView:self setImageView:cell.imageView withData:data];
            }else{
                cell.imageView.image = nil;
            }
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

@end
