//
//  FindViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "FindViewModel.h"
@interface FindViewModel ()
@property (nonatomic, strong) NSMutableArray<FindDataModel*>* rankArr;
@property (nonatomic, strong) NSMutableArray<FindImgDataModel*>* rankImgArr;
@end

@implementation FindViewModel

- (NSMutableArray<FindImgDataModel *> *)rankImgArr{
    if (_rankImgArr == nil) {
        _rankImgArr = [NSMutableArray array];
    }
    return _rankImgArr;
}

- (NSMutableArray<FindDataModel *> *)rankArr{
    if (_rankArr == nil) {
        _rankArr = [NSMutableArray array];
    }
    return _rankArr;
}

- (NSInteger)rankArrConut{
    return self.rankArr.count;
}

- (NSString*)keyWordForRow:(NSInteger)row{
    return self.rankArr[row].keyword;
}
- (NSString*)statusWordForRow:(NSInteger)row{
    return self.rankArr[row].status;
}
- (NSURL*)rankCoverForNum:(NSInteger)num{
    return [NSURL URLWithString:self.rankImgArr[num].cover];
}
- (NSString*)coverKeyWordForNum:(NSInteger)num{
    return self.rankImgArr[num].keyword;
}
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [FindNetManager GetRankCompletionHandler:^(FindModel* responseObj, NSError *error) {
        [self.rankArr removeAllObjects];
        self.rankArr = [responseObj.list mutableCopy];
        [FindNetManager GetRankImgCompletionHandler:^(FindImgModel* responseObj1, NSError *error) {
            [self.rankImgArr removeAllObjects];
            self.rankImgArr = [responseObj1.recommend mutableCopy];
            complete(error);
        }];
    }];
}
@end
