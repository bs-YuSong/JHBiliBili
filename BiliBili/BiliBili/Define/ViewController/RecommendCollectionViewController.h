//
//  RecommendCollectionViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/3.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewController.h"
@class ShinBanViewModel;
@interface RecommendCollectionViewController : BaseCollectionViewController
- (void)setVM:(ShinBanViewModel*)vm colNum:(NSInteger)num;
@end
