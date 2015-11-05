//
//  RecommendViewModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewModel.h"
#import "RecommendModel.h"
#import "RecommendNetManager.h"
#import "IndexModel.h"
@implementation RecommendViewModel

- (NSMutableDictionary *)list{
    if (_list == nil) {
        //1-3 动画 、129-3 舞蹈、13-3番剧 3-3音乐 4-3游戏 36-3科技 5-3娱乐 119-3鬼畜 11-3电视剧 23-3电影
        _list = [NSMutableDictionary new];
    }
    return _list;
}

- (NSMutableArray *)headObject{
    if (_headObject == nil) {
        _headObject = [NSMutableArray new];
    }
    return _headObject;
}

- (NSArray *)dicMap{
    if (_dicMap == nil) {
        _dicMap =  @[@{@"动画":@"catalogy/1-3day.json"},@{@"番剧":@"catalogy/13-3day.json"},@{@"音乐":@"catalogy/3-3day.json"},@{@"舞蹈":@"catalogy/129-3day.json"},@{@"游戏":@"catalogy/4-3day.json"},@{@"科技":@"catalogy/36-3day.json"},@{@"娱乐":@"catalogy/5-3day.json"},@{@"鬼畜":@"catalogy/119-3day.json"},@{@"电影":@"catalogy/23-3day.json"},@{@"电视剧":@"catalogy/11-3day.json"},@{@"顶部视图":@"slideshow.json"}];
    }
    return _dicMap;
}



- (NSURL *)picForRow:(NSInteger)row section:(NSString*)section{
    RecommendDataModel* m = self.list[section][row];
    
    return [NSURL URLWithString:m.pic];
}
- (NSString*)titleForRow:(NSInteger)row section:(NSString*)section{
    RecommendDataModel* m = self.list[section][row];
    return m.title;
}
- (NSNumber *)playForRow:(NSInteger)row section:(NSString*)section{
    RecommendDataModel* m = self.list[section][row];
    return m.play;
}
- (NSNumber *)replyForRow:(NSInteger)row section:(NSString*)section{
    RecommendDataModel* m = self.list[section][row];
    return m.review;
}

- (NSString*)aidForRow:(NSInteger)row section:(NSString*)section{
    RecommendDataModel* m = self.list[section][row];
    return m.aid;
}

- (NSInteger)numberOfHeadImg{
    NSArray* arr = self.list[@"slideshow.json"];
    return arr.count;
}


- (NSURL*)headImgURL:(NSInteger)index{
    IndexDataModel* mo = self.list[@"slideshow.json"][index];
    return [NSURL URLWithString:mo.img];
}

- (NSURL*)headImgLink:(NSInteger)index{
    IndexDataModel* mo = self.list[@"slideshow.json"][index];
    return [NSURL URLWithString:mo.link];
}

- (NSInteger)sectionCount{
    return self.dicMap.count - 1;
}

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete{

    [self.dicMap enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* key = [(NSDictionary*)obj allValues].firstObject;
        [RecommendNetManager getSection:key completionHandler:^(id responseObj, NSError *error) {
            self.list[key] = [[responseObj list] mutableCopy];
            complete(error);
        }];
    }];

}
@end
