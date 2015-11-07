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
@interface ShinBanViewModel ()
@property (nonatomic, strong) NSMutableArray* moreViewList;
@property (nonatomic, strong) NSMutableArray* recommentList;
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
    MoreViewShinBanDataModel* model = self.moreViewList[row];
    return [NSURL URLWithString:model.pic];
}
- (NSString*)moreViewPlayForRow:(NSInteger)row{
    MoreViewShinBanDataModel* model = self.moreViewList[row];
    if (model.play.integerValue > 10000) {
        return [NSString stringWithFormat:@"%.1f万",model.play.integerValue / 10000.0];
    }
    return model.play.stringValue;
}

- (NSString*)moreViewTitleForRow:(NSInteger)row{
    MoreViewShinBanDataModel* model = self.moreViewList[row];
    return model.title;
}


- (NSURL*)commendCoverForRow:(NSInteger)row{
    RecommentShinBanDataModel* dataModel = self.recommentList[row];
    return [NSURL URLWithString:dataModel.cover];
}
- (NSString*)commendTitileForRow:(NSInteger)row{
    RecommentShinBanDataModel* dataModel = self.recommentList[row];
    return dataModel.title;
}

#define pagesize @21
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    //刷新大家都在看
    [ShinBanNetManager getMoreViewParametersCompletionHandler:^(MoreViewShinBanModel* responseObj, NSError *error) {
        [self.moreViewList removeAllObjects];
        self.moreViewList = [responseObj.list mutableCopy];
    //刷新推荐番剧
        [ShinBanNetManager getRecommentParameters:@{@"page":@1,@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
            [self.recommentList removeAllObjects];
            self.recommentList = [responseObj1.list mutableCopy];
            complete(error);
        }];
    }];
}

- (void)getMoreDataCompleteHandle:(void(^)(NSError *error))complete{
    [ShinBanNetManager getRecommentParameters:@{@"page":@(self.recommentList.count / pagesize.intValue + 1),@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
        if (responseObj1.list.count > 0 ) {
            [self.recommentList addObjectsFromArray:responseObj1.list];
        }
        complete(error);
    }];
}
@end
