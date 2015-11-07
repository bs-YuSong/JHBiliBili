//
//  AVItemViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AVItemViewModel.h"
#import "AVInfoNetManager.h"
#import "NSString+Tools.h"
@interface AVItemViewModel ()
//新番独有属性
//承包商数组
@property (nonatomic, strong) NSMutableArray <InvestorDataModel*>* investorList;
//新番详情数组
@property (nonatomic, strong) NSMutableArray <ShinBanInfoDataModel*>* shiBanInfoList;

//视频共有属性
//相关视频数组
@property (nonatomic, strong) NSMutableArray <sameVideoDataModel*>* sameVideoList;
//回复数组
@property (nonatomic, strong) NSMutableArray <ReplyDataModel*>* replyList;
@end

@implementation AVItemViewModel
//相关视频
- (NSURL*)sameVideoPicForRow:(NSInteger)row{
    return [NSURL URLWithString:self.sameVideoList[row].pic];
}
- (NSString*)sameVideoTitleForRow:(NSInteger)row{
    return self.sameVideoList[row].title;
}
- (NSString*)sameVideoPlayNumForRow:(NSInteger)row{
    return [NSString stringWithFormatNum:self.sameVideoList[row].click];
}
- (NSString*)sameVideoReplyForRow:(NSInteger)row{
    return [NSString stringWithFormatNum:self.sameVideoList[row].dm_count];
}

//评论
- (NSString*)replyNameForRow:(NSInteger)row{
    return self.replyList[row].nick;
}
- (NSURL*)replyIconForRow:(NSInteger)row{
    return [NSURL URLWithString: self.replyList[row].face];
}
- (NSString*)replyMessageForRow:(NSInteger)row{
    return self.replyList[row].msg;
}
- (NSString*)replyTimeForRow:(NSInteger)row{
    return self.replyList[row].create_at;
}
- (NSString*)lvForRow:(NSInteger)row{
    return [NSString stringWithFormatNum:self.replyList[row].lv];
}
- (NSString*)replyGoodForRow:(NSInteger)row{
    return [NSString stringWithFormatNum:self.replyList[row].good];
}
- (NSString*)replyGenderForRow:(NSInteger)row{
    return self.replyList[row].sex;
}
- (NSInteger)replyCount{
    return self.replyList.count;
}


//承包商排行
- (NSURL*)investorIconForRow:(NSInteger)row{
    return [NSURL URLWithString:self.investorList[row].face];
}
- (NSString*)investorNameForRow:(NSInteger)row{
    return self.investorList[row].uname;
}
- (NSString*)investorMessageForRow:(NSInteger)row{
    return self.investorList[row].message;
}


//视频详情
//- (NSString*)avInfoTag{
//    return self.
//}
//- (NSString*)avInfoMessage;


#pragma mark - 懒加载
- (NSMutableArray<sameVideoDataModel *> *)sameVideoList{
    if (_sameVideoList == nil) {
        _sameVideoList = [NSMutableArray array];
    }
    return _sameVideoList;
}

- (NSMutableArray<ReplyDataModel *> *)replyList{
    if (_replyList == nil) {
        _replyList = [NSMutableArray array];
    }
    return _replyList;
}

- (NSMutableArray<ShinBanInfoDataModel *> *)shiBanInfoList{
    if (_shiBanInfoList == nil) {
        _shiBanInfoList = [NSMutableArray array];
    }
    return _shiBanInfoList;
}

- (NSMutableArray<InvestorDataModel *> *)investorList{
    if (_investorList == nil) {
        _investorList = [NSMutableArray array];
    }
    return _investorList;
}
@end
