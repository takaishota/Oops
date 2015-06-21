//
//  ViewController.m
//  Oops
//
//  Created by ShotaTakai on 2015/06/21.
//  Copyright (c) 2015年 ShotaTakai. All rights reserved.
//

#import "ViewController.h"
#import "SCLAlertView.h"
#import "UIView+Utility.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()
@property CMMotionManager *motionManager;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation ViewController

static NSString * const kURL = @"http://192.168.233.108:3000/rest/gps?";
#pragma mark - Life Style
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [AFHTTPRequestOperationManager manager];
    
    [self setBackgroundImage];
    [self initSettings];
    [self setupAccelerometer];
}

- (void) setupAccelerometer {
    self.motionManager = [[CMMotionManager alloc] init];
    
    if (self.motionManager.accelerometerAvailable)
    {
        // センサーの更新間隔の指定
        _motionManager.accelerometerUpdateInterval = 1 / 10;  // 10Hz
        
        // ハンドラを指定（繰り返し実行される）
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            // 画面に表示
//            NSLog(@"x %f", data.acceleration.x);
//            NSLog(@"y %f", data.acceleration.y);
//            NSLog(@"z %f", data.acceleration.z);
            
            if ([self isCrushwithAccelerationX:data.acceleration.x y:data.acceleration.y z:data.acceleration.z]) {
                [self.motionManager stopAccelerometerUpdates];
                [self sendPosition];
                
                [self showAlert];
            }
        };
        
        // 加速度の取得開始
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (void)sendPosition {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                  target:self
                                                selector:@selector(testTimerFired:)
                                                userInfo:nil
                                                 repeats:YES];
    
    NSLog(@"start");
}

- (void)stopRequest{
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"stop");
}

- (void)testTimerFired:(NSTimer*)timer {
    
    NSDictionary *parameters = @{@"lat": [NSString stringWithFormat:@"%f", 35.672038],
                                 @"lng": [NSString stringWithFormat:@"%f", 139.737008]
                                 };

    [self.manager GET:kURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respond: %@", responseObject);
        [self stopRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (BOOL)isCrushwithAccelerationX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z {
    
    // 加速度センサの値が激しく動作したときに事故を検知
    if (z > 2.0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setBackgroundImage {
    UIImage *image = [UIImage imageNamed:@"wallpaper.jpg"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
    backgroundView.frame = CGRectMake(self.view.x, self.view.y, self.view.width, self.view.height);
    [self.view addSubview:backgroundView];
}

- (void)initSettings {
    
}

- (void)showAlert {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UIColor *color = [UIColor colorWithRed:0.91 green:0.30 blue:0.24 alpha:1];
    
    if ([self isSyclingMode]) {
        [alert showCustom:self image:[UIImage imageNamed:@"git"] color:color title:@"Oops!" subTitle:@"おっと、事故ですか？サポートデスクに発信しますか？" closeButtonTitle:@"OK" duration:0.0f];
        [alert alertIsDismissed:^{
            [self transitSetting];
        }];
    }
}

- (void)transitSetting {
    NSURL *url = [NSURL URLWithString:@"tel:111"];
//    NSURL *url = [NSURL URLWithString:@"http://maps.apple.com/?ll=35.672038,139.737008"];
    [[UIApplication sharedApplication] openURL:url];
}

// サイクリングモードONかどうか
- (BOOL)isSyclingMode
{
    // サイクリング開始前にsぷりを起動し、サイクリングモードをONにする
    // サイクリングモードがONであれば、加速度の値が激しく変わった時にアラートを表示する（ご発信の防止のため）
    return YES;
}

@end
