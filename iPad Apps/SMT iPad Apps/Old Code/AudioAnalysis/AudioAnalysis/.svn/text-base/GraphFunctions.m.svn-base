//
//  GraphFunctions.m
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "GraphFunctions.h"

@implementation GraphFunctions

+(void) translateXValues:(float *)array arraySize:(int)numValues toDevice:(deviceType)typeDevice {
    float givenRange = [FloatFunctions range:array numElements:numValues];
//    printf("%f ",givenRange);
    float multiplier;
    if (typeDevice == device_ipad) {
        multiplier = givenRange/kIPadWidth;
    } else if (typeDevice == device_iphone){
        multiplier = givenRange/kIPhoneWidth;
    }
    for (int i = 0;i<numValues;i++) {
        array[i] = array[i]*multiplier;
    }
}

+(void) translateXIndices:(int *)array arraySize:(int)numValues toDevice:(deviceType)typeDevice {
    int givenRange = [IntFunctions range:array arraySize:numValues];
    //    printf("%f ",givenRange);
    float multiplier;
    if (typeDevice == device_ipad) {
        multiplier = (float)givenRange/kIPadWidth;
    } else if (typeDevice == device_iphone){
        multiplier = givenRange/kIPhoneWidth;
    }
    for (int i = 0;i<numValues;i++) {
        array[i] = (int)roundf(array[i]*multiplier);
    }
}

+(int) translateXIndex:(int)index givenRange:(int)range andDevice:(deviceType)typeDevice {
    
    double multiplier;
    if (typeDevice == device_ipad) {
        multiplier = kIPadWidth/(float)range;
    } else if (typeDevice == device_iphone) {
        multiplier = kIPhoneWidth/(float)range;
    }
    return index*multiplier;
    
}

+(void) convertSPLToDB:(float*)array arraySize:(int)numValues {
    for (int i = 0;i<numValues;i++) {
        array[i] = 20.0*log10f(array[i]);
    }
}

+(void) convertDBToSPL:(float*)array arraySize:(int) numValues {
    for(int i = 0;i < numValues ; i++) {
        array[i] = powf(10, array[i]/20.0);
    }
}

+(int)numUnique:(float*)array arraySize:(int)size{
    
    //size of array of unique indices
    int indicesSize = 0;
    //goes through values array and finds unique values
    for (int index = 0; index < size; index++) {
        if (index == size-1)
        {
            indicesSize++;
        }
        else if (array[index] != array[index + 1])
        {
            indicesSize++;
        }
    }
    return indicesSize;
}

+(void)uniqueIndices:(float*)array arraySize:(int)size indices:(int*)indexVals{
    //placeholder array to store values and have extra zeros
    int placeholderIndices[size];
    //size of array of unique indices
    int indicesSize = 0;
    //goes through values array and finds unique values
    for (int index = 0; index < size; index++) {
        if (index == size-1)
        {
            placeholderIndices[indicesSize] = index;
            indicesSize++;
        }
        else if (array[index] != array[index + 1])
        {
            placeholderIndices[indicesSize] = index;
            indicesSize++;
        }
    }
    for (int index = 0; index < indicesSize; index++) {
        indexVals[index] = placeholderIndices[index];
    }
}




@end
