//
//  FGAIActionView.m
//  FGProject
//
//  Created by Bert on 16/8/11.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGAIActionView.h"

@implementation FGAIActionView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
        UIButton * voiceToWordsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [voiceToWordsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [voiceToWordsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        voiceToWordsBtn.layer.cornerRadius = 5;
        voiceToWordsBtn.layer.masksToBounds = YES;
        [self addSubview:voiceToWordsBtn];
        [voiceToWordsBtn setTitle:@"语音转文字" forState:UIControlStateNormal];
        [voiceToWordsBtn setBackgroundColor:[UIColor redColor]];
       
        UIButton *cancelSpeechBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelSpeechBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelSpeechBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cancelSpeechBtn.layer.cornerRadius = 5;
        cancelSpeechBtn.layer.masksToBounds = YES;
        [self addSubview:cancelSpeechBtn];
        [cancelSpeechBtn setTitle:@"取消语音\n阅读" forState:UIControlStateNormal];
        [cancelSpeechBtn setBackgroundColor:[UIColor redColor]];
       
        
        UIButton *aiChatBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [aiChatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];        aiChatBtn.layer.cornerRadius = 5;
        aiChatBtn.layer.masksToBounds = YES;
        [aiChatBtn setTitle:@"AI语音聊天" forState:UIControlStateNormal];
        [aiChatBtn setBackgroundColor:[UIColor  purpleColor]];
        [self addSubview:aiChatBtn];
        [aiChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(self.mas_height).offset(30);
        }];
        
        
        [cancelSpeechBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(aiChatBtn.mas_left).offset(-10);
            make.top.mas_equalTo(aiChatBtn.mas_top);
            make.bottom.mas_equalTo(aiChatBtn.mas_bottom);
            make.width.mas_equalTo(self.mas_height).offset(30);
        }];
        
        [voiceToWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cancelSpeechBtn.mas_left).offset(-10);
            make.top.mas_equalTo(cancelSpeechBtn.mas_top);
            make.bottom.mas_equalTo(cancelSpeechBtn.mas_bottom);
            make.width.mas_equalTo(self.mas_height).offset(30);
        }];
        
        self.voiceToWordsBtn = voiceToWordsBtn;
        self.aiChatBtn = aiChatBtn;
        self.cancelSpeechBtn = cancelSpeechBtn;

    }
    return self;
}

@end
