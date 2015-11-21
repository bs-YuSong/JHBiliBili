//
//  MoreViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *   大家都在看单元格
 */
@interface MoreViewCell : UITableViewCell;
- (void)setWithDic:(NSDictionary<NSString*, NSMutableArray*>*)dic;
@end
