//
//  RecommendViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  推荐番剧单元格
 */
@class ShinBanViewModel,RecommendCollectionViewController;
@interface RecommendViewCell : UITableViewCell
@property (nonatomic, strong) RecommendCollectionViewController* vc;
- (void)setWithVM:(ShinBanViewModel*)vm;
@end
