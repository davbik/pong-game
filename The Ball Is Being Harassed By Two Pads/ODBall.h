//
//  ODBall.h
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ODBall : SKSpriteNode

@property (nonatomic) float velocityX;
@property (nonatomic) float velocityY;

@property (nonatomic) float halfHight;

+(instancetype) ballWithPosition:(CGPoint)position;

-(void)updade:(NSTimeInterval)delta;

@end
