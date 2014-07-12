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

@end

@interface DrawView : UIView {
    
    float *pointValues;
    int *pointSet;
    float *fullValues;
    float *scaledValues;
    CGPoint previousLocation;
    int counter;
    id <DrawViewDelegate> delegate;
}

@property float *values;
@property id <DrawViewDelegate> delegate;

-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex;

-(void) clearDrawing;

-(CGPoint) getPreviousSetPointFromIndex:(int)index;

-(CGPoint) getNextSetPointFromIndex:(int)index;

-(float) interpolateIndex:(int)index;

-(void) interpolateFullFrame;

-(float*) getWaveform;

-(void) resetDrawing;

-(void) setWaveform:(float*)newValues arraySize:(int)size;

@end
