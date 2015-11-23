//
//  RecommendViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewModel.h"
#import "AVModel.h"
#import "RecommendNetManager.h"
#import "IndexModel.h"
#import "NSString+Tools.h"

@interface RecommendViewModel ()

@end

@implementation RecommendViewModel
#pragma mark - 缩略图
- (NSURL *)picForRow:(NSInteger)row section:(NSString*)section{
    return [NSURL URLWithString:self.list[section][row].pic];
}
- (NSString*)titleForRow:(NSInteger)row section:(NSString*)section{
    return self.list[section][row].title;
}
- (NSString *)playForRow:(NSInteger)row section:(NSString*)section{
    return [NSString stringWithFormatNum:self.list[section][row].play];
}
- (NSString *)danMuCountForRow:(NSInteger)row section:(NSString*)section{
    return [NSString stringWithFormatNum:self.list[section][row].video_review];
}

#pragma mark - 详情
- (NSString*)authorForRow:(NSInteger)row section:(NSString*)section{
    return self.list[section][row].author;
}

- (NSString*)publicTimeForRow:(NSInteger)row section:(NSString*)section{
    return self.list[section][row].create;
}

- (NSString*)descForRow:(NSInteger)row section:(NSString*)section{
    return self.list[section][row].desc;
}

#pragma mark - 顶部视图
- (NSInteger)numberOfHeadImg{
    return self.headObject.count;
}


- (NSURL*)headImgURL:(NSInteger)index{
    return [NSURL URLWithString:self.headObject[index].img];
}

- (NSURL*)headImgLink:(NSInteger)index{
    return [NSURL URLWithString:self.headObject[index].link];
}

- (NSInteger)sectionCount{
    return self.dicMap.count - 1;
}

#pragma mark - 获取视频子项详情
- (AVDataModel*)AVDataModelForRow:(NSInteger)row section:(NSString*)section{
    return self.list[section][row];
}

#pragma mark - 刷新
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{
    [RecommendNetManager getHeadImgCompletionHandler:^(IndexModel* responseObj, NSError *error) {
        //获取顶部滚动视图
         self.headObject = [responseObj.list mutableCopy];
        [ArchiverObj archiveWithObj:self.headObject key:@"recommendHeadModel"];
        //获取各分区内容
        [self.dicMap enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* key = [obj allValues].firstObject;
            [RecommendNetManager getSection:key completionHandler:^(AVModel* responseObj1, NSError *error) {
                self.list[key] = [responseObj1.list mutableCopy];
                if (idx == self.dicMap.count - 1) {
                    [ArchiverObj archiveWithObj:self.list key:@"recommendViewModel"];
                    complete(error);
                }
            }];
        }];
    }];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)list{
    if (_list == nil) {
        //1-3 动画 、129-3 舞蹈、13-3番剧 3-3音乐 4-3游戏 36-3科技 5-3娱乐 119-3鬼畜 11-3电视剧 23-3电影
        NSDictionary* dic = [ArchiverObj UnArchiveWithKey:@"recommendViewModel"];
        if (dic == nil) {
            _list = [NSMutableDictionary new];
        }else{
            _list = [dic mutableCopy];
        }
    }
    return _list;
}

- (NSArray *)headObject{
    if (_headObject == nil) {
        NSArray* headArr = [ArchiverObj UnArchiveWithKey:@"recommendHeadModel"];
        if (headArr == nil) {
            _headObject = [NSArray new];
        }else{
            _headObject = [headArr mutableCopy];
        }
    }
    return _headObject;
}

- (NSArray<NSDictionary *> *)dicMap{
    if (_dicMap == nil) {
        _dicMap =  @[@{@"动画":@"1-3day.json"},@{@"番剧":@"13-3day.json"},@{@"音乐":@"3-3day.json"},@{@"舞蹈":@"129-3day.json"},@{@"游戏":@"4-3day.json"},@{@"科技":@"36-3day.json"},@{@"娱乐":@"5-3day.json"},@{@"鬼畜":@"119-3day.json"},@{@"电影":@"23-3day.json"},@{@"电视剧":@"11-3day.json"}];
    }
    return _dicMap;
}

@end
