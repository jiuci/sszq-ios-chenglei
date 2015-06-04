//
//  BYScrollview.m
//  IBY
//
//  Created by panshiyu on 14/12/6.
//  Copyright (c) 2014年 com.biyao. All rights reserved.
//

#import "BYScrollview.h"
#import "BYImageView.h"

@interface BYScrollview () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* listView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation BYScrollview

- (instancetype)initWithFrame:(CGRect)frame layout:(UICollectionViewFlowLayout*)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        _listView = [[UICollectionView alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = BYColorClear;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.pagingEnabled = YES;

        [_listView registerClass:[BYScrollUnit class] forCellWithReuseIdentifier:@"BYScrollUnit"];
        [self addSubview:_listView];

        _pageControl = [[UIPageControl alloc] initWithFrame:BYRectMake(0, self.height - 20, self.width, 20)];
        //        _pageControl.hidden = YES;
        _pageControl.currentPageIndicatorTintColor = BYColorb768;
        _pageControl.pageIndicatorTintColor = HEXCOLOR(0xcfcfcf);
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged]; //用户点击UIPageControl的响应函数
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)update:(NSArray*)datas
{
    if (datas.count > 0) {
        runOnMainQueue(^{
            _items = [NSArray arrayWithArray:datas];
            [_listView reloadData];
            _pageControl.currentPage = 0;
            _pageControl.numberOfPages = _items.count;
            CGSize size= [_pageControl sizeForNumberOfPages:_items.count];
            _pageControl.size = CGSizeMake(size.width, 20);
            _pageControl.bottom = self.height;
            _pageControl.centerX = self.width/2;
            
            if (self.autoScrollEnable) {
                [self beginAutoScroll];
            }

        });
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    self.pageControl.hidden = !showPageControl;
}

#pragma mark - autoscroll

- (void)beginAutoScroll
{
    if (!_autoScrollEnable) {
        return;
    }

    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:BYScrollTime target:self selector:@selector(didAutoScroll) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)didAutoScroll
{
    if (!_items || _items.count == 0) {
        return;
    }

    NSInteger curIndex = _pageControl.currentPage;
    NSInteger willIndex = (++curIndex) % _pageControl.numberOfPages;
    NSIndexPath* path = [NSIndexPath indexPathForRow:willIndex inSection:0];

    [_listView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _pageControl.currentPage = willIndex;

    //        [self beginAutoScroll];
}

#pragma mark -

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (_tapBlk) {
        _tapBlk(_items[indexPath.row]);
    }
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    BYScrollUnit* unit = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYScrollUnit" forIndexPath:indexPath];
    unit.refIteml = _items[indexPath.row];
    return unit;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
//{
//    [self beginAutoScroll];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];

    if (!_autoScrollEnable) {
        return;
    }

    NSArray* visiblelist = self.listView.visibleCells;
    if (visiblelist.count == 1) {
        UICollectionViewCell* visibleCell = visiblelist.lastObject;
        NSIndexPath* curIndexPath = [self.listView indexPathForCell:visibleCell];
        _pageControl.currentPage = curIndexPath.row;
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _listView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_listView scrollRectToVisible:rect animated:YES];
}

@end

#pragma mark -

@implementation BYScrollItem

+ (instancetype)itemWithData:(id)data imgUrl:(NSString*)imgUrl
{
    BYScrollItem* item = [[BYScrollItem alloc] init];
    item.data = data;
    item.imgUrl = imgUrl;
    return item;
}

@end

@implementation BYScrollUnit {
    BYImageView* _imgView;
}
- (void)setRefIteml:(BYScrollItem*)refIteml
{
    if (!_imgView) {
        _imgView = [[BYImageView alloc] initWithFrame:BYRectMake(0, 0, self.width, self.height)];
        [self.contentView addSubview:_imgView];
    }
    [_imgView setImageUrl:refIteml.imgUrl];
}

@end
