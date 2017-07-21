//
//  ViewController.m
//  player
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 thc. All rights reserved.
//

#import "ViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "QNDnsManager.h"
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>


@interface ViewController ()<PLPlayerDelegate>

@property(nonatomic,strong)PLPlayer *player;
@property (nonatomic, strong) PLMediaStreamingSession *session;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // 初始化 PLPlayerOption 对象
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    [option setOptionValue:[QNDnsManager new] forKey:PLPlayerOptionKeyDNSManager];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSURL * url = [NSURL URLWithString:@"rtmp://192.168.1.108:1935/rtmplive/room"];
    // 初始化 PLPlayer
    self.player = [PLPlayer playerWithURL:url option:option];
    
    self.player.playerView.frame = CGRectMake(0, 0, 300, 400);
    
    // 设定代理 (optional)
    self.player.delegate = self;
    
    //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    [self.view addSubview:self.player.playerView];
    
    [self.player play];
    
//    PLPlayerOption *option = [PLPlayerOption defaultOption];
//    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
//    //播放url
//    NSURL *url = [NSURL URLWithString:@"rtmp://192.168.1.108:1935/rtmplive/room"];
//
//    self.player = [PLPlayer playerWithURL:url option:option];
//    self.player.delegate = self;
//    self.player.playerView.frame = self.view.bounds;
//    self.player.playerView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.player.playerView];
//    
//    [self.player play];
//    [self initSession];
    
}


-(void)initSession{

    PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
    PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
    PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
    PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
    self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
    self.session.previewView.frame = CGRectMake(0, 0, 300, 400);
    [self.view addSubview:self.session.previewView];
    NSURL *pushURL = [NSURL URLWithString:@"rtmp://192.168.1.108:1935/rtmplive/room"];
    
    [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
        if (feedback == PLStreamStartStateSuccess) {
            NSLog(@"Streaming started.");
        }
        else {
            NSLog(@"Oops.");
        }
    }];





}
// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误时，会回调这个方法
    
}





@end
