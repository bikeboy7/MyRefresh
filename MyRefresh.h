//
//  MyRefresh.h
//  FoodData
//
//  Created by boy on 16/4/28.
//  Copyright (c) 2016年 boy. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface MyRefresh : NSObject
@property (assign,nonatomic) float f;

@property (retain,nonatomic) NSTimer * timer;

@property (retain,nonatomic) UIViewController * target;

@property (assign,nonatomic) SEL selector;

@property (assign,nonatomic) CGPoint beganPoint;
@property (assign,nonatomic) CGPoint endPoint;
@property (assign,nonatomic) CGPoint changePoint;
@property (assign,nonatomic) float viewY;
//旋转的针
@property (retain,nonatomic) UIView * line;

//拉线
@property (retain,nonatomic) UIView * longLine;

@property (retain,nonatomic) UIView * refreshView;

@property (retain,nonatomic) CAShapeLayer *circleLayer;

@property (nonatomic,strong)CABasicAnimation *animationRotation;


+ (void)addRefreshViewInView:(UIView *)view target:(id)target action:(SEL)selector;

+ (void)endRefresh;
@end
