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
/**
 @interface MoreViewShinBanModel : BaseModel
 @property (nonatomic, strong)NSArray* list;
 @end
 //推荐番剧
 @interface RecommentShinBanModel : BaseModel
 
 */

- (NSMutableArray *)RecommentList{
    if (_RecommentList == nil) {
        _RecommentList = [NSMutableArray array];
    }
    return _RecommentList;
}

- (NSMutableArray *)moreViewList{
    if (_moreViewList == nil) {
        _moreViewList = [NSMutableArray array];
    }
    return _moreViewList;
}

//- (NSArray*)getMoreViewDataModel{
//    return self.list[0];
//}
//
//- (NSArray*)getRecommentDataModel{
//    return self.list[1];
//}

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
    RecommentShinBanDataModel* dataModel = self.RecommentList[row];
    return [NSURL URLWithString:dataModel.cover];
}
- (NSString*)commendTitileForRow:(NSInteger)row{
    RecommentShinBanDataModel* dataModel = self.RecommentList[row];
    return dataModel.title;
}

//- (CGSize)commendCoverSize:(NSInteger)row{
//    RecommentShinBanDataModel* dataModel = [self getRecommentDataModel][row];
//    return CGSizeMake(dataModel.width, dataModel.height);
//}

//- (CGFloat)commendAllCoverHeight{
//    CGFloat allHe1 = 0.0;
//    CGFloat allHe2 = 0.0;
//    if ([self getRecommentDataModel].count % 2 == 0) {
//        for (int i = 0; i < [self getRecommentDataModel].count;i+=2){
//            RecommentShinBanDataModel* dataModel1 = [self getRecommentDataModel][i];
//            RecommentShinBanDataModel* dataModel2 = [self getRecommentDataModel][i+1];
//            allHe1 += (kWindowW / 2 - 12) * dataModel1.height / dataModel1.width + 10;
//            allHe2 += (kWindowW / 2 - 12) * dataModel2.height / dataModel2.width + 10;
//        }
//    }else{
//        for (int i = 0; i < [self getRecommentDataModel].count;i+=2){
//            RecommentShinBanDataModel* dataModel1 = [self getRecommentDataModel][i];
//            allHe1 += (kWindowW / 2 - 12) * dataModel1.height / dataModel1.width + 10;
//            if (i + 1 < [self getRecommentDataModel].count - 1) {
//                RecommentShinBanDataModel* dataModel2 = [self getRecommentDataModel][i+1];
//                allHe2 += (kWindowW / 2 - 12) * dataModel2.height / dataModel2.width + 10;
//            }
//        }
//    }
////    for (int i = 0; i < [self getRecommentDataModel].count;i+=2) {
////        if (i != [self getRecommentDataModel].count - 1) {
////            //(kWindowW / 2 - 12) * size.height / size.width + 10
////            RecommentShinBanDataModel* dataModel1 = [self getRecommentDataModel][i];
////            //RecommentShinBanDataModel* dataModel2 = [self getRecommentDataModel][i+1];
////           // RecommentShinBanDataModel* dataModel3 = dataModel1.height>dataModel2.height?dataModel1:dataModel2;
////            
////            allHe1 += (kWindowW / 2 - 12) * dataModel1.height / dataModel1.width + 10;
////        }else{
////            RecommentShinBanDataModel* dataModel1 = [self getRecommentDataModel][i];
////            allHe += (kWindowW / 2 - 12) * dataModel1.height / dataModel1.width + 10;
////            //allHe += 10;
////        }
////    }
//    return MAX(allHe1, allHe2);
//}

#define pagesize @10
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
            [ShinBanNetManager getMoreViewParametersCompletionHandler:^(MoreViewShinBanModel* responseObj, NSError *error) {
                //[self.list removeAllObjects];
                [self.moreViewList removeAllObjects];
                self.moreViewList = [responseObj.list mutableCopy];
                //[self.list addObject:responseObj.list];
                
                [ShinBanNetManager getRecommentParameters:@{@"page":@1,@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
                    self.RecommentList = [responseObj1.list mutableCopy];
                   // [self.list addObject: responseObj1.list];
                }];
            }];
}

- (void)getMoreDataCompleteHandle:(void(^)(NSError *error))complete{
    [ShinBanNetManager getRecommentParameters:@{@"page":@1,@"pagesize":pagesize} CompletionHandler:^(RecommentShinBanModel* responseObj1, NSError *error) {
        //[self.RecommentList removeAllObjects];
        [self.RecommentList addObject: responseObj1.list];
    }];
}
@end
