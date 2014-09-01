//
//  ODTitleScene.m
//  The Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODTitleScene.h"
#import "ODGameplayScene.h"

#import <AVFoundation/AVFoundation.h>

@interface ODTitleScene ()
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@end

@implementation ODTitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"SavoyeLetPlain"];
        myLabel.text = @"A Ball Is Being Harassed By Two Pads";
        myLabel.fontColor = [UIColor colorWithRed:(45/255.0) green:(125/255.0) blue:(220/255.0) alpha:1.0];
        myLabel.fontSize = 42;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 33);
        [self addChild:myLabel];
        
        SKLabelNode *myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"SavoyeLetPlain"];
        myLabel2.fontColor = [UIColor colorWithRed:(45/255.0) green:(125/255.0) blue:(220/255.0) alpha:1.0];
        myLabel2.text = @"by Oleg Drobin";
        myLabel2.fontSize = 28;
        myLabel2.position = CGPointMake(CGRectGetMidX(self.frame), myLabel.position.y-30);
        [self addChild:myLabel2];
        
        SKLabelNode *myLabel3 = [SKLabelNode labelNodeWithFontNamed:@"SavoyeLetPlain"];
        myLabel3.fontColor = [UIColor colorWithRed:(45/255.0) green:(125/255.0) blue:(220/255.0) alpha:1.0];
        myLabel3.text = @"Touch to Start";
        myLabel3.fontSize = 32;
        myLabel3.position = CGPointMake(CGRectGetMidX(self.frame), myLabel2.position.y-60);
        [self addChild:myLabel3];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Home Base Groove" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    ODGameplayScene *gameplayScene = [ODGameplayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:1.0f];
    [self.view presentScene:gameplayScene transition:transition];
    [self.backgroundMusic stop];
}

@end
