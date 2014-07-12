//
//  GraphView.m
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize yStartPoint,gain;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        device = device_ipad;
        [self setBackgroundColor:[UIColor whiteColor]];
        numPoints = 0;
        frameNumber = 0;
        gain = 1000;
    }
    NSLog(@"running");
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        device = device_ipad;
        [self setBackgroundColor:[UIColor whiteColor]];
        numPoints = 0;
        frameNumber = 0;
        gain = 1000;
    }
    return self;
}

-(void) updatePlot {
    [self setNeedsDisplay];
}

-(void) plotY:(float *)yVals withX:(float *)xVals arraySize:(int)arrSize {
    
    [GraphFunctions translateXValues:xVals arraySize:arrSize toDevice:device];
    [FloatFunctions round:xVals numElements:arrSize];
    int numUnique = [GraphFunctions numUnique:xVals arraySize:arrSize];
    int *uniqueXIndices = (int*)malloc(sizeof(int)*numUnique);
    [GraphFunctions uniqueIndices:xVals arraySize:arrSize indices:uniqueXIndices];
    
    
    xIndices = uniqueXIndices;
    yValues = yVals;
    numPoints = numUnique;
    
    frameNumber++;
//    if (frameNumber==5) {
//        for (int i = 0;i<numUnique;i++) {
//            printf("%i ",xIndices[i]);
//        }
//    }
    
    [self updatePlot];
}

-(id) init {
    self  = [super init];
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}


-(void)drawInContext:(CGContextRef)context {
    //    NSLog(@"should be plotting");
//    CGContextSetRGBStrokeColor(context,1,1,1,1);
    @try {
        int oldX;
        int newX;
        int indexMax = [IntFunctions max:xIndices arraySize:numPoints];
        for (int i = 1;i<numPoints;i++) {
            CGContextSetLineWidth(context, 1.0);
            
            oldX = [GraphFunctions translateXIndex:xIndices[i-1] givenRange:indexMax andDevice:device];
            newX = [GraphFunctions translateXIndex:xIndices[i] givenRange:indexMax andDevice:device];
            CGContextMoveToPoint(context,oldX,yStartPoint-gain*yValues[xIndices[i-1]]);
            CGContextAddLineToPoint(context,newX,yStartPoint-gain*yValues[xIndices[i]]);
            CGContextStrokePath(context);
        }
    }
    @catch (NSException *exception) {}
    
//    free(xValues);
//    free(yValues);
}


@end
