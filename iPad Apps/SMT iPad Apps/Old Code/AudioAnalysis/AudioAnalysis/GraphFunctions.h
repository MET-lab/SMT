//
//  GraphFunctions.h
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphParameters.h"
#import "MathFunctions.h"

@interface GraphFunctions : NSObject

+(void) translateXValues:(float*)array arraySize:(int)numValues toDevice:(deviceType)typeDevice;

+(int) translateXIndex:(int)index givenRange:(int)range andDevice:(deviceType)typeDevice;

+(void) convertSPLToDB:(float*)array arraySize:(int)numValues;

+(void) convertDBToSPL:(float*)array arraySize:(int)numValues;

+(int)numUnique:(float*)array arraySize:(int)size;

+(void)uniqueIndices:(float*)array arraySize:(int)size indices:(int*)indexVals;

@end
