//
//  SpectrumView.m
//  CannonDriver
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpectrumView.h"
#import "MathFunctions.h"

@implementation SpectrumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        indexValues = (float*)calloc(self.frame.size.width, sizeof(float));
        pointValues = (float*)calloc(self.frame.size.width, sizeof(float));
        numPoints = self.frame.size.width;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


-(void) plotValues:(float *)array arraySize:(int)size {
    
    
   // [FloatFunctions peaks:array numElements:size];
    
    numPoints = size;
    [MatlabFunctions linspace:0 max:self.frame.size.width numElements:numPoints array:indexValues];
    for (int i = 0;i<numPoints;i++) {
        pointValues[i] = array[i];
    }
//    [FloatFunctions normalize:pointValues numElements:numPoints];
    for (int i = 0;i<numPoints;i++) {
        //pointValues[i] = -pointValues[i]*self.frame.size.height+self.frame.size.height;
        pointValues[i] = -pointValues[i]/2.0+self.frame.size.height;
//        printf("%f ",pointValues[i]);
    }
//    printf("\n\n");
    
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
//    NSLog(@"drawing");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGPoint prevPoint = CGPointMake(0, self.frame.size.height);
    CGContextSetAlpha(context, 0.0);//Shitty Add
    for (int i = 0;i<numPoints;i++) {
            CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
            CGContextAddLineToPoint(context,indexValues[i],pointValues[i]);
            prevPoint = CGPointMake(indexValues[i], pointValues[i]);
            CGContextStrokePath(context);
    }
    CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
    CGContextAddLineToPoint(context,self.frame.size.width ,self.frame.size.height);
    CGContextStrokePath(context);
}




@end
