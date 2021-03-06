//
//  APPHeader.h
//  FGProject
//
//  Created by XL on 15/6/30.
//  Copyright (c) 2015年 XL. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef FGProject_APPHeader_h
#define FGProject_APPHeader_h


#ifdef DEBUG  //调试阶段
#define FGLOG(...) NSLog(@"---%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__]);
#else  //发布阶段
#define FGLOG(...);
#endif


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#define showValueLableTag   10

#define waveDelta 0.01


//获取屏幕的宽高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kkScreenWidthRatio    kScreenWidth / 320.0
#define kScreenHeightRatio   kScreenHeight / 568.0

#undef RGBA
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#define kColorBackground RGB(41, 124, 247)

//间距
#define TenPadding 10.0

#define SevenPadding 7.0



#define OPERATOR_HEIGHT (kScreenWidth-100*2)/2/4
#define OPERATOR_LEFT_MARGIN 100.0

#define QUESTION_MARK_HEIGHT (kScreenWidth-100*2)/2/4

#define ANSWEROPTION_TOPMARGIN  kScreenHeight/10
#define ANSWEROPTION_BTN_WIDTH  kScreenHeight/5
/**
 *  choiceView 距离顶部间隙
 */
#define TOP_MARGIN_BTN_CHOICEVIEW kScreenHeight/7
/**
  choiceView 按钮高度
 */
#define HEIGHT_BTN_CHOICEVIEW kScreenWidth/6

//和太阳位置一致
#define RIGHT_MARGIN_PLAYERVIEW 40.0
#define HEIGHT_PLAYERVIEW kScreenWidth/6
#define WIDTH_PLAYERVIEW kScreenWidth/2 - 2*RIGHT_MARGIN_PLAYERVIEW

//diffcultlevelView height
#define HEIGHT_DIFFCULTYLEVEVIEW 

/**
 *  在 MediumViewController的高
 */
#define HEIGHT_MEDIUM_VC kScreenHeight/8
/**
 * MediumViewController 的左边间距
 */
#define LEFT_MARGIN_MEDIUM_VC 100.0


#define CONTINUE_BTN_TAG_TOOLTIP 4001
#define REST_BTN_TAG_TOOLTIP 4002

#define CHART_WORDS_WIDTH kScreenWidth/2 - 45*2 - 10*2

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

//数学计算的范围
static NSInteger kMathOperationRangeNumber = 11;

#define DATA_WAVE_HEIGHT_SCALE 500 //做题统计高度参数，1000是按1000道题水充满,可以设置其他的


//数学运算数据统计，总数据的key
#define kMathOperationDataStatisticsKey @"kMathOperationDataStatisticsKey"

//数据中总数量key
#define kMathOperationDataStatisticsTotalNumberKey @"kMathOperationDataStatisticsTotalNumberKey"

//挑战模式数据key
#define kMathOperationCompreOfChallengeDataKey @"kMathOperationCompreOfChallengeDataKey"

//挑战模式数据总量key
#define kMathOperationCompreOfChallengeTotalNumberKey @"kMathOperationCompreOfChallengeTotalNumberKey"

//挑战模式最高记录
#define kMathOperationCompreOfChallengeHighestRecord  @"kMathOperationCompreOfChallengeHighestRecord"

//挑战模式难度选择
#define kMathOperationCompreOfChallengeLevelKey @"kMathOperationCompreOfChallengeLevelKey"

//挑战模式难度等级
#define kMathOperationCompreOfChallengeLevelOneTotalNumberKey @"kMathOperationCompreOfChallengeLevelOneTotalNumberKey"
#define kMathOperationCompreOfChallengeLevelTwoTotalNumberKey @"kMathOperationCompreOfChallengeLevelTwoTotalNumberKey"
#define kMathOperationCompreOfChallengeLevelThreeTotalNumberKey @"kMathOperationCompreOfChallengeLevelThreeTotalNumberKey"

//数据中每日数据key
#define kMathOperationDetailDataKey @"kMathOperationDetailDataKey"

//数据中每日数据总数key
#define kMathOperationDetailDataTotalNumberKey @"kMathOperationDetailDataTotalNumberKey"

#define kMathOperationTypeKey @"kMathOperationTypeKey" //运算类型
#define kMathOperationStateKey @"kMathOperationStateKey"//状态是否正确
#define kMathOperationObjKey @"kMathOperationObjKey"//运算式
#define kMathOperationDateKey @"kMathOperationDateKey"//日期
#define kMathOperationCompreOfChallengeTimerLevelKey @"kMathOperationCompreOfChallengeTimerLevelKey"//混合运算挑战模式定时器等级

//综合练习选择的类型
#define kMathCompreOfOperationChooseTypeKey @"kMathCompreOfOperationChooseTypeKey"
#define kMathCompreOfOperationChooseAddTypeKey @"kMathCompreOfOperationChooseAddTypeKey"
#define kMathCompreOfOperationChooseSubtractTypeKey @"kMathCompreOfOperationChooseSubtractTypeKey"
#define kMathCompreOfOperationChooseMultiplyTypeKey @"kMathCompreOfOperationChooseMultiplyTypeKey"
#define kMathCompreOfOperationChooseDivideTypeKey @"kMathCompreOfOperationChooseDivideTypeKey"

//儿童数学的游戏
#define GAME_CHILDERN_API @"http://cdnapi.bbwansha.com/bb_video30/Home/game/games/version/3/app_id/6/app_sub_id/1?t=589AB3E0"

//Story数据持久化
#define STORY_HOMEPAGE_KEY @"StoryHomepageKey"
#define STORY_MUSIC_LIST_KEY @"StoryMusicKey"

//修改头像
#define MY_ICON_KEY @"MyIconKey"

//声音播放
#define SOUND_PLAY_STATE_KEY @"SoundPlayStateKey"

//Firbase key
#define FIREBASE_DATABASE_URL @"https://fgmath-77076.firebaseio.com/"

#define FIREBASE_STORAGE_URL @"gs://fgmath-77076.appspot.com/"


#define FIREBASE_DATABASE_CATEGORY_MATH @"Math"
#define FIREBASE_DATABASE_CATEGORY_MATH_SIMPLE @"Simple"
#define FIREBASE_DATABASE_CATEGORY_MATH_MEDIUM @"Medium"

#define FIREBASE_DATABASE_CATEGORY_AI @"AI"
#define FIREBASE_DATABASE_CATEGORY_STORY @"Story"
#define FIREBASE_DATABASE_CATEGORY_GAME @"Game"

#define AVAILABLE_IOS_11 @available(iOS 11.0, *)

#define kiPhoneX        (kScreenWidth == 812.0 &&  kScreenHeight == 375.f)


// Status bar height.
#define  kStatusBarHeight      (kiPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define  kNavigationBarHeight  44.f

// Tabbar height.
#define  kTabbarHeight         (kiPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (kiPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  kStatusBarAndNavigationBarHeight  (kiPhoneX ? 88.f : 64.f)

// Status bar & navigation bar &Tabbar height.
#define  kStatusBarAndNavigationBarAndTabbarHeightHeight  (kTabbarHeight+kStatusBarAndNavigationBarHeight)


#define USER_ICON_IPAD_WIDTH 100


#endif



