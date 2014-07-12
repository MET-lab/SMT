//
//  FloatFunctions.m
//  AudioGenerator
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "FloatFunctions.h"

@implementation FloatFunctions

+(float) max:(float *)array numElements:(int)size {
    float max = array[0];
    for (int i=0;i<size;i++) {
        if (array[i]>max) {
            max = array[i];
        }
    }
    return max;
}

+(float) min:(float *)array numElements:(int)size {
    float min = array[0];
    for (int i=0;i<size;i++) {
        if (array[i]<min) {
            min = array[i];
        }
    }
    return min;
}

+(void) round:(float *)array numElements:(int)size {
    for (int i = 0;i<size;i++) {
        array[i] = roundf(array[i]);
    }
}

+(void) ceil:(float *)array numElements:(int)size {
    for (int i = 0;i<size;i++) {
        array[i] = ceilf(array[i]);
    }
}

+(void) floor:(float *)array numElements:(int)size {
    for (int i = 0;i<size;i++) {
        array[i] = floorf(array[i]);
    }
}

@end