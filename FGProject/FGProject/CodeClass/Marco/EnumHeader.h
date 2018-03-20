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
    //    MathRootViewActionTypeCompreOfSimple,
    //    MathRootViewActionTypeCompreOfMedium,
    //    MathRootViewActionTypeCompreOfDiffculty,
    
};

//Math计算类型选择
typedef NS_ENUM(NSInteger,MathOperationActionType){
    MathOperationActionTypeAdd = 2000,
    MathOperationActionTypeSubtract,
    MathOperationActionTypeMultiply,
    MathOperationActionTypeDivide,
    MathOperationActionTypeCompreOfSimple,
    MathOperationActionTypeCompreOfMedium,
    MathOperationActionTypeCompreOfDiffculty,
};
//Math SimpleView
typedef NS_ENUM(NSInteger,MathSimpleOperationViewActionType){
    MathSimpleOperationViewActionTypeOperation = 2000,
    MathSimpleOperationViewActionTypeAnswer,
};

//MyCenter
typedef NS_ENUM(NSInteger,MyCenterViewActionType){
    MyCenterViewActionTypeEditeUserIcon = 2000,
    MyCenterViewActionTypeSetupClickSound,
};

#endif /* EnumHeader_h */
