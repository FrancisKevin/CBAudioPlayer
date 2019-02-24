//
//  ViewController.m
//  CBAudioPlayer
//
//  Created by FrancisKevin on 2019/2/20.
//  Copyright © 2019年 KF. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "CBTimeUtils.h"

@interface ViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *labProgress;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAudioSession];
}

#pragma mark - Setup
- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];// 支持后台播放
    [audioSession setActive:YES error:nil];
}

#pragma mark - Button Action
- (IBAction)playAudioAction:(id)sender {
    if (self.audioPlayer) {
        if (self.audioPlayer.playing) {
            [self pause];
            [self printLog];
            
        } else {
            [self play];
        }
        
    } else {
        NSURL *url = [NSURL fileURLWithPath:[self filePathWithName:@"music1.mp3"]];
        NSError *error = nil;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.delegate = self;
        audioPlayer.numberOfLoops = 0;
        audioPlayer.volume = 1.0f;
        [audioPlayer prepareToPlay];
        
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        } else {
            NSLog(@"开始播放");
            self.audioPlayer = audioPlayer;
            [self play];
        }
    }
    
    [self setupPlayButtonStatus];
}

- (IBAction)nextAction:(id)sender {
    [self stop];
    _audioPlayer = nil;
    [self playAudioAction:nil];
}


- (void)play {
    [self.audioPlayer play];
    
    [self setupProgressBar];
}

- (void)pause {
    if (self.audioPlayer.playing) {
        [self.audioPlayer pause];
    }
    
    [self stopDisplayLink];
}

- (void)stop {
    if (self.audioPlayer.playing) {
        [self.audioPlayer stop];
    }
    
    [self stopDisplayLink];
}

- (void)setupProgressBar {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshProgressBar)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)refreshProgressBar {
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    NSTimeInterval duration = self.audioPlayer.duration;
    
    self.labProgress.text = [NSString stringWithFormat:@"%@ / %@", [CBTimeUtils mmssWithSeconds:currentTime], [CBTimeUtils mmssWithSeconds:duration]];
}

- (void)stopDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)setupPlayButtonStatus {
    if (self.audioPlayer.playing) {
        [self.btnPlay setTitle:@"暂停" forState:UIControlStateNormal];
    } else {
        [self.btnPlay setTitle:@"播放" forState:UIControlStateNormal];
    }
}

- (NSString *)filePathWithName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music1.mp3" ofType:nil];
    return path;
}

- (void)printLog {
    NSTimeInterval duration = self.audioPlayer.duration;
    NSTimeInterval currentTime = self.audioPlayer.currentTime;
    NSLog(@"\n总时间：%.0f \n当前时间：%.0f \n", duration, currentTime);
}

#pragma mark - UIResponder
- (void)remoteControlReceivedWithEvent:(nullable UIEvent *)event {
    NSLog(@"线控操作 type:%ld   subtype:%ld", event.type, event.subtype);
    if (event.type == UIEventTypeRemoteControl) {// 远程控制
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {// 单击
                NSLog(@"播放/暂停");
                [self playAudioAction:nil];
            }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
            {// 双击
                NSLog(@"下一首");
                
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
            {// 三击
                NSLog(@"上一首");
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - AVAudioPlayerDelegate
/**
 声音播放完毕后调用。 如果播放器因中断而停止，则不会调用此方法。

 @param player player description
 @param flag flag description
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"播放完毕，成功。%@", player.url);
        [self setupPlayButtonStatus];
        
    } else {
        NSLog(@"播放完毕，失败。%@", player.url);
        [self setupPlayButtonStatus];
    }
}

/**
 如果在解码时发生错误，则会调用此方法。

 @param player player description
 @param error error description
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"解码错误：%@。%@", player.url, error);
}

@end
