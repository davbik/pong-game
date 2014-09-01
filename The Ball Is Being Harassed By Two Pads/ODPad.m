//
//  ODPad.m
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODPad.h"
#import "ODUtil.h"

@implementation ODPad

+(instancetype) pad {
    ODPad *pad = [self spriteNodeWithImageNamed:@"pad2"];
    pad.texture.filteringMode = SKTextureFilteringNearest;
    pad.anchorPoint = CGPointMake(0.0, 0.0);
    
    pad.halfHight = pad.frame.size.height / 2;
    
    return pad;
}

@end
