//
//  MyRefreshHeader.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/11.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MyRefreshHeader : MJRefreshNormalHeader
+ (id)myRefreshHead:(void(^)())block;
@end
