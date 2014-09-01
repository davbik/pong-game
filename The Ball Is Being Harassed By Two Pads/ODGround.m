//
//  ODGround.m
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODGround.h"
#import "ODUtil.h"

@implementation ODGround

+(instancetype)ground {
    ODGround *ground = [self spriteNodeWithImageNamed:@"ground"];
    
    return ground;
}

@end
