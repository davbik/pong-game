//
//  ODGameplayScene.m
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODGameplayScene.h"
#import "ODGameOverScene.h"
#import "ODPad.h"
#import "ODBall.h"
#import "ODGround.h"
#import "ODUtil.h"

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, ODBallStartDirection) {
    ODBallStartDirectionLeft,
    ODBallStartDirectionRight
};

@interface ODGameplayScene ()

@property (nonatomic) ODPad *playerPad;
@property (nonatomic) ODPad *aiPad;
@property (nonatomic) ODBall *ball;

@property (nonatomic) ODGround *upGround;
@property (nonatomic) ODGround *downGround;

@property (nonatomic) SKLabelNode *aiScoreLabel;
@property (nonatomic) SKLabelNode *playerScoreLabel;

@property (nonatomic) NSInteger aiScore;
@property (nonatomic) NSInteger playerScore;

@property (nonatomic) NSTimeInterval prevTime;

@property (nonatomic) ODBallStartDirection ballStartDirection;

@property (nonatomic) SKAction *boopSFX;
@property (nonatomic) SKAction *explosionSFX;

@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation ODGameplayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.texture.filteringMode = SKTextureFilteringNearest;
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.ballStartDirection = ODBallStartDirectionRight;
        self.aiScore = 0;
        self.playerScore = 0;
        
        [self setupSound];
        
        self.aiScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        self.aiScoreLabel.fontColor = [UIColor colorWithRed:(45/255.0) green:(125/255.0) blue:(220/255.0) alpha:1.0];
        self.aiScoreLabel.fontSize = 48;
        self.aiScoreLabel.text = @"0";
        self.aiScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 155, CGRectGetMidY(self.frame) - 15);
        [self addChild:self.aiScoreLabel];
        
        self.playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        self.playerScoreLabel.fontColor = [UIColor colorWithRed:(45/255.0) green:(125/255.0) blue:(220/255.0) alpha:1.0];
        self.playerScoreLabel.fontSize = 48;
        self.playerScoreLabel.text = @"0";
        self.playerScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 155, CGRectGetMidY(self.frame) - 15);
        [self addChild:self.playerScoreLabel];
        
        self.playerPad = [ODPad pad];
        self.playerPad.position = CGPointMake(self.frame.size.width - ODPlayerPadOffsetX,
                                              CGRectGetMidY(self.frame) - self.playerPad.frame.size.height/2);
        [self addChild:self.playerPad];
        
        self.aiPad = [ODPad pad];
        self.aiPad.position = CGPointMake(ODPlayerPadOffsetX-10, CGRectGetMidY(self.frame) - self.aiPad.frame.size.height/2);
        [self addChild:self.aiPad];
        
        self.ball = [ODBall ballWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        [self addChild:self.ball];
        [self resetBall];
        
        self.upGround = [ODGround ground];
        self.upGround.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-5);
        [self addChild:self.upGround];
        
        self.downGround = [ODGround ground];
        self.downGround.position = CGPointMake(self.frame.size.width/2, 5);
        [self addChild:self.downGround];
        
    }
    return self;
}

-(void) setupSound {
    self.boopSFX = [SKAction playSoundFileNamed:@"boop.caf" waitForCompletion:NO];
    self.explosionSFX = [SKAction playSoundFileNamed:@"explosions.caf" waitForCompletion:NO];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Pinball Spring" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    self.backgroundMusic.volume = 0.3;
    [self.backgroundMusic prepareToPlay];
}

-(void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

-(void) resetBall {
    self.ball.velocityX = 0.0;
    self.ball.velocityY = 0.0;
    self.ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self.ball setScale:0];
    SKAction *ballAnimation = [SKAction sequence:@[[SKAction waitForDuration:0.2],
                                                   [SKAction scaleTo:1.2 duration:0.5],
                                                   [SKAction scaleTo:1.0 duration:0.3],
                                                   [SKAction waitForDuration:0.2]]];
    [self.ball runAction:ballAnimation completion:^{
        if (self.ballStartDirection == ODBallStartDirectionRight) {
            self.ball.velocityX = 200;
        } else {
            self.ball.velocityX = -200;
        }
        self.ball.velocityY = [ODUtil randomWithMin:-20 max:21];
    }];
}

-(void) update:(NSTimeInterval)currentTime {
    
    if (self.prevTime == 0.0) {
        self.prevTime = currentTime;
    }
    float delta = currentTime - self.prevTime;
    [self.ball updade:delta];
    [self updateAiPad:delta];
    [self checkCollisions];
    
    self.prevTime = currentTime;
}

-(void)updateAiPad:(float)delta {
    float padCenterY = self.aiPad.position.y + self.aiPad.halfHight;
    float diff = padCenterY - self.ball.position.y;
    if (fabsf(diff) > 1) {
        float speed = -diff * ODAIPadSpeed;
        self.aiPad.position = CGPointMake(self.aiPad.position.x, self.aiPad.position.y + speed * delta);
    }
    [self containPadY:self.aiPad];
}

-(void)checkCollisions {
    if (CGRectIntersectsRect(self.ball.frame, self.playerPad.frame)) {
        [self padCollision:self.playerPad];
        [self createParticle];
        [self runAction:self.boopSFX];
    }
    if (CGRectIntersectsRect(self.ball.frame, self.aiPad.frame)) {
        [self padCollision:self.aiPad];
        [self createParticle];
        [self runAction:self.boopSFX];
    }
    if (self.ball.position.x > self.frame.size.width - 10 ||
        self.ball.position.x < 10) {
        [self createExplosion];
        [self runAction:self.explosionSFX];
        [self addScore];
        [self resetBall];
    }
    if (self.ball.position.y > self.frame.size.height - 20 ||
        self.ball.position.y < 20) {
        [self createParticle];
        [self runAction:self.boopSFX];
        self.ball.velocityX = self.ball.velocityX;
        self.ball.velocityY = -self.ball.velocityY;
    }
}

-(void)createParticle {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"]];
    emitter.emissionAngle = atan2(self.ball.velocityY, -self.ball.velocityX) + M_PI;
    emitter.position = self.ball.position;
    [self addChild:emitter];
}

-(void)createExplosion {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"]];
    emitter.position = self.ball.position;
    [self addChild:emitter];
}

-(void)padCollision:(ODPad*)pad {
    float ballCenterY = self.ball.position.y;
    float padCenterY = pad.position.y + pad.halfHight;
    if (ballCenterY < padCenterY) {
        float factor = (padCenterY - ballCenterY) / (pad.halfHight / 10);
        self.ball.velocityY = -(factor * 20);
    } else if (ballCenterY > padCenterY) {
        float factor = (ballCenterY - padCenterY) / (pad.halfHight / 10);
        self.ball.velocityY = (factor * 20);
    } else {
        self.ball.velocityY = -self.ball.velocityY;
    }
    self.ball.velocityX *= -1;
    if (fabs(self.ball.velocityX) < 500) {
        self.ball.velocityX *= 1.05;
    }
    //NSLog(@"%f %f %f",padCenterY,self.ball.position.y,self.ball.velocityY);
}

-(void)containPadY:(ODPad*)pad {
    if (pad.position.y < 20) {
        pad.position = CGPointMake(pad.position.x, 20);
    } else if (pad.position.y + pad.frame.size.height > self.frame.size.height - 20) {
        pad.position = CGPointMake(pad.position.x, self.frame.size.height - pad.frame.size.height - 20);
    }
}

-(void)addScore {
    SKAction *animation = [SKAction sequence:@[[SKAction scaleTo:1.2 duration:0.5],
                                               [SKAction scaleTo:1.0 duration:0.3]]];
    if (self.ball.position.x > CGRectGetMidX(self.frame)) {
        self.aiScore += 1;
        self.aiScoreLabel.text = [NSString stringWithFormat:@"%d", self.aiScore];
        [self.aiScoreLabel runAction:animation];
        self.ballStartDirection = ODBallStartDirectionRight;
    } else {
        self.playerScore += 1;
        self.playerScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerScore];
        [self.playerScoreLabel runAction:animation];
        self.ballStartDirection = ODBallStartDirectionLeft;
    }
    if (self.aiScore > 9 || self.playerScore > 9) {
        ODGameOverScene *gameoverScene = [ODGameOverScene sceneWithSize:self.frame.size];
        SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:1.0];
        [self.view presentScene:gameoverScene transition:transition];
        [self.backgroundMusic stop];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *drag = [touches anyObject];
    
    CGPoint p = [drag locationInNode:self];
    CGPoint prevP = [drag previousLocationInNode:self];
    self.playerPad.position = CGPointMake(self.playerPad.position.x,
                                          self.playerPad.position.y + (p.y - prevP.y));

    [self containPadY:self.playerPad];
}

@end
