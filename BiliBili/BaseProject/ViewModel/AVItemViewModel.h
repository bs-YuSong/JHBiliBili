//
//  AVItemViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"
/**
 *  视频详情子项
 
 */
@interface AVItemViewModel : BaseViewModel
//相关视频
- (NSURL*)sameVideoPicForRow:(NSInteger)row;
- (NSString*)sameVideoTitleForRow:(NSInteger)row;
- (NSString*)sameVideoPlayNumForRow:(NSInteger)row;
- (NSString*)sameVideoReplyForRow:(NSInteger)row;

//评论
- (NSString*)replyNameForRow:(NSInteger)row;
- (NSURL*)replyIconForRow:(NSInteger)row;
- (NSString*)replyMessageForRow:(NSInteger)row;
- (NSString*)replyTimeForRow:(NSInteger)row;
- (NSString*)lvForRow:(NSInteger)row;
- (NSString*)replyGoodForRow:(NSInteger)row;
- (NSString*)replyGenderForRow:(NSInteger)row;
- (NSInteger)replyCount;

//承包商排行
- (NSURL*)investorIconForRow:(NSInteger)row;
- (NSString*)investorNameForRow:(NSInteger)row;
- (NSString*)investorMessageForRow:(NSInteger)row;

//视频详情
- (NSString*)avInfoTag;

//番剧详情
- (NSInteger)shinBanInfoCount;
- (NSString*)shinBanInfoIntroduce;
- (NSArray*)shinBanInfoTag;
@end
