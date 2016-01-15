//
//  UIView+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/5.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)
- (void)changeSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (void)changePoint:(CGPoint)point{
    CGRect rect = self.frame;
    rect.origin = point;
    self.frame = rect;
}
- (void)changeWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)changeHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (void)changeX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (void)changeY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
@end
