//
//  RecommendViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"
@class AVDataModel;
@class IndexDataModel;
@interface RecommendViewModel : BaseViewModel
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSArray<AVDataModel*>*>* list;
@property (nonatomic, strong) NSArray<IndexDataModel*>* headObject;
@property (nonatomic, strong) NSArray<NSDictionary*>* dicMap;

- (NSURL *)picForRow:(NSInteger)row section:(NSString*)section;
- (NSString *)titleForRow:(NSInteger)row section:(NSString*)section;
- (NSString *)playForRow:(NSInteger)row section:(NSString*)section;
//评论数
- (NSString *)replyForRow:(NSInteger)row section:(NSString*)section;
- (NSString*)authorForRow:(NSInteger)row section:(NSString*)section;
- (NSString*)publicTimeForRow:(NSInteger)row section:(NSString*)section;

- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;

- (NSInteger)sectionCount;
- (NSURL*)headImgURL:(NSInteger)index;
- (NSURL*)headImgLink:(NSInteger)index;
- (NSInteger)numberOfHeadImg;
@end
