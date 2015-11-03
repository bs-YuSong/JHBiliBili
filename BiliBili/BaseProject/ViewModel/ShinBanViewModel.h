//
//  ShinBanViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShinBanViewModel : BaseViewModel
@property (nonatomic, strong) NSMutableArray* moreViewList;
@property (nonatomic, strong) NSMutableArray* recommentList;
- (NSURL*)moreViewPicForRow:(NSInteger)row;
- (NSString*)moreViewPlayForRow:(NSInteger)row;
- (NSString*)moreViewTitleForRow:(NSInteger)row;

- (NSURL*)commendCoverForRow:(NSInteger)row;
- (NSString*)commendTitileForRow:(NSInteger)row;

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;
@end
