//
//  EnumHeader.h
//  FGProject
//
//  Created by avazuholding on 2017/11/16.
//  Copyright © 2017年 bert. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef EnumHeader_h
#define EnumHeader_h

//水波效果
typedef enum kSliderTag{
    kHeight_Tag             = 11,
    kSpeed_Tag              = 12,
    kWave_Tag               = 13,
    kWaveIncrease_Tag       = 16,
    kWaveMin_Tag            = 17,
    kWaveMax_Tag            = 18,
    kWaveW_Tag              = 19,
    
}SliderTag;

//首页分类
typedef NS_ENUM(NSUInteger,Category)
{
    CategoryGame = 100,
    CategoryAI,
    CategoryStory,
    CategoryMath
};


//Tom
typedef NS_ENUM(NSUInteger,TomImageCategory){
    cymbal = 0,
    fart,
    pie,
    scratch,
    eat,
    drink,
    footRight,
    footLeft,
    knockout,
    stomach,
    angry
};

//音乐播放
typedef NS_ENUM(NSUInteger,MusicPlayType)
{
    MusicPlayTypeBefore = 1000,
    MusicPlayTypePlay,
    MusicPlayTypeNext,
};

//Math页面按钮类型
typedef NS_ENUM(NSInteger,MathRootViewActionType){
    MathRootViewActionTypeAdd = 1000,
    MathRootViewActionTypeSubtract,
    MathRootViewActionTypeMultiply,
    MathRootViewActionTypeDivide,
    MathRootViewActionTypeCompre,
    MathRootViewActionTypeSun,
};

//+-一级，x/二级运算
//Math运算 二数运算，三数运算
typedef NS_ENUM(NSInteger, MathOperationLevel){
    MathOperationLevelTwo = 2000,
    MathOperationLevelThree,
   
};

//Math计算类型选择
typedef NS_ENUM(NSInteger,MathOperationActionType){
    MathOperationActionTypeAdd = 2000,
    MathOperationActionTypeSubtract = 2001,
    MathOperationActionTypeMultiply = 2002,
    MathOperationActionTypeDivide = 2003,
    MathOperationActionTypeCompreOfSimple = 2004,
    MathOperationActionTypeCompreOfMedium= 2005,
    MathOperationActionTypeCompreOfChallenge= 2006,
};


//Math
typedef NS_ENUM(NSInteger,MathOperationChooseResultType){
    MathOperationChooseResultTypeError = 2000,
    MathOperationChooseResultTypeCorrect
};


////Math 运算回答结果类型
typedef NS_ENUM(NSInteger,MathCompreOfChallengeTimerLevel){
    MathCompreOfChallengeTimerLevelOne = 15,
    MathCompreOfChallengeTimerLevelTwo = 10,
    MathCompreOfChallengeTimerLevelThree = 5
};

//MyCenter
typedef NS_ENUM(NSInteger,MyCenterViewActionType){
    MyCenterViewActionTypeEditeUserIcon = 2000,
    MyCenterViewActionTypeSetupClickSound,
};

#endif /* EnumHeader_h */
