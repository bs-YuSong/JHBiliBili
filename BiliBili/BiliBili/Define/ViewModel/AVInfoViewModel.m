//
//  AVItemViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "AVInfoViewModel.h"
#import "NSString+Tools.h"
#import "AVInfoNetManager.h"
@interface AVInfoViewModel ()
////新番独有属性
////承包商数组
@property (nonatomic, strong) NSMutableArray <InvestorDataModel*>* investorList;
//新番详情数组
@property (nonatomic, strong) NSMutableArray <ShinBanInfoDataModel*>* shiBanInfoList;

@property (nonatomic, strong) NSString* section;

@property (nonatomic, assign) NSInteger allReplyCount;
@end

@implementation AVInfoViewModel
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
- (NSInteger)sameVideoCount{
    return self.sameVideoList.count;
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
- (NSString*)replyLVForRow:(NSInteger)row{
    return [NSString stringWithFormat:@"#%ld", (long)self.replyList[row].lv];
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
- (NSInteger)allReply{
    return self.allReplyCount;
}


- (NSAttributedString*)infoTags{
    NSDictionary* textAtt =  @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:kGloableColor};
    
    NSMutableAttributedString* mstr = [[NSMutableAttributedString alloc] initWithString:@"" attributes:textAtt];
    
    [self.tagList enumerateObjectsUsingBlock:^(TagDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [mstr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",obj.name,(idx == self.tagList.count - 1)?@"":@","] attributes:textAtt]];
        [mstr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }];
    return [mstr copy];
}


//视频信息
- (NSString*)infoTitle{
    return self.AVData.title;
}
- (NSURL*)infoImgURL{
    return [NSURL URLWithString: self.AVData.pic];
}
- (NSString*)infoUpName{
    return self.AVData.author;
}
- (NSString*)infoPlayNum{
    return [NSString stringWithFormatNum:self.AVData.play];
}
- (NSString*)infoDanMuCount{
    return [NSString stringWithFormatNum:self.AVData.video_review];
}
- (NSString*)infoTime{
    return self.AVData.create;
}

//视频aid
- (NSString*)videoAid{
    return self.AVData.aid;
}
//视频详情
- (NSString*)infoBrief{
    return self.AVData.desc;
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

- (NSInteger)investorCount{
    return self.investorList.count;
}

- (NSInteger)investorRankForRow:(NSInteger)row{
    return self.investorList[row].rank;
}

- (BOOL)isShiBan{
    return [self.section isEqualToString:@"13-3day.json"];
}





#define pagesize @20
#define page @1

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [AVInfoNetManager GetReplyWithParameter:@{@"pagesize":pagesize.stringValue, @"page":page.stringValue, @"aid":[self videoAid]} completionHandler:^(ReplyModel* responseObj, NSError *error) {
        self.replyList = [responseObj.list mutableCopy];
        self.allReplyCount = responseObj.results;
        [AVInfoNetManager GetSameVideoWithParameter:[self videoAid] completionHandler:^(sameVideoModel* responseObj1, NSError *error) {
            self.sameVideoList = [responseObj1.list mutableCopy];
            //新番情况下 多增加一个承包商请求
            if ([self isShiBan]) {
                [AVInfoNetManager GetInverstorWithParameter:@{@"aid":[self videoAid]} completionHandler:^(InvestorModel* responseObj2, NSError *error) {
                    self.investorList = [responseObj2.list mutableCopy];
                    [AVInfoNetManager GetTagWithParameter:@{@"aid":[self videoAid]} completionHandler:^(TagModel* responseObj2, NSError *error) {
                        self.tagList = [responseObj2.result mutableCopy];
                        complete(error);
                    }];
                }];
            }else{
                [AVInfoNetManager GetTagWithParameter:@{@"aid":[self videoAid]} completionHandler:^(TagModel* responseObj2, NSError *error) {
                    self.tagList = [responseObj2.result mutableCopy];
                    complete(error);
                }];
            }
            
        }];
    }];
}

- (void)getMoveReplyCompleteHandle:(void(^)(NSError *error))complete{
    [AVInfoNetManager GetReplyWithParameter:@{@"pagesize":pagesize.stringValue, @"page":@([self replyCount] / pagesize.intValue + 1), @"aid":[self videoAid]} completionHandler:^(ReplyModel* responseObj, NSError *error) {
        [self.replyList addObjectsFromArray:responseObj.list];
        self.allReplyCount = responseObj.results;
        complete(error);
    }];
}



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

- (NSMutableArray<TagDataModel *> *)tagList{
    if (_tagList == nil) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}

- (AVDataModel *)AVData{
    if (_AVData == nil) {
        _AVData = [AVDataModel new];
    }
    return _AVData;
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

#pragma mark - 初始化
- (void)setAVData:(AVDataModel *)AVData section:(NSString*)section{
    self.AVData = AVData;
    self.section = section;
}


@end
