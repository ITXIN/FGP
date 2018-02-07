//
//  FGUserManager.h
//  FGProject
//
//  Created by avazuholding on 2017/11/17.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGUserManager : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *isPlaySound;
+ (FGUserManager*)standard;
- (void)saveUserDataWithDic:(NSDictionary*)infoDic;
@end
