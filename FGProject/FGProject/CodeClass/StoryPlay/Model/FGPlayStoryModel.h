//
//  FGPlayStoryModel.h
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  播放列表model
 */
@interface FGPlayStoryModel : NSObject
@property (nonatomic,strong) NSString *story_id;
@property (nonatomic,strong) NSString *story_name;
@property (nonatomic,strong) NSString *img_url;
@property (nonatomic,strong) NSString *music_url;

-(instancetype)initWithDic:(NSDictionary*)dic;
@end
