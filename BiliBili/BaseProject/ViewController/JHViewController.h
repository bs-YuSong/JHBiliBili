//
//  JHViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/11.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@protocol JHViewControllerDelegate <NSObject>
@optional
- (void)JHViewGetOffset:(CGPoint)offset;
@end

@interface JHViewController : UIViewController
@property (nonatomic, strong) UIScrollView* scrollView;
- (instancetype)initWithControllers:(NSArray*)controllers;

@property (nonatomic, strong) id<JHViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentPage;
@end
