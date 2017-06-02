//
//  RedEnvelope.m
//  WeChatHongBao
//
//  Created by 大家保 on 2017/6/2.
//  Copyright © 2017年 小魏. All rights reserved.
//

#import "RedEnvelope.h"
#define APP_WIDTH  [UIScreen mainScreen].bounds.size.width
#define APP_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RedEnvelope (){
    CAShapeLayer *_redLayer,*_lineLayer;
    UILabel      *_titleLabel;
    UIImageView  *_logoImageView;
    UILabel      *_moneyLabel;
    UIButton     *_toMyMoneyButton;
    UIButton     *_closeButton;
}

@end


@implementation RedEnvelope

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

//绘制红包
- (void)initUI{
    //深色背景
    _redLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *pathFang = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) cornerRadius:4];
    _redLayer.path = pathFang.CGPath;
    _redLayer.zPosition = 1;
    [self.layer addSublayer:_redLayer];
    [_redLayer setFillColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0].CGColor];
    
    //浅色红包口
    _lineLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,self.frame.size.width, self.frame.size.height*2/3.0) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
    CGPoint startPoint = CGPointMake(0,self.frame.size.height*2/3.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width, self.frame.size.height*2/3.0);
    CGPoint controlPoint = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*4/5.0);
    //曲线起点
    [path moveToPoint:startPoint];
    //曲线终点和控制基点
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    //曲线部分颜色和阴影
    [_lineLayer setFillColor:[UIColor colorWithRed:0.851 green:0.3216 blue:0.2784 alpha:1.0].CGColor];
    [_lineLayer setStrokeColor:[UIColor colorWithRed:0.9401 green:0.0 blue:0.0247 alpha:0.02].CGColor];
    [_lineLayer setShadowColor:[UIColor blackColor].CGColor];
    [_lineLayer setLineWidth:0.1];
    [_lineLayer setShadowOffset:CGSizeMake(6, 6)];
    [_lineLayer setShadowOpacity:0.2];
    [_lineLayer setShadowOffset:CGSizeMake(1, 1)];
    _lineLayer.path = path.CGPath;
    _lineLayer.zPosition = 1;
    [self.layer addSublayer:_lineLayer];
    
    //发红包按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100*APP_WIDTH/375.0, 100*APP_WIDTH/375.0)];
    sendBtn.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height*2/3.0+(self.frame.size.height*4/5.0-self.frame.size.height*2/3.0)/2.0);
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = sendBtn.bounds.size.height/2.0;
    [sendBtn setTitle:@"拆红包" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(moveAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundColor:[UIColor brownColor]];
    sendBtn.layer.zPosition = 3;
    [self addSubview:sendBtn];
    
    _logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-(self.frame.size.height/3-80)/2.0, 40, self.frame.size.height/3-80, self.frame.size.height/3-80)];
    _logoImageView.image=[UIImage imageNamed:@"logo"];
    _logoImageView.layer.cornerRadius=4;
    _logoImageView.clipsToBounds=YES;
    _logoImageView.layer.zPosition=3;
    [self addSubview:_logoImageView];
    
    //添加标题按钮
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/3.0-20, self.frame.size.width, 20)];
    _titleLabel.text=@"圈圈保送您一个现金红包";
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont systemFontOfSize:15];
    _titleLabel.textColor=[UIColor orangeColor];
    _titleLabel.layer.zPosition=3;
    [self addSubview:_titleLabel];
    
    //关闭按钮
    _closeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _closeButton.layer.zPosition=3;
    [_closeButton setImage:[UIImage imageNamed:@"绑定失败"] forState:0];
    [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
}


//点击开红包按钮
- (void)moveAnimation:(UIButton *)sender{
    //拆红包按钮旋转动画
    [self rotationButton:sender];
    //模拟请求服务器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //服务器请求成功移除拆红包按钮
        [sender removeFromSuperview];
        //封口动画
        [self openAnimation];
        //钱数
        [self getMoney:5.66];
     });
}

//按钮做旋转动画
- (void)rotationButton:(UIButton *)sender{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.toValue = [NSNumber numberWithFloat: M_PI];
    transformAnima.duration = 0.5;
    transformAnima.cumulative = YES;
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = HUGE_VALF;
    transformAnima.fillMode = kCAFillModeForwards;
    transformAnima.removedOnCompletion = NO;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    sender.layer.zPosition = 5;
    sender.layer.zPosition = sender.layer.frame.size.width/2.f;
    [sender.layer addAnimation:transformAnima forKey:@"rotationAnimationY"];
}

//盖子做个动画
- (void)openAnimation{
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, [[NSString stringWithFormat:@"%.0f",self.frame.size.height/6.0] integerValue]) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
    CGPoint startPoint = CGPointMake(0,  [[NSString stringWithFormat:@"%.0f",self.frame.size.height/6.0] integerValue]);
    CGPoint endPoint = CGPointMake(self.frame.size.width, [[NSString stringWithFormat:@"%.0f",self.frame.size.height/6.0] integerValue]);
    CGPoint controlPoint = CGPointMake(self.frame.size.width*0.5, self.frame.size.height/6.0*2);
    //曲线起点+
    [newPath moveToPoint:startPoint];
    //曲线终点和控制基点
    [newPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.toValue = (id)newPath.CGPath;
    
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width,[[NSString stringWithFormat:@"%.0f",self.frame.size.height/6.0] integerValue]);
    CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"frame"];
    boundsAnim.toValue = [NSValue valueWithCGRect:newFrame];
    
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim, boundsAnim, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 0.1f;
    anims.fillMode  = kCAFillModeForwards;
    [_lineLayer addAnimation:anims forKey:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        _titleLabel.alpha=0;
        _logoImageView.alpha=0;
    }completion:^(BOOL finished) {
        [_titleLabel removeFromSuperview];
        [_logoImageView removeFromSuperview];
    }];
}


//显示本次获得的钱数
- (void)getMoney:(CGFloat )money{
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2.0-25, self.frame.size.width, 50)];
    _moneyLabel.backgroundColor=[UIColor clearColor];
    _moneyLabel.textAlignment=NSTextAlignmentCenter;
    _moneyLabel.layer.zPosition=3;
    _moneyLabel.textColor=[UIColor whiteColor];
    _moneyLabel.font=[UIFont systemFontOfSize:30];
    NSString *moneyStr=[NSString stringWithFormat:@"%.2f元",money];
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:moneyStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(moneyStr.length-1, 1)];
    _moneyLabel.attributedText=attr;
    [self addSubview:_moneyLabel];
    
    _toMyMoneyButton=[[UIButton alloc]initWithFrame:CGRectMake(0, _moneyLabel.frame.size.height+_moneyLabel.frame.origin.y, self.frame.size.width, 50)];
    _toMyMoneyButton.layer.zPosition=3;
    [_toMyMoneyButton setTitle:@"已存入我的钱包，点击查看" forState:0];
    [_toMyMoneyButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_toMyMoneyButton setTitleColor:[UIColor blueColor] forState:0];
    [_toMyMoneyButton addTarget:self action:@selector(look:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_toMyMoneyButton];

}

//查看我的钱包
- (void)look:(UIButton *)sender{
    self.LookBlock?self.LookBlock():nil;
}


//关闭
- (void)close:(UIButton *)sender{
    self.CloseBlock?self.CloseBlock():nil;
}

@end
