//
//  ReViewTableViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  回复单元格
 */
@interface ReViewTableViewCell : UITableViewCell
- (void)setName:(NSString*)name image:(NSURL*)imgURL time:(NSArray*)time message:(NSString*)message goodNum:(NSString*)goodNum lv:(NSString*)lv gender:(NSString*)gender;
@end
