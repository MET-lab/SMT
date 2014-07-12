//
//  GraphView.h
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphParameters.h"
#import "MathFunctions.h"
#import "GraphFunctions.h"

@interface GraphView : UIView {
    
    int *xIndices;
    int *xValues;
    float *yValues;
    int numPoints;
    deviceType device;
    float yStartPoint;
    int frameNumber;
}

@property float yStartPoint;
@property float gain;

-(void) updatePlot;

-(void) plotY:(float*)yVals withX:(float*)xVals arraySize:(int)arrSize;

-(void) drawInContext:(CGContextRef)context;


@end
