//
//  DrawView.h
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawViewDelegate <NSObject>

@optional

-(void) drawViewChanged;

-(void) drawingStarted;

-(void) drawingEnded;

@end

@interface DrawView : UIView {
    
    float *pointValues;
    int *pointSet;
    float *fullValues;
    float *scaledValues;
    //float *envelopeValues ; // Added to create envelope view
    CGPoint previousLocation;
    int counter;
    id <DrawViewDelegate> delegate;
    BOOL drawEnabled;
}

@property float *values;
@property id <DrawViewDelegate> delegate;
@property BOOL drawEnabled;

-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex;

-(void) clearDrawing;

-(CGPoint) getPreviousSetPointFromIndex:(int)index;

-(CGPoint) getNextSetPointFromIndex:(int)index;

-(float) interpolateIndex:(int)index;

-(void) interpolateFullFrame;

-(float*) getWaveform;

-(void) resetDrawing;

-(void) setWaveform:(float*)newValues arraySize:(int)size needsDisplay:(BOOL)needsDisplay;

// Begin added functions for drawing envelope view

-(float*) getEnvelope;

//-(void) setAvgEnvelopeForArraySize:(int)size needsDisplay:(BOOL)needsDisplay;

-(void) setAvgEnvelopeForArraySize:(int)size withSampleWidth:(int)sampleWidth needsDisplay:(bool)needsDisplay;

-(void) setPeakEnvelopeForArraySize:(int)size needsDisplay:(BOOL)needsDisplay;

@end
