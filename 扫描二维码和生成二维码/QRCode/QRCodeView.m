//
//  QRCodeView.m
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import "QRCodeView.h"

@interface QRCodeView ()

@property (nonatomic, strong) CAShapeLayer *rectLayer;
@property (nonatomic, strong) CAShapeLayer *cornerLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CABasicAnimation *lineAnimation;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIButton *torchSwitchButton;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    return [[QRCodeView alloc] initWithFrame:frame rectFrame:CGRectZero rectColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame rectColor:(UIColor *)rectColor {
    return [[QRCodeView alloc] initWithFrame:frame rectFrame:CGRectZero rectColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame {
    return [[QRCodeView alloc] initWithFrame:frame rectFrame:rectFrame rectColor:[UIColor clearColor]];
}

- (instancetype)initWithFrame:(CGRect)frame rectFrame:(CGRect)rectFrame rectColor:(UIColor *)rectColor {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (CGRectEqualToRect(rectFrame, CGRectZero)) {
            CGFloat rectSide = fminf(self.layer.bounds.size.width, self.layer.bounds.size.height)* 2/3;
            rectFrame = CGRectMake((self.layer.bounds.size.width - rectSide) / 2, (self.layer.bounds.size.height - rectSide) / 2, rectSide, rectSide);
        }
        if (CGColorEqualToColor(rectColor.CGColor, [UIColor clearColor].CGColor)) {
            rectColor = [UIColor whiteColor];
        }
        
        //根据自定义的rectFrame画矩形框(扫码框)
        [self.layer masksToBounds];
        [self clipsToBounds];
        
        CGFloat lineWidth = .5;
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:(CGRect){lineWidth / 2, lineWidth / 2, rectFrame.size.width - lineWidth, rectFrame.size.height - lineWidth}];
        _rectLayer = [CAShapeLayer layer];
        _rectLayer.fillColor = [UIColor clearColor].CGColor;
        _rectLayer.strokeColor = rectColor.CGColor;
        _rectLayer.path = rectPath.CGPath;
        _rectLayer.lineWidth = lineWidth;
        _rectLayer.frame = rectFrame;
        [self.layer addSublayer:_rectLayer];
        
        //根据rectFrame创建矩形拐角路径
        CGFloat cornerWidth = 2.0;
        CGFloat cornerLenth = fminf(rectFrame.size.width, rectFrame.size.height) / 12;
        UIBezierPath *cornerPath = [UIBezierPath bezierPath];
        //左上角
        [cornerPath moveToPoint:(CGPoint){cornerWidth / 2, .0}];
        [cornerPath addLineToPoint:(CGPoint){cornerWidth / 2, cornerLenth}];
        [cornerPath moveToPoint:(CGPoint){.0, cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){cornerLenth, cornerWidth / 2}];
        //右上角
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width, cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerLenth, cornerWidth / 2}];
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, .0}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, cornerLenth}];
        //右下角
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, rectFrame.size.height}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerWidth / 2, rectFrame.size.height - cornerLenth}];
        [cornerPath moveToPoint:(CGPoint){rectFrame.size.width, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){rectFrame.size.width - cornerLenth, rectFrame.size.height - cornerWidth / 2}];
        //左下角
        [cornerPath moveToPoint:(CGPoint){.0, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath addLineToPoint:(CGPoint){cornerLenth, rectFrame.size.height - cornerWidth / 2}];
        [cornerPath moveToPoint:(CGPoint){cornerWidth / 2, rectFrame.size.height}];
        [cornerPath addLineToPoint:(CGPoint){cornerWidth / 2, rectFrame.size.height - cornerLenth}];
        
        //根据矩形拐角路径画矩形拐角
        _cornerLayer = [CAShapeLayer layer];
        _cornerLayer.frame = rectFrame;
        _cornerLayer.path = cornerPath.CGPath;
        _cornerLayer.lineWidth = cornerPath.lineWidth;
        _cornerLayer.strokeColor = rectColor.CGColor;
        [self.layer addSublayer:_cornerLayer];
        
        //遮罩 + 镂空
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
        UIBezierPath *subPath = [[UIBezierPath bezierPathWithRect:rectFrame] bezierPathByReversingPath];
        [maskPath appendPath:subPath];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor colorWithWhite:.0 alpha:.6].CGColor;
        maskLayer.path = maskPath.CGPath;
        [self.layer addSublayer:maskLayer];
        
        //根据rectFrame画扫描线
        CGRect lineFrame = (CGRect){rectFrame.origin.x + 5.0, rectFrame.origin.y, rectFrame.size.width - 5.0 * 2, 1.5};
        UIBezierPath *linePath = [UIBezierPath bezierPathWithOvalInRect:(CGRect){.0, .0, lineFrame.size.width, lineFrame.size.height}];
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.frame = lineFrame;
        _lineLayer.path = linePath.CGPath;
        _lineLayer.fillColor = rectColor.CGColor;
        _lineLayer.shadowColor = rectColor.CGColor;
        _lineLayer.shadowRadius = 5.0;
        _lineLayer.shadowOffset = CGSizeMake(.0, .0);
        _lineLayer.shadowOpacity = 1.0;
        _lineLayer.hidden = YES;
        [self.layer addSublayer:_lineLayer];
        
        //扫描线动画
        _lineAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        _lineAnimation.fromValue = [NSValue valueWithCGPoint:(CGPoint){_lineLayer.frame.origin.x + _lineLayer.frame.size.width / 2, rectFrame.origin.y + _lineLayer.frame.size.height}];
        _lineAnimation.toValue = [NSValue valueWithCGPoint:(CGPoint){_lineLayer.frame.origin.x + _lineLayer.frame.size.width / 2, rectFrame.origin.y + rectFrame.size.height - _lineLayer.frame.size.height}];
        _lineAnimation.repeatCount = CGFLOAT_MAX;
        _lineAnimation.autoreverses = YES;
        _lineAnimation.duration = 2.0;
        
        //手电筒开关
        _torchSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _torchSwitchButton.frame = CGRectMake(.0, .0, 60.0, 70.0);
        _torchSwitchButton.center = CGPointMake(CGRectGetMidX(rectFrame), CGRectGetMaxY(rectFrame) - CGRectGetMidY(_torchSwitchButton.bounds));
        _torchSwitchButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_torchSwitchButton setTitle:@"轻触照亮" forState:UIControlStateNormal];
        [_torchSwitchButton setTitle:@"轻触关闭" forState:UIControlStateSelected];
        [_torchSwitchButton setImage:[UIImage imageNamed:@"qi_torch_switch_off"] forState:UIControlStateNormal];
        [_torchSwitchButton setImage:[[UIImage imageNamed:@"qi_torch_switch_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        [_torchSwitchButton addTarget:self action:@selector(torchSwitchClicked:) forControlEvents:UIControlEventTouchUpInside];
        _torchSwitchButton.tintColor = rectColor;
        _torchSwitchButton.titleEdgeInsets = UIEdgeInsetsMake(_torchSwitchButton.imageView.frame.size.height + 5.0, -_torchSwitchButton.imageView.bounds.size.width, .0, .0);
        _torchSwitchButton.imageEdgeInsets = UIEdgeInsetsMake(.0, _torchSwitchButton.titleLabel.bounds.size.width / 2, _torchSwitchButton.titleLabel.frame.size.height + 5.0, - _torchSwitchButton.titleLabel.bounds.size.width / 2);
        _torchSwitchButton.hidden = YES;
        [self addSubview:_torchSwitchButton];
        
        //提示语label
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:13.0];
        _tipsLabel.text = @"将二维码/条形码放入框内即可自动扫描";
        _tipsLabel.numberOfLines = 0;
        [_tipsLabel sizeToFit];
        _tipsLabel.center = CGPointMake(CGRectGetMidX(rectFrame), CGRectGetMaxY(rectFrame) + CGRectGetMidY(_tipsLabel.bounds)+ 12.0);
        [self addSubview:_tipsLabel];
        
        // 等待指示view
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:rectFrame];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark -- Public functions
- (CGRect)rectFrame {
    return _rectLayer.frame;
}

- (void)startScanning {
    _lineLayer.hidden = NO;
    [_lineLayer addAnimation:_lineAnimation forKey:@"lineAnimation"];
}

- (void)stopScanning {
    _lineLayer.hidden = YES;
    [_lineLayer removeAnimationForKey:@"lineAnimation"];
}

- (void)startIndicating {
    [_indicatorView stopAnimating];
}

- (void)stopIndicating {
    [_indicatorView stopAnimating];
}

- (void)showTorchSwitch {
    _torchSwitchButton.hidden = NO;
    _torchSwitchButton.alpha = .0;
    [UIView animateWithDuration:.25 animations:^{
        self.torchSwitchButton.alpha = 1.0;
    }];
}

- (void)hideTorchSwitch {
    [UIView animateWithDuration:.1 animations:^{
        self.torchSwitchButton.alpha = .0;
    } completion:^(BOOL finished) {
        self.torchSwitchButton.hidden = YES;
    }];
}

#pragma mark - Private functions
- (void)didAddSubview:(UIView *)subview {
    if (subview == _indicatorView) {
        [_indicatorView startAnimating];
    }
}
#pragma mark - Action functions
- (void)torchSwitchClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(codeScanningView:didClickedTorchSwitch:)]) {
        [self.delegate codeScanningView:self didClickedTorchSwitch:sender];
    }
    
}

@end
