//
//  DrawView.m
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import <math.h>

@implementation DrawView
@synthesize values, delegate, drawEnabled;


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
//    if (self) {
        drawEnabled = YES;
        pointValues = (float*)calloc(self.frame.size.width, sizeof(float));
        fullValues = (float*)calloc(self.frame.size.width, sizeof(float));
        scaledValues = (float*)calloc(self.frame.size.width, sizeof(float));
        //envelopeValues = (float*)calloc(self.frame.size.width, sizeof(float)) ; // Added for envelope view
        pointSet = (int*)calloc(self.frame.size.width, sizeof(int));
        counter = 0;
//    }
    pointValues[0] = self.frame.size.height/2.0;
    pointSet[0] = 1;
    
    for (int i = 1;i<self.frame.size.width-1;i++) {
        pointValues[i] = -sin(2*M_PI*i/self.frame.size.width)*self.frame.size.height/2.0+self.frame.size.height/2.0;
        pointSet[i] = 1;
    }
    pointValues[(int)self.frame.size.width-1] = self.frame.size.height/2;
    pointSet[(int)self.frame.size.width-1] = 1;
    [self setNeedsDisplay];
    return self;
}

-(void) resetDrawing {
    pointValues[0] = self.frame.size.height/2.0;
    pointSet[0] = 1;
    
    for (int i = 1;i<self.frame.size.width-1;i++) {
        pointValues[i] = -sin(2*M_PI*i/self.frame.size.width)*self.frame.size.height/2.0+self.frame.size.height/2.0;
        pointSet[i] = 1;
    }
    pointValues[(int)self.frame.size.width-1] = self.frame.size.height/2;
    pointSet[(int)self.frame.size.width-1] = 1;
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (drawEnabled){
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        previousLocation = touchLocation;
    }
    
    if ([delegate respondsToSelector:@selector(drawingStarted)]) {
        [delegate drawingStarted];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (drawEnabled) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
//        if (touchLocation.x < 0 || touchLocation.x >= self.frame.size.width ||
//            touchLocation.y < 0 || touchLocation.y >= self.frame.size.height) {
//            return;
//        }
        
        if (touchLocation.x >= 0 && touchLocation.x <= self.frame.size.width) {
            if (touchLocation.y >= self.frame.size.height) {
                pointValues[(int)touchLocation.x] = self.frame.size.height;
            } else if (touchLocation.y <= 0) {
                pointValues[(int)touchLocation.x] = 0;
            } else {
                pointValues[(int)touchLocation.x] = touchLocation.y;
            }
            pointSet[(int)touchLocation.x] = 1;
        }
        
        [self resetPointsBetween:previousLocation.x andEndIndex:touchLocation.x];
//        pointSet[(int)touchLocation.x] = 1;
//        pointValues[(int)touchLocation.x] = touchLocation.y;
        
        [self setNeedsDisplay];
        previousLocation = touchLocation;
    }
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
    if (drawEnabled) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        previousLocation = touchLocation;
    }
    
    if ([delegate respondsToSelector:@selector(drawingEnded)]) {
        [delegate drawingEnded];
    }
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

//    if (counter%1==0) {
    [self interpolateFullFrame];
//    }
//    counter++;
    if ([delegate respondsToSelector:@selector(drawViewChanged)]) {
        [delegate drawViewChanged];
    }
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
    pointValues[0] = self.frame.size.height/2;
    for (int i = 1;i<self.frame.size.width-1;i++) {
        pointSet[i] = 0;
        pointValues[i] = 0;
    }
    pointSet[(int)self.frame.size.width-1] = 1;
    pointSet[(int)self.frame.size.width-1] = self.frame.size.height/2;
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
        scaledValues[i] = (self.frame.size.height/2.0-fullValues[i])/(self.frame.size.height/2.0);
    }
}

-(float*) getWaveform {
    return scaledValues;
}

-(void) setWaveform:(float*)newValues arraySize:(int)size needsDisplay:(BOOL)needsDisplay{
    
    for (int i = 0;i<size;i++) {
        pointValues[i] = newValues[i];
        pointSet[i] = 1;
    }
    if (needsDisplay)
        [self setNeedsDisplay];
}

-(float*) getEnvelope {
    return pointValues ;
}

-(void) setAvgEnvelopeForArraySize:(int)size withSampleWidth:(int)sampleWidth needsDisplay:(BOOL)needsDisplay {
    
    for (int i = 0; i < size; i++ ) {
        float sum = 0.0 ;
        if ( i < (sampleWidth / 2) ) {
            for (int j = i; j < i + sampleWidth ; j++ )
                sum += -fabs(pointValues[j] - (self.frame.size.height / 2.0)) ;
        }
        else if ( i > size - sampleWidth ) {
            for (int j = i; j > i - sampleWidth ; j-- )
                sum += -fabs(pointValues[j] - (self.frame.size.height / 2.0)) ;
        }
        else {
            for (int j = i - (sampleWidth / 2); j < i + ((sampleWidth + 0.5) / 2) ; j++ )
                sum += -fabs(pointValues[j] - (self.frame.size.height / 2.0)) ;
        }
        
        float average = sum / (float)sampleWidth ;
        if (i % 2 == 0 )
            average = -average ;
        pointValues[i] = average + (self.frame.size.height / 2.0);
        //printf("pointValue %f", pointValues[i]) ;
        
        if (needsDisplay)
            [self setNeedsDisplay];
    }
    
}

// Another possible algorithm for creating the envelope, but currently unused
-(void) setPeakEnvelopeForArraySize:(int)size needsDisplay:(BOOL)needsDisplay {
    
    int const SAMPLE_WIDTH = 25 ;
    
    for (int i = 0; i < size; i++ ) {
        float peak = (self.frame.size.height / 2.0) ;
        if ( i < (SAMPLE_WIDTH / 2) ) {
            for (int j = i; j < i + SAMPLE_WIDTH ; j++ ) {
                peak = fabs(pointValues[j] - (self.frame.size.height / 2.0));
                if (peak < fabs(pointValues[j+1] - (self.frame.size.height / 2.0)))
                    peak = fabs(pointValues[j+1] - (self.frame.size.height / 2.0)) ;
            }
        }
        else if ( i > size - SAMPLE_WIDTH ) {
            for (int j = i; j > i - SAMPLE_WIDTH ; j-- ) {
                peak = fabs(pointValues[j] - (self.frame.size.height / 2.0));
                if (peak < fabs(pointValues[j+1] - (self.frame.size.height / 2.0)))
                    peak = fabs(pointValues[j+1] - (self.frame.size.height / 2.0)) ;
            }
        }
        else {
            for (int j = i - (SAMPLE_WIDTH / 2); j < i + ((SAMPLE_WIDTH + 0.5) / 2) ; j++ ) {
                peak = fabs(pointValues[j] - (self.frame.size.height / 2.0));
                if (peak < fabs(pointValues[j+1] - (self.frame.size.height / 2.0)))
                    peak = fabs(pointValues[j+1] - (self.frame.size.height / 2.0)) ;
            }
        }
        
        if ( i % 2 == 0 )
            peak = -peak ;
        pointValues[i] = peak + (self.frame.size.height / 2.0) ;
        
        if (needsDisplay)
            [self setNeedsDisplay];
    }
    
}


@end
