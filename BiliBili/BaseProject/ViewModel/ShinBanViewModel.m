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
@implementation ShinBanViewModel

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

#define pagesize @30
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [ShinBanNetManager getMoreViewParametersCompletionHandler:^(MoreViewShinBanModel* responseObj, NSError *error) {
        [self.moreViewList removeAllObjects];
        self.moreViewList = [responseObj.list mutableCopy];
        
        [ShinBanNetManager getRecommentParameters:@{@"page":@1,@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
            [self.recommentList removeAllObjects];
            self.recommentList = [responseObj1.list mutableCopy];
            complete(error);
        }];
    }];
}

- (void)getMoreDataCompleteHandle:(void(^)(NSError *error))complete{
    [ShinBanNetManager getRecommentParameters:@{@"page":@1,@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
        [self.recommentList addObject: responseObj1.list];
    }];
}
@end
