//
//  WriteFunction.m
//  书写文字
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "WriteFunction.h"

@implementation WriteFunction
+(UIBezierPath*)pathForText:(NSString*)text lineSpace:(CGFloat)lineSpace textFont:(UIFont*)textFont drawWidth:(CGFloat)drawWidth forLayerDraw:(BOOL)forLayerDraw
{
    CTFontRef font = CTFontCreateWithName((CFStringRef)textFont.fontName,
                                         textFont.pointSize,
                                         NULL);
    CGMutablePathRef letters = CGPathCreateMutable();

    //line break
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //行间距
    CTParagraphStyleSetting LineSpacing;
    CGFloat spacing = lineSpace;  //指定间距
    LineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    LineSpacing.value = &spacing;
    LineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode,LineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);   //第二个参数为settings的长度
    
    //设置字体和换行模式
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,(id)paragraphStyle,(NSString *)kCTParagraphStyleAttributeName,
                           nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:attributes];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    NSInteger textIndex = 0;
    
    CGFloat lineStartY = 0.0f;
    
    CGFloat lineStartX = 0.0f;
    
    CGFloat textStartX = 0.0f;
    
    BOOL haveNewLine = NO;
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            
            NSString *subString =[text substringWithRange:NSMakeRange(textIndex, 1)];
            
            BOOL needNewLine = [subString isEqualToString:@"\n"];
            
            if (needNewLine)
            {
                lineStartY+= (CTFontGetSize(font)+spacing);
            }

            
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                if (!needNewLine)
                {
                    if (textIndex > 0)
                    {
                        if (haveNewLine)
                        {
                            lineStartX = position.x;
                        }
                        else if (textStartX >= (drawWidth - CTFontGetSize(font)*2))
                        {
                            lineStartX = position.x;
                            lineStartY += (CTFontGetSize(font)+spacing);
                            textStartX = 0.0f;
                        }
                    }
                    if (forLayerDraw)
                    {
                        CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                        textStartX = position.x-lineStartX;
                        
                        CGAffineTransform t = CGAffineTransformMakeTranslation(textStartX, -(position.y+lineStartY));
                        
                        CGPathAddPath(letters, &t, letter);
                        CGPathRelease(letter);
                    }
                    else
                    {
                        CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                        
                        textStartX = position.x-lineStartX;
                        
                        CATransform3D ca3D = CATransform3DMakeTranslation(textStartX, (position.y+lineStartY+CTFontGetSize(font)), 0.0f);
                        CATransform3D re3D = CATransform3DRotate(ca3D, M_PI, 1, 0, 0);
                        CGAffineTransform t = CATransform3DGetAffineTransform(re3D);
                        
                        CGPathAddPath(letters, &t, letter);
                        
                        CGPathRelease(letter);
                    }
                }
                
            }
            
            if (needNewLine)
            {
                haveNewLine = YES;
            }
            else
            {
                haveNewLine = NO;
            }
            
            textIndex++;
            
        }
    }
    CFRelease(line);
    
    return [UIBezierPath bezierPathWithCGPath:letters];
}
@end
