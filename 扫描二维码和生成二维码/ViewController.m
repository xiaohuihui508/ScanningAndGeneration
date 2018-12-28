//
//  ViewController.m
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeScanningVC.h"
#import "QRCodeGenerationVC.h"


@interface ViewController ()

@property (nonatomic, strong) UIButton *scanningBtn;

@property (nonatomic, strong) UIButton *generationBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫二维码和生成二维码";
    
    _scanningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanningBtn.backgroundColor = [UIColor redColor];
    _scanningBtn.frame = CGRectMake(100, 100, 100, 30);
    [_scanningBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [_scanningBtn addTarget:self action:@selector(scanningBtnWithAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanningBtn];
    
    _generationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _generationBtn.backgroundColor = [UIColor redColor];
    _generationBtn.frame = CGRectMake(100, 200, 100, 30);
    [_generationBtn setTitle:@"生成" forState:UIControlStateNormal];
    [_generationBtn addTarget:self action:@selector(generationBtnWithAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_generationBtn];
    
    
    
}

- (void)scanningBtnWithAction:(UIButton *)sender {
    QRCodeScanningVC *vc = [[QRCodeScanningVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)generationBtnWithAction:(UIButton *)sender {
    QRCodeGenerationVC *vc = [[QRCodeGenerationVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
