//
//  ShinBanViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShinBanViewModel : BaseViewModel
//List[0]保存"大家都在看"部分 List[1]保存推荐新番部分
@property (nonatomic, strong) NSMutableArray* moreViewList;
@property (nonatomic, strong) NSMutableArray* RecommentList;
- (NSURL*)moreViewPicForRow:(NSInteger)row;
- (NSString*)moreViewPlayForRow:(NSInteger)row;
- (NSString*)moreViewTitleForRow:(NSInteger)row;

- (NSURL*)commendCoverForRow:(NSInteger)row;
- (NSString*)commendTitileForRow:(NSInteger)row;
- (CGSize)commendCoverSize:(NSInteger)row;

- (NSArray*)getRecommentDataModel;
- (CGFloat)commendAllCoverHeight;

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;
@end
