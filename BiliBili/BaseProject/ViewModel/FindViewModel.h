//
//  FindViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"
#import "FindNetManager.h"
@interface FindViewModel : BaseViewModel
- (NSString*)keyWordForRow:(NSInteger)row;
- (NSString*)statusWordForRow:(NSInteger)row;

- (NSURL*)rankCoverForNum:(NSInteger)num;
- (NSString*)coverKeyWordForNum:(NSInteger)num;

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;
- (NSInteger)rankArrConut;
@end
