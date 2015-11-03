//
//  RecommendViewModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"

@interface RecommendViewModel : BaseViewModel
@property (nonatomic, strong) NSMutableDictionary* list;
@property (nonatomic, strong) NSMutableArray* headObject;
@property (nonatomic, strong) NSArray* dicMap;
- (NSURL *)picForRow:(NSInteger)row section:(NSString*)section;
- (NSString*)titleForRow:(NSInteger)row section:(NSString*)section;
- (NSNumber *)playForRow:(NSInteger)row section:(NSString*)section;
- (NSNumber *)replyForRow:(NSInteger)row section:(NSString*)section;
- (NSString*)aidForRow:(NSInteger)row section:(NSString*)section;
- (void)refreshDataCompleteHandle:(void(^)(NSError *error))complete;
- (NSArray*)headImgArr;
- (NSInteger)sectionCount;
- (NSURL*)headImgURL:(NSInteger)index;
@end
