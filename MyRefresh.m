//
//  MyRefresh.m
//  FoodData
//
//  Created by boy on 16/4/28.
//  Copyright (c) 2016年 boy. All rights reserved.
//

#import "MyRefresh.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define xx [UIScreen mainScreen].bounds.size.width / 2 - 15


@implementation MyRefresh



+ (instancetype)share{
    
    static MyRefresh * myRefresh = nil;
    if (myRefresh == nil) {
        myRefresh = [[MyRefresh alloc] init];
    }
    return myRefresh;
}

+ (void)addRefreshViewInView:(UIView *)view target:(id)target action:(SEL)selector{
    
    MyRefresh * myRefresh = [MyRefresh share];
    
    [myRefresh addRefreshViewInView:view target:target action:selector];
}


- (void)addRefreshViewInView:(UIView *)view target:(id)target action:(SEL)selector{
    _target = target;
    _selector = selector;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
    
    _longLine = [[UIView alloc] initWithFrame:CGRectMake(xx + 14, -20, 2, 1)];
    _longLine.backgroundColor = [UIColor greenColor];
    [self.target.view addSubview:_longLine];
    
    _refreshView = [[UIView alloc] initWithFrame:CGRectMake(xx, -20, 30, 30)];
    _refreshView.backgroundColor = [UIColor clearColor];
    _refreshView.layer.cornerRadius = 15;
    [self.target.view addSubview:_refreshView];
    
    
    _circleLayer = [CAShapeLayer new];
    _circleLayer.frame = CGRectMake(0, 0, 30, 30);
    //fillColor和strokeColor的区别是 一个为填充色，一个为描边色
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = [UIColor greenColor].CGColor;
    _circleLayer.lineWidth = 1;
    UIBezierPath*path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 30, 30) cornerRadius:15];
    _circleLayer.path = path.CGPath;
    [_refreshView.layer addSublayer:_circleLayer];
    
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 1;
    
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, 14, 30, 2)];
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(3, 0, 12, 2)];
    view1.backgroundColor = [UIColor greenColor];
    [_line addSubview:view1];
    
    [_refreshView addSubview:_line];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [view addGestureRecognizer:pan];
    
}

- (void)timerAction{
    _f += 0.3;
    _line.transform = CGAffineTransformMakeRotation(_f);
    
    if (_f > 1000) {
        _timer.fireDate = [NSDate distantFuture];
        _f = 0;
        [UIView animateWithDuration:0.2 animations:^{
            _refreshView.frame = CGRectMake(xx, -20, 30, 30);
            _line.frame = CGRectMake(14, -20, 2, 1);
        }];
//        [PromptLabel ShowPromptWithMessage:@"网络连接有问题" inView:_target.view];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _beganPoint = [pan translationInView:self.target.view];
            _timer.fireDate = [NSDate distantFuture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            _changePoint = [pan translationInView:self.target.view];
            float yy = _changePoint.y - _beganPoint.y;
            
            if (yy > 100) {
                yy = 100;
            }
            _viewY = yy;
            _longLine.frame = CGRectMake(xx + 14, -20, 2, yy + 20);
            _refreshView.frame = CGRectMake(xx, yy, 30, 30);
            _line.transform = CGAffineTransformMakeRotation(yy / 10);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _endPoint = [pan translationInView:self.target.view];
            if (_endPoint.y < 40) {
                [UIView animateWithDuration:0.5 animations:^{
                    _refreshView.frame = CGRectMake(_refreshView.frame.origin.x, -20, 30, 30);
                    _longLine.frame = CGRectMake(xx + 14, -20, 2, 1);

                }];
            }
            else{
                NSLog(@"开始回到中间位置");
                _timer.fireDate = [NSDate distantPast];
                [UIView animateWithDuration:0.2 animations:^{
                    _refreshView.frame = CGRectMake(_refreshView.frame.origin.x, 40, 30, 30);
                    _longLine.frame = CGRectMake(xx + 14, -20, 2, 60);

                } completion:^(BOOL finished) {
                    
                }];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_target performSelector:_selector];
#pragma clang diagnostic pop
                
            }
            
        }
            break;
        default:
            break;
    }
    
}
+ (void)endRefresh{
    
    MyRefresh * myRefresh = [MyRefresh share];
    
    [myRefresh endRefresh];
}

- (void)endRefresh{
    
    [UIView animateWithDuration:0.3 animations:^{
       
        _refreshView.frame = CGRectMake(xx, -20, 30, 30);
        _longLine.frame = CGRectMake(xx + 14, -20, 2, 1);

        
    }];
    [_timer setFireDate:[NSDate distantFuture]];
    _f = 0;


}

+ (void)createRefreshInView:(UIView *)refreshView target:(id)target action:(SEL)selector{
    
    
}



@end
