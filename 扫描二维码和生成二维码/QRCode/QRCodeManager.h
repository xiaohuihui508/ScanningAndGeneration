//
//  QRCodeManager.h
//  扫描二维码和生成二维码
//
//  Created by isoft on 2018/12/28.
//  Copyright © 2018 isoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QRCodeView.h"


NS_ASSUME_NONNULL_BEGIN

@interface QRCodeManager : NSObject

//扫描二维码/条形码
- (instancetype)initWithPreviewView:(QRCodeView *)previewView completion:(void(^)(void))completion;
- (void)startScanningWithCallback:(void(^)(NSString *))callback autoStop:(BOOL)autoStop;
- (void)startScanningWithCallback:(void(^)(NSString *))callback;
- (void)stopScanning;
- (void)presentPhotoLibraryWithRooter:(UIViewController *)rooter callback:(void(^)(NSString *))callback;

//生成二维码/条形码

+ (UIImage *)generateQRCode:(NSString *)code size:(CGSize)size;
+ (UIImage *)generateQRCode:(NSString *)code size:(CGSize)size logo:(UIImage *)logo;
+ (UIImage *)generateCode128:(NSString *)code size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
