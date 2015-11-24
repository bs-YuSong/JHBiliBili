//
//  ShinBanViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShinBanViewModel : BaseViewModel

- (NSInteger)moreViewListCount;
- (NSInteger)recommentListCount;
- (NSMutableArray*)getRecommentList;

- (NSURL*)moreViewPicForRow:(NSInteger)row;
- (NSString*)moreViewPlayForRow:(NSInteger)row;
- (NSString*)moreViewTitleForRow:(NSInteger)row;

- (NSURL*)commendCoverForRow:(NSInteger)row;
- (NSString*)commendTitileForRow:(NSInteger)row;

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;
- (void)getMoreDataCompleteHandle:(void(^)(NSError *error))complete;
@end
