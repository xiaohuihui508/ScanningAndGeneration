//
//  QRCodeGenerationVC.m
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import "QRCodeGenerationVC.h"
#import "QRCodeManager.h"


@interface QRCodeGenerationVC ()

@property (nonatomic, strong) UIImageView *codeImage;

@property (nonatomic, strong) UITextField *codeTF;

@property (nonatomic, strong) UIButton *qrBtn;
@property (nonatomic, strong) UIButton *codeBtn;
@end

@implementation QRCodeGenerationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}


#pragma mark -- UI
- (void)initUI {
    
    _codeTF = [[UITextField alloc] init];
    _codeTF.placeholder = @"请输入生成二维码的信息";
    _codeTF.borderStyle = UITextBorderStyleLine;
    _codeTF.frame = CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width-100, 40);
    [self.view addSubview:_codeTF];
    
    _codeImage = [[UIImageView alloc] init];
    _codeImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 4, CGRectGetMaxY(_codeTF.frame)+20, 150, 150);
    _codeImage.backgroundColor = [UIColor grayColor];
    _codeImage.userInteractionEnabled = YES;
    [self.view addSubview:_codeImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCodeImage:)];
    [_codeImage addGestureRecognizer:tap];
    
    _qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qrBtn.backgroundColor = [UIColor redColor];
    _qrBtn.frame = CGRectMake(100, CGRectGetMaxY(_codeImage.frame)+50, 100, 30);
    [_qrBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [_qrBtn addTarget:self action:@selector(qrBtnWithAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_qrBtn];
    
     _codeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.backgroundColor = [UIColor redColor];
    _codeBtn.frame = CGRectMake(100, CGRectGetMaxY(_qrBtn.frame)+50, 100, 30);
    [_codeBtn setTitle:@"生成条形码" forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(codeBtnWithAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    
    
}

- (void)qrBtnWithAction:(UIButton *)sender {
    __block NSString *text = _codeTF.text;
    __block CGSize size = _codeImage.bounds.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text.length? text: self.codeTF.placeholder;
        //        UIImage *codeImage = [QiCodeManager generateQRCode:code size:size];
        UIImage *codeImage = [QRCodeManager generateQRCode:code size:size logo:[UIImage imageNamed:@"qi_logo_qrcode"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImage.image = codeImage;
        });
    });
}

- (void)codeBtnWithAction:(UIButton *)sender {
    __block NSString *text = _codeTF.text;
    __block CGSize size = _codeImage.bounds.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text.length? text: self.codeTF.placeholder;
        UIImage *codeImage = [QRCodeManager generateCode128:code size:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImage.image = codeImage;
        });
    });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.codeTF isFirstResponder]) {
        [self.codeTF resignFirstResponder];
    }
}

- (void)tapCodeImage:(UITapGestureRecognizer *)tap {
    NSString *code = _codeTF.text.length? _codeTF.text: _codeTF.placeholder;
    NSURL *codeURL = [NSURL URLWithString:code];
    
    if ([[UIApplication sharedApplication] canOpenURL:codeURL]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用Safari打开链接" message:codeURL.absoluteString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:codeURL];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confimAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
