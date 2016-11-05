//
//  GameViewController.m
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

#import "MapScene.h"
#import "AMGSoundManager.h"
#import "AMGAudioPlayer.h"
@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.drivingDirection = DrivingDirectionForward;
    
    GameScene* gameScene = [[GameScene alloc] initWithSize:self.skview.frame.size];
    
    [self.skview presentScene: gameScene];
    
    self.gameCharacter.layer.magnificationFilter = kCAFilterNearest;
    
    
    self.mapScene = [[MapScene alloc] init];
    
    
    
    self.sceneKitView.scene = self.mapScene;
    
    
    AMGSoundManager* _soundManager = [AMGSoundManager sharedManager];
    [_soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"driving" ofType:@"mp3"] withName:@"driving" inLine:@"driving" withVolume:1 andRepeatCount:-1 fadeDuration:0 withCompletitionHandler:nil];
//    
//    [NSTimer scheduledTimerWithTimeInterval:7 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [soundManager setVolume:0.3 forLine:@"driving" withFadeDuration:1];
//        [soundManager playAudio: [[NSBundle mainBundle] pathForResource:@"drifting" ofType:@"mp3"] withName:@"drifting" inLine:@"drifting" withVolume:0.8 andRepeatCount:0 fadeDuration:0.2 withCompletitionHandler:^(BOOL success, BOOL stopped) {
//        }];
//        [soundManager setVolume:1 forLine:@"driving" withFadeDuration:5];
//
//    }];
    
    
    //self.sceneKitView.allowsCameraControl = YES;
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:animationLength repeats:YES block:^(NSTimer * _Nonnull timer) {
        AMGSoundManager* soundManager = [AMGSoundManager sharedManager];
        if(self.drivingDirection == DrivingDirectionRight) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_right"];
            [gameScene moveRight];
            [self.mapScene moveRight];
            [self.mapScene moveForward];
        } else if(self.drivingDirection == DrivingDirectionLeft) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_left"];
            [gameScene moveLeft];
            [self.mapScene moveLeft];
            [self.mapScene moveForward];
        } else if(self.drivingDirection == DrivingDirectionForward) {
            self.gameCharacter.image = [UIImage imageNamed:@"mario_back"];
            [self.mapScene moveForward];
        }
        
        if (self.drivingDirection != DrivingDirectionForward && ![soundManager isAudioPlayingInLine:@"drifting"] && self.drivingDirection != self.lastDrivingDirection) {
            [soundManager playAudio:[[NSBundle mainBundle] pathForResource:@"drifting" ofType:@"mp3"] withName:@"right" inLine:@"drifting" withVolume:1 andRepeatCount:0 fadeDuration:1 withCompletitionHandler:nil];
            [soundManager setVolume:0.3 forLine:@"driving" withFadeDuration:1];
            [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                [soundManager setVolume:1 forLine:@"driving" withFadeDuration:1];
            }];
        }
        self.lastDrivingDirection = self.drivingDirection;
    }];
    
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        NSLog(@"Camera: %f, %f, %f, %f",self.mapScene.cameraNode.rotation.x,self.mapScene.cameraNode.rotation.y,self.mapScene.cameraNode.rotation.z,self.mapScene.cameraNode.rotation.w);
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    if(touchPoint.x < self.view.frame.size.width / 3.f) {
        self.drivingDirection = DrivingDirectionLeft;
    } else if(touchPoint.x < self.view.frame.size.width * (2.f/3.f)) {
        self.drivingDirection = DrivingDirectionForward;
    } else if(touchPoint.x > self.view.frame.size.width * (2.f/3.f)){
        self.drivingDirection = DrivingDirectionRight;
    }
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
