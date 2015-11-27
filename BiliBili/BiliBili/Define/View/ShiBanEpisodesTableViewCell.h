//
//  ShiBanTableViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^updateEpisode)(NSNumber* str);
@class episodesModel;
@interface ShiBanEpisodesTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray<episodesModel*>* episodes;
@property (nonatomic, strong) UIViewController* vc;
@property (nonatomic, strong) updateEpisode returnBlock;
- (void)setUpdateReturnBlock:(updateEpisode)block;
@end
