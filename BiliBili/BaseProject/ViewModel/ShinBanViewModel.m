//
//  ShinBanViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ShinBanViewModel.h"
#import "ShinBanNetManager.h"
#import "ShinBanModel.h"
#import "NSString+Tools.h"
@interface ShinBanViewModel ()
@property (nonatomic, strong) NSMutableArray<MoreViewShinBanDataModel*>* moreViewList;
@property (nonatomic, strong) NSMutableArray<RecommentShinBanDataModel*>* recommentList;
@end

@implementation ShinBanViewModel

- (NSMutableArray*)getRecommentList{
    return self.recommentList;
}

- (NSInteger)moreViewListCount{
    return self.moreViewList.count;
}
- (NSInteger)recommentListCount{
    return self.recommentList.count;
}

- (NSMutableArray *)recommentList{
    if (_recommentList == nil) {
        _recommentList = [NSMutableArray array];
    }
    return _recommentList;
}

- (NSMutableArray *)moreViewList{
    if (_moreViewList == nil) {
        _moreViewList = [NSMutableArray array];
    }
    return _moreViewList;
}

- (NSURL*)moreViewPicForRow:(NSInteger)row{
    return [NSURL URLWithString:self.moreViewList[row].pic];
}
- (NSString*)moreViewPlayForRow:(NSInteger)row{
    return [NSString stringWithFormatNum:self.moreViewList[row].play];
}

- (NSString*)moreViewTitleForRow:(NSInteger)row{
    return self.moreViewList[row].title;
}


- (NSURL*)commendCoverForRow:(NSInteger)row{
    return [NSURL URLWithString:self.recommentList[row].cover];
}
- (NSString*)commendTitileForRow:(NSInteger)row{
    return self.recommentList[row].title;
}

#define pagesize @21
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    //刷新大家都在看
    [ShinBanNetManager getMoreViewParametersCompletionHandler:^(MoreViewShinBanModel* responseObj, NSError *error) {
        [self.moreViewList removeAllObjects];
        self.moreViewList = [responseObj.list mutableCopy];
    //刷新推荐番剧
        [self.recommentList removeAllObjects];
        [self getMoreDataCompleteHandle:^(NSError *error) {
            complete(error);
        }];

    }];
}
//获取更多推荐番剧
- (void)getMoreDataCompleteHandle:(void(^)(NSError *error))complete{
    [ShinBanNetManager getRecommentParameters:@{@"page":@(self.recommentList.count / pagesize.intValue + 1),@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
        if (responseObj1.list.count > 0 ) {
            [self.recommentList addObjectsFromArray:responseObj1.list];
        }
        complete(error);
    }];
}
@end
