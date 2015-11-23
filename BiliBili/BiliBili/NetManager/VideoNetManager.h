//
//  VideoNetManager.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseNetManager.h"
#import "VideoModel.h"
@interface VideoNetManager : BaseNetManager
+ (id)GetVideoWithParameter:(NSString*)parame completionHandler:(void(^)(VideoModel* responseObj, NSError *error))complete;
+ (id)DownDanMuWithParameter:(NSString*)parame completionHandler:(void(^)(NSDictionary* responseObj, NSError *error))complete;
@end
