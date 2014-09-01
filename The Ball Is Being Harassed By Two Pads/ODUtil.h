//
//  ODUtil.h
//  A Ball Is Being Harassed By Two Pads
//
//  Created by Oleg Drobin on 31.08.14.
//  Copyright (c) 2014 Oleg Drobin. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ODPlayerPadOffsetX = 50;
static const int ODAIPadSpeed = 4.8;

typedef NS_OPTIONS(uint32_t, ODCollisionCategory) {
    ODCollisionCategoryBall        = 1 << 0,
    ODCollisionCategoryPad         = 1 << 1,
    ODCollisionCategoryGoal        = 1 << 2,
    ODCollisionCategoryGround      = 1 << 3
};

@interface ODUtil : NSObject

+(NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

+(float)clamp:(float)value from:(float)from to:(float)to;

@end
