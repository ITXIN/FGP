//
//  FGMathOperationManager.m
//  FGProject
//
//  Created by avazuholding on 2017/11/12.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMathOperationManager.h"
#import "QuestionModel.h"
#import "MediumOperationModel.h"
#import "FGMathAnswerOptionsModel.h"
@implementation FGMathOperationManager
static NSString *countKey = @"countKey";
static NSString *rewardKey = @"rewardKey";
static NSString *hasDoneKey = @"hasDoneKey";
+ (instancetype)shareMathOperationManager
{
    static FGMathOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.operationsArr = @[@(MathOperationActionTypeAdd),@(MathOperationActionTypeSubtract),@(MathOperationActionTypeMultiply),@(MathOperationActionTypeDivide)];
        manager.dateSingle = [FGDateSingle shareInstance];
        manager.countDic = [NSMutableDictionary dictionaryWithDictionary:[FGProjectHelper getDataWithKey:countKey]];
        manager.hasDoneDic = [NSMutableDictionary dictionaryWithDictionary: manager.countDic[hasDoneKey]];
        
//        manager.countDic = [NSMutableDictionary dictionaryWithDictionary:@{rewardKey:@"",hasDoneKey:manager.hasDoneArr}];
    });
    return manager;
}

- (void)saveCurrentDateHasDoneNumber:(NSInteger)number{
    //今天做的题目个数
//    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:[self.dateSingle curretDate]];
   
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.hasDoneDic setValue:[NSString stringWithFormat:@"%ld",number] forKey:[self.dateSingle curretDate]];
        [self.countDic setObject:self.hasDoneDic forKey:hasDoneKey];
        [self.countDic setObject:@"" forKey:rewardKey];
        [FGProjectHelper saveDataWithKey:countKey data:self.countDic];
//    });
    
    
}
- (NSInteger)getCurrentDateHasDone{
    //   NSInteger hasDone = [[NSUserDefaults standardUserDefaults]integerForKey:[self.dateSingle curretDate]];

    NSString *hasDoneStr = self.hasDoneDic[[self.dateSingle curretDate]];
    
    return [hasDoneStr integerValue];
}

//获取运算符图片
- (UIImage*)getOperationImageWithOperationType:(MathOperationActionType)operationType{
    NSString *picStr;
    switch (operationType) {
        case MathOperationActionTypeAdd:
        {
            picStr = @"Add";
            break;
        }
        case MathOperationActionTypeSubtract:
        {
            picStr = @"Subtract";
            break;
        }
        case MathOperationActionTypeMultiply:
        {
            picStr = @"Multiply";
            break;
        }
        case MathOperationActionTypeDivide:
        {
            picStr = @"Divide";
            break;
        }
            
        default:
            break;
    }
    UIImage *operationImage = [UIImage imageNamed:picStr];
    return operationImage;
    
}

//获取运算数字的图片
- (UIImage*)getOperationNumberImageWithNumber:(NSInteger)number{
    
    NSString *numberStr = [NSString stringWithFormat:@"%ld",number];
    if (numberStr.length == 1) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"0%ld.png",(long)number]];
    }else{
        NSMutableArray *numberArr = [NSMutableArray array];
        for(int i =0; i < numberStr.length; i++){
            NSString *temp  = [NSString stringWithFormat:@"%@",[numberStr substringWithRange:NSMakeRange(i,1)]];
            UIImage *temImage = [UIImage imageNamed:[NSString stringWithFormat:@"0%@.png",temp]];
            [numberArr addObject:temImage];
        }
        if (numberArr.count == 0) {
            return nil;
        }
        UIImage *resultImage = [self drawImagesWithArr:numberArr];
        return resultImage;
    }
    
}
//拼接图片
- (UIImage *)drawImagesWithArr:(NSArray*)imagesArr{
    CGFloat sumWidth = 0;
    for (UIImage *image in imagesArr) {
        sumWidth = image.size.width;
        sumWidth += sumWidth;
    }
    
    CGSize contextSize = CGSizeMake(OPERATOR_HEIGHT, OPERATOR_HEIGHT);
    UIGraphicsBeginImageContext(contextSize);
    CGRect preFrame = CGRectZero;
    for (NSInteger i = 0 ; i < imagesArr.count; i ++) {
        UIImage *tempImage = (UIImage*)imagesArr[i];
        CGRect currentFrame;
        if (i == 0) {
            currentFrame = CGRectMake(0, 0, OPERATOR_HEIGHT/imagesArr.count, OPERATOR_HEIGHT);
        }else{
            currentFrame = CGRectMake(CGRectGetMinX(preFrame)+CGRectGetWidth(preFrame), 0, OPERATOR_HEIGHT/imagesArr.count, OPERATOR_HEIGHT);
        }
        [tempImage drawInRect:currentFrame];
        preFrame = currentFrame;
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}



/**
 两级运算
 */
- (QuestionModel*)generateSimpleOperationModelWithOperationType:(MathOperationActionType)mathOperationType{
    QuestionModel *questModel = [QuestionModel GenerateRandomNumWithOperationType:mathOperationType];
    return questModel;
}

/**
 产生三级加减混合运算
 */
- (MediumOperationModel*)generateMediumOperationModel{
    
    MathOperationActionType firstOperationType = [self.operationsArr[arc4random()%self.operationsArr.count] integerValue];
    QuestionModel *questModel = [QuestionModel GenerateRandomNumWithOperationType:firstOperationType];
    MediumOperationModel *mediumOperationModel = [[MediumOperationModel alloc]init];
    mediumOperationModel.firstOperationType = firstOperationType;
    mediumOperationModel.firstNum = questModel.firstNum;
    mediumOperationModel.secondNum = questModel.secondNum;
    mediumOperationModel.answerNum = questModel.answerNum;
    
    if (mediumOperationModel.answerNum > 0) {//只有加减
        MathOperationActionType secondMathOperationType = [self.operationsArr[arc4random()%2] integerValue];
        NSInteger thirdNum = arc4random() % kMathOperationRangeNumber;
        if (secondMathOperationType == MathOperationActionTypeSubtract){
            while (mediumOperationModel.answerNum < thirdNum){
                thirdNum = arc4random() % kMathOperationRangeNumber;
            }
            mediumOperationModel.answerNum = mediumOperationModel.answerNum - thirdNum;
        }else if(secondMathOperationType == MathOperationActionTypeAdd){
            mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
        }
        
        mediumOperationModel.secondOperationType = secondMathOperationType;
        mediumOperationModel.thirdNum = thirdNum;
    }else{
        
        NSInteger thirdNum = arc4random() % kMathOperationRangeNumber;
        if (thirdNum == 0) {
            //当都为0，最后一个既可以为加号也可以为减号。
            MathOperationActionType secondMathOperationType = [self.operationsArr[arc4random()%2] integerValue];
            mediumOperationModel.thirdNum = thirdNum;
             mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
            mediumOperationModel.secondOperationType = secondMathOperationType;
            
        }else{
                mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
                mediumOperationModel.secondOperationType = MathOperationActionTypeAdd;
                mediumOperationModel.thirdNum = thirdNum;
        }
        
       
    }
    return mediumOperationModel;
}
//随机答案选项
- (FGMathAnswerOptionsModel *)generateRandomAnswerNum:(NSInteger)answerNum{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //第三个
    NSInteger thirdNum = 0;
    
    firstNum  = arc4random() % 4 + answerNum + 2;
    //运算符
    
    secondNum = arc4random() % kMathOperationRangeNumber;
    thirdNum = arc4random() % kMathOperationRangeNumber;
    
    FGMathAnswerOptionsModel *answerOptionModel = [[FGMathAnswerOptionsModel alloc]init];
    while (firstNum == answerNum){
        firstNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == secondNum || secondNum == answerNum ){
        secondNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == thirdNum  || secondNum == thirdNum  || thirdNum == answerNum){
        thirdNum = arc4random() % kMathOperationRangeNumber;
    }
    
    answerOptionModel.firstNum = [NSString stringWithFormat:@"%ld",firstNum];
    answerOptionModel.secondNum = [NSString stringWithFormat:@"%ld",secondNum];
    answerOptionModel.thirdNum = [NSString stringWithFormat:@"%ld",thirdNum];
    answerOptionModel.answerNum = [NSString stringWithFormat:@"%ld",answerNum];
    return answerOptionModel;
}


@end
