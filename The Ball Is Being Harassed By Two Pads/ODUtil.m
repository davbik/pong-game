//
//  ODUtil.m
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import "ODUtil.h"

@implementation ODUtil

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random() % (max - min) + min;
}

+(float)clamp:(float)value from:(float)from to:(float)to {
    float res;
    if (value <= from) {
        res = from;
    } else {
        res = to;
    }
    return res;
}

@end
