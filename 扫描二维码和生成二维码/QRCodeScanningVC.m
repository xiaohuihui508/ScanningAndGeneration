//
//  QRCodeScanningVC.m
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import "QRCodeScanningVC.h"
#import "QRCodeGenerationVC.h"
#import "QRCodeView.h"
#import "QRCodeManager.h"

@interface QRCodeScanningVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) QRCodeView *previewView;
@property (nonatomic, strong) QRCodeManager *codeManager;

@end

@implementation QRCodeScanningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(photo:)];
    self.navigationItem.rightBarButtonItem = photoItem;
    
    _previewView = [[QRCodeView alloc] initWithFrame:self.view.bounds];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_previewView];
    
    __weak typeof(self) weakSelf = self;
    _codeManager = [[QRCodeManager alloc] initWithPreviewView:_previewView completion:^{
        [weakSelf startScanning];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_codeManager stopScanning];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - Action functions

- (void)photo:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [_codeManager presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull code) {
        [weakSelf performSegueWithIdentifier:@"showCodeGeneration" sender:code];
    }];
}


#pragma mark - Private functions

- (void)startScanning {
    
    __weak typeof(self) weakSelf = self;
    [_codeManager startScanningWithCallback:^(NSString * _Nonnull code) {
        [weakSelf performSegueWithIdentifier:@"showCodeGeneration" sender:code];
    } autoStop:YES];
}






@end
