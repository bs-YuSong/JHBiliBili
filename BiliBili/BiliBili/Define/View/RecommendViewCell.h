//
//  RecommendViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  推荐番剧单元格
 */
@class ShinBanViewModel;
@interface RecommendViewCell : UITableViewCell
- (void)setWithVM:(ShinBanViewModel*)vm;
@end
