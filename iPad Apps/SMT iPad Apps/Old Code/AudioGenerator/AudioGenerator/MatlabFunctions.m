//
//  MatlabFunctions.m
//  AudioGenerator
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "MatlabFunctions.h"

@implementation MatlabFunctions

+(float*) linspace:(float)minVal max:(float)maxVal numElements:(int)size {
    
    float *array = (float*)malloc(sizeof(float)*size);
    float step = (maxVal-minVal)/(size-1);
    array[0] = minVal;
    int i;
    for (i = 1;i<size-1;i++) {
        array[i] = array[i-1]+step;
    }
    array[size-1] = maxVal;
    return array;
}

+(float*) logspace:(float)minVal max:(float)maxVal numElements:(int)size {
    
    float min = log10f(minVal);
    float max = log10f(maxVal);
    float *array = [self linspace:min max:max numElements:size];
    for (int i = 0;i<size;i++) {
        array[i] = powf(10,array[i]);
    }
    return array;
}

@end
