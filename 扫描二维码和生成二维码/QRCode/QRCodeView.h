//
//  QRCodeView.h
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QRCodeView;
@protocol QRCodeViewDelegate <NSObject>

- (void)codeScanningView:(QRCodeView *)scanningView didClickedTorchSwitch:(UIButton *)switchButton;

@end

@interface QRCodeView : UIView

@property (nonatomic, readonly, assign) CGRect rectFrame;
@property (nonatomic, weak) id<QRCodeViewDelegate>delegate;

/***
 * 初始化
 ***/
- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame rectColor:(UIColor *)rectColor;

- (instancetype)initWithFrame:(CGRect)frame rectColor:(UIColor *)rectColor;

- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame;

/**
 * 开始扫描和结束扫描
 **/
- (void)startScanning;
- (void)stopScanning;
/**
 * 开启指示和停止指示
 **/
- (void)startIndicating;
- (void)stopIndicating;
/**
 * 显示和隐藏开关
 **/
- (void)showTorchSwitch;
- (void)hideTorchSwitch;

@end

NS_ASSUME_NONNULL_END
