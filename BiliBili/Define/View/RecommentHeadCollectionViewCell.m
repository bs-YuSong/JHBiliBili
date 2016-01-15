//
//  RecommentHeadCollectionViewCell.m
//  BiliBili
//
//  Created by JimHuang on 16/1/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommentHeadCollectionViewCell.h"
#import "iCarousel.h"

#import "WebViewController.h"

#import "IndexModel.h"

#import "UIApplication+Tools.h"

@interface RecommentHeadCollectionViewCell()<iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) iCarousel* headScrollView;
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation RecommentHeadCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.headScrollView];
    }
    return self;
}


#pragma mark - icarouse

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.headImg.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIImageView *)view{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW / 2)];
    }
    [view setImageWithURL: self.headImg[index].img];
    return view;
}
//滚动视图跳转
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    WebViewController* wbc = [[WebViewController alloc] init];
    wbc.URL = self.headImg[index].img;
    [self.nav pushViewController:wbc animated:YES];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    return value;
}

#pragma mark - 懒加载
- (iCarousel *)headScrollView{
    if (_headScrollView == nil) {
        _headScrollView = [[iCarousel alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.width / 2)];
        _headScrollView.delegate = self;
        _headScrollView.dataSource = self;
        _headScrollView.type = iCarouselTypeInvertedCylinder;
        _headScrollView.pagingEnabled = YES;
        //手动滚动速度
        _headScrollView.scrollSpeed = 2;
        __weak typeof(_headScrollView)weakHeadScrollView = _headScrollView;
        [NSTimer bk_scheduledTimerWithTimeInterval:8 block:^(NSTimer *timer) {
            [weakHeadScrollView scrollToItemAtIndex:weakHeadScrollView.currentItemIndex + 1 animated:YES];
        } repeats:YES];
    }
    return _headScrollView;
}

- (UINavigationController *)nav {
	if(_nav == nil) {
		_nav = (UINavigationController *)[[UIApplication sharedApplication] activityViewController];
	}
	return _nav;
}

@end
