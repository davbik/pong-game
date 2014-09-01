//
//  ODBall.m
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODBall.h"
#import "ODUtil.h"

@implementation ODBall

+(instancetype) ballWithPosition:(CGPoint)position {
    ODBall *ball = [self spriteNodeWithImageNamed:@"ball"];
    ball.texture.filteringMode = SKTextureFilteringNearest;
    ball.position = position;
    
    ball.halfHight = ball.frame.size.height / 2;
    
    return ball;
}

-(void)updade:(NSTimeInterval)delta {
    self.position = CGPointMake((self.position.x + self.velocityX * delta),
                                (self.position.y + self.velocityY * delta));
}

@end
