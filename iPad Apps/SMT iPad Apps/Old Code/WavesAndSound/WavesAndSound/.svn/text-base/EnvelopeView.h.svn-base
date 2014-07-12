//
//  EnvelopeView.h
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnvelopeView : UIView {
    
    float *pointValues;
    int *pointSet;
    float *fullValues;
    float *scaledValues;
    CGPoint previousLocation;
    int counter;
}

@property float *values;

-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex;

-(void) clearDrawing;

-(CGPoint) getPreviousSetPointFromIndex:(int)index;

-(CGPoint) getNextSetPointFromIndex:(int)index;

-(float) interpolateIndex:(int)index;

-(void) interpolateFullFrame;

-(float*) getWaveform;


@end