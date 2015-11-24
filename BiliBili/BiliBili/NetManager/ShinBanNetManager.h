//
//  ShinBanNetManager.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface ShinBanNetManager : BaseNetManager
+ (id)getMoreViewParametersCompletionHandler:(void(^)(id responseObj, NSError *error))complete;
+ (id)getRecommentParameters:(NSDictionary*)params CompletionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
