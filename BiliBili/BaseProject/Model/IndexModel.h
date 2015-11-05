//
//  IndexModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseModel.h"

@interface IndexModel : BaseModel
@property (nonatomic, strong)NSNumber* results;
@property (nonatomic, strong)NSArray* list;
@property (nonatomic, strong)NSDictionary* IndexDataModel;
@end

@interface IndexDataModel : BaseModel
@property (nonatomic, strong)NSString* simg;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* img;
@property (nonatomic, strong)NSString* link;
@end
