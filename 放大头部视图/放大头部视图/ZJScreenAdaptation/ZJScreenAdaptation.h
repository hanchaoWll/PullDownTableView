//
//  ZJScreenAdaptation.h
//  ScreenAdaptationPage
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//4s    w=320.000000 h=480.000000 rator=0.666667
//5     w=320.000000 h=568.000000 rator=0.563380
//5s    w=320.000000 h=568.000000 rator=0.563380
//6     w=375.000000 h=667.000000 rator=0.562219
//6p    w=414.000000 h=736.000000 rator=0.562500
//适配策略, 设计的以iPhones5作为基准, 6和6p等比例方法

//常见宽度和高度
#define DesignWidth 320
#define DesignHeight 568
#define DesignStatusHeight 20
#define DesignNavHeight 44
#define DesignNavExHeight 64
#define DesignTabHeight 44

@interface ZJScreenAdaptation : NSObject
//扩展函数适配Rect
CGRect CGRectMakeEx(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
//扩展适应Size
CGSize CGSizeMakeEx(CGFloat width, CGFloat height);
//扩展点
CGPoint CGPointMakeEx(CGFloat x, CGFloat y);

//适配高度
double heightEx(double height);
//适配宽度
double widthEx(double width);
@end
