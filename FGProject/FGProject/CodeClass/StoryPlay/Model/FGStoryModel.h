//
//  FGStoryModel.h
//  FGProject
//
//  Created by Bert on 16/8/5.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  首页的 story 
 */
@interface FGStoryModel : NSObject
@property (nonatomic,strong) NSString *home_id;
@property (nonatomic,strong) NSString *image_url;
@property (nonatomic,strong) NSString *title;

-(instancetype)initWithDic:(NSDictionary*)dic;
@end
