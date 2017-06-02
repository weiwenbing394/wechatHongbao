//
//  RedEnvelope.h
//  WeChatHongBao
//
//  Created by 大家保 on 2017/6/2.
//  Copyright © 2017年 小魏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelope : UIView

@property (nonatomic,copy) void (^CloseBlock) ();

@property (nonatomic,copy) void (^LookBlock)  ();

@end
