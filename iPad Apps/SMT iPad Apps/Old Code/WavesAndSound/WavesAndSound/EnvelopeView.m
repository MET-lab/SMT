//
//  EnvelopeView.m
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvelopeView.h"

@implementation EnvelopeView
@synthesize values;

const int yOffset = 20;

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
        pointValues = (float*)calloc(self.frame.size.width, sizeof(float));
        fullValues = (float*)calloc(self.frame.size.width, sizeof(float));
        scaledValues = (float*)calloc(self.frame.size.width, sizeof(float));
        pointSet = (int*)calloc(self.frame.size.width, sizeof(int));
        counter = 0;
    }
    pointValues[0] = self.frame.size.height-yOffset;
    pointSet[0] = 1;
    pointValues[(int)self.frame.size.width-1] = self.frame.size.height-yOffset;
    pointSet[(int)self.frame.size.width-1] = 1;
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    previousLocation = touchLocation;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (touchLocation.x <= 0 || touchLocation.x >= self.frame.size.width ||
        touchLocation.y <= 0 || touchLocation.y >= self.frame.size.height-yOffset) {
        return;
    }
    [self resetPointsBetween:previousLocation.x andEndIndex:touchLocation.x];
    pointSet[(int)touchLocation.x] = 1;
    pointValues[(int)touchLocation.x] = touchLocation.y;
    
    [self setNeedsDisplay];
    previousLocation = touchLocation;
}

-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex {
    int temp;
    if (endIndex<startIndex) {
        temp = startIndex;
        startIndex = endIndex;
        endIndex = temp;
    }
    for (int i = startIndex+1;i<endIndex;i++) {
        if (pointSet[i] == 1) {
            pointSet[i] = 0;
            pointValues[i] = 0;
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    previousLocation = touchLocation;
}

-(CGPoint) getPreviousSetPointFromIndex:(int)index {
    
    CGPoint point = CGPointMake(index, pointValues[index]);
    BOOL done = NO;
    int i = index;
    while (!done) {
        if (i<=0) {
            point = CGPointMake(0, pointValues[0]);
            done = YES;
        } else {
            if (pointSet[i]==1) {
                point = CGPointMake(i, pointValues[i]);
                done = YES;
            }
        }
        i--;
    }
    return point;
}

-(CGPoint) getNextSetPointFromIndex:(int)index {
    CGPoint point = CGPointMake(index, pointValues[index]);
    BOOL done = NO;
    int i = index;
    while (!done) {
        if (i>=self.frame.size.width) {
            point = CGPointMake(self.frame.size.width-1, pointValues[(int)self.frame.size.width-1]);
            done = YES;
        } else {
            if (pointSet[i]==1) {
                point = CGPointMake(i, pointValues[i]);
                done = YES;
            }
        }
        i++;
    }
    return point;
}

-(void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGPoint prevPoint = CGPointMake(0, self.frame.size.height/2);
    for (int i = 0;i<=self.frame.size.width;i++) {
        if (pointSet[i] == 1) {
            CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
            CGContextAddLineToPoint(context,i,pointValues[i]);
            prevPoint = CGPointMake(i, pointValues[i]);
            CGContextStrokePath(context);
        }
    }
    CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
    CGContextAddLineToPoint(context,self.frame.size.width ,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    if (counter%2==0) {
        [self interpolateFullFrame];
    }
    counter++;
}

-(float) interpolateIndex:(int)index {
    CGPoint last = [self getPreviousSetPointFromIndex:index];
    CGPoint next = [self getNextSetPointFromIndex:index];
    float result = self.frame.size.height/2;
    if (next.x-last.x != 0) {
        result = (((index-last.x)*(next.y-last.y))/(next.x-last.x))+last.y;
    }
    return result;
}

-(void) clearDrawing {
    pointSet[0] = 1;
    pointValues[0] = self.frame.size.height - yOffset;
    for (int i = 1;i<self.frame.size.width-1;i++) {
        pointSet[i] = 0;
        pointValues[i] = 0;
    }
    pointSet[(int)self.frame.size.width-1] = 1;
    pointSet[(int)self.frame.size.width-1] = self.frame.size.height-yOffset;
    [self setNeedsDisplay];
    counter = 0;
}

-(void) interpolateFullFrame {
    float value;
    for (int i = 0;i<self.frame.size.width;i++) {
        if (pointSet[i]==1) {
            fullValues[i] = pointValues[i];
        } else {
            value = [self interpolateIndex:i];
            fullValues[i] = value;
        }
        scaledValues[i] = (self.frame.size.height-fullValues[i])/(self.frame.size.height);
    }
}

-(float*) getWaveform {
    return scaledValues;
}
@end