//
//  UIScrollView+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/10.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "UIScrollView+Tools.h"

@implementation UIScrollView (Tools)
- (void)changeContentOffsetX:(CGFloat)x{
    CGPoint point = self.contentOffset;
    point.x = x;
    self.contentOffset = point;
}
- (void)changeContentOffsetY:(CGFloat)y{
    CGPoint point = self.contentOffset;
    point.y = y;
    self.contentOffset = point;
}
- (void)addContentOffsetY:(CGFloat)y{
    CGPoint point = self.contentOffset;
    point.y += y;
    self.contentOffset = point;
}
@end
