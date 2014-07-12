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
    
//    NSMutableArray *plotBuffer;         /* N x M array of float values to be plotted,
//                                           where each row is a separate plot. */
//    NSMutableArray *plotColors;
//    int nWaveforms;
    
    float *waveform;
    float upperCutoff;
    float lowerCutoff;
    
    float yLim;                         // Plot displays [-yLim, yLim]
    float pixelQuant;                   // Amplitude units per vertical pixel
    
//    NSMutableArray *scaledBuffer;       /* N x M array of float values to be plotted,
//                                           converted to pixels, scaled by yLim */
    
//    float *mainPlot;
//    float *auxPlot;
//    
//    int *mainSet;                        // Do we need this?
//    int *auxSet;
    
//    float *fullValues;
//    float *scaledValues;
//    CGPoint previousLocation;
//    int counter;
//    id <DrawViewDelegate> delegate;
//    BOOL drawEnabled;
    
@public
    
    CGPoint upperLeft, lowerRight;      // Bounds of the object
    CGSize frameSize;                   // Size of the object
}

@property CGPoint upperLeft;
@property CGPoint loerRight;
//@property float *values;
@property id <DrawViewDelegate> delegate;
//@property BOOL drawEnabled;

/* Original */
//-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex;
//
//-(void) clearDrawing;
//
//-(CGPoint) getPreviousSetPointFromIndex:(int)index;
//
//-(CGPoint) getNextSetPointFromIndex:(int)index;
//
//-(float) interpolateIndex:(int)index;
//
//-(void) interpolateFullFrame;
//
//-(float*) getWaveform;
//
//-(void) resetDrawing;
//
//-(void) setWaveform:(float*)newValues arraySize:(int)size;
//
//-(void) setAuxPlot:(float*)newValues arraySize:(int)size;

//-(void) setWaveforms:(float*)pMainPlot aux:(float*)pAuxPlot arraySize:(int)size;

/* NSMutableArray version */
//-(void) addWaveform:(float*)pWaveform length:(int)pLength color:(UIColor*)pColor;
//
//-(void) setWaveform:(float*)pWaveform length:(int)pLength index:(int)pIdx;

//-(void) setYlim:(double)pYlim;


/* float array version */
-(id) initWithCoder:(NSCoder *)aDecoder;

-(void) drawRect:(CGRect)rect;

-(void) setWaveform:(float *)pWaveform;

-(void) setDistCutoff:(float *)pCutoff;

@end
