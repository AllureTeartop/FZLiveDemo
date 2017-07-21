//
//  ViewController.m
//  VideoCapture
//
//  Created by Florence on 2017/7/20.
//  Copyright © 2017年 AllureTeartop. All rights reserved.
//

#import "ViewController.h"
#import <LFLiveKit.h>


@interface ViewController ()<LFLiveSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *livingPreView;
@property (weak, nonatomic) IBOutlet UIButton *livingButton;


@property (nonatomic, strong) LFLiveSession *session;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
   
}
#pragma mark --------- init --------
-(void)initView{

    //默认开始前置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionFront;
}

#pragma mark -------- action ------------
- (IBAction)living:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) { // 开始直播
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        // 如果是跟我blog教程搭建的本地服务器, 记得填写你电脑的IP地址
        stream.url = @"rtmp://192.168.1.108:1935/rtmplive/room";
        [self.session startLive:stream];
    }else{ // 结束直播
        [self.session stopLive];
    }
}
//切换摄像头
- (IBAction)change:(UIButton *)sender {
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    NSLog(@"切换前置/后置摄像头");
}
- (IBAction)close:(UIButton *)sender {
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
}
- (IBAction)beautiful:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    // 默认是开启了美颜功能的
    self.session.beautyFace = !self.session.beautyFace;
    self.session.beautyLevel = 1.0;
    self.session.brightLevel = 0.7;
}

#pragma mark -- LFStreamingSessionDelegate

- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    NSLog(@"%@",tempStatus);
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}
#pragma mark ------ lazy ----------------
- (LFLiveSession*)session{
    if(!_session){
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality:LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Low3 landscape:NO]];

        // 设置代理
        _session.showDebugInfo = NO;
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}











@end
