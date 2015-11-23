//
//  VideoViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/13.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "VideoViewModel.h"
#import "XML2Dic.h"
#import "DanMuModel.h"
#import "VideoNetManager.h"
@interface VideoViewModel()
@property (nonatomic, strong) NSArray<VideoDataModel*>* list;
@property (nonatomic, strong) NSDictionary<NSNumber*,NSMutableArray<DanMuModel*>*>* danMuDic;
@property (nonatomic, strong) NSString* aid;
@end


@implementation VideoViewModel

- (NSDictionary*)videoDanMu{
    return self.danMuDic;
}
- (NSURL*)videoURL{
    //判断默认设置是否为高清
    return [[[NSUserDefaults standardUserDefaults] stringForKey:@"HightResolution"] isEqualToString:@"yes"]?[NSURL URLWithString:[self firstObj].url]:[NSURL URLWithString:[self firstObj].backup_url.firstObject];
}
- (float)videoLength{
    return [self firstObj].length / 1000;
}

- (NSString*)videoCid{
    return [self firstObj].cid.stringValue;
}

- (VideoDataModel*)firstObj{
    return self.list.firstObject;
}

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [VideoNetManager GetVideoWithParameter:self.aid completionHandler:^(VideoModel *responseObj, NSError *error) {
        self.list = responseObj.durl;
        [VideoNetManager DownDanMuWithParameter:[self videoCid] completionHandler:^(NSDictionary *responseObj, NSError *error) {
            self.danMuDic = responseObj;
            complete(error);
        }];
    }];
}

- (instancetype)initWithAid:(NSString*)aid{
    if (self = [super init]) {
        self.aid = aid;
    }
    return self;
}

#pragma mark - 懒加载

- (NSArray<VideoDataModel *> *)list{
    if (_list == nil) {
        _list = [NSArray array];
    }
    return _list;
}

- (NSDictionary<NSNumber *,NSMutableArray<DanMuModel *> *> *)danMuDic{
    if (_danMuDic == nil) {
        _danMuDic = [NSMutableDictionary dictionary];
    }
    return _danMuDic;
}

@end

