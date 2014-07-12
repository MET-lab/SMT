//
//  SpectrumView.h
//  CannonDriver
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface SpectrumPoint : UIView
//{
//    float gainVal;
//    float xPos;
//    float yPos;
//    int idNum;
//}
//-(void)setAmplitude:(float)amp;
//-(void)setIdNum:(int)idIn;
//-(float) getGainVal;
//
//@end


@interface SpectrumView : UIView {
    
//    NSMutableArray *plotBuffer;         /* N x M array of float values to be plotted,
//                                         where each row is a separate plot. */
//    NSMutableArray *plotColors;
//    int nWaveforms;
    
    NSMutableArray *harmonicSliders;    
    
    float *freqz;                       // Linearly-space frequency indices
    float *drySpec;
    float *wetSpec;
    float *filter;    
    
    int plotLength;                     // Number of points in the spectrum plot
    
    float yLim;                         // Plot displays [-yLim, yLim]
    float pixelQuant;                   // Amplitude units per vertical pixel
    
//    float *pointValues;
    
@public

CGPoint upperLeft, lowerRight;      // Bounds of the object
CGSize frameSize;                   // Size of the object
    
bool filterDrawEnabled;
}

/* Zimmerman */
//-(void) plotValues:(float*)array arraySize:(int)size;

/* NSMutableArray version */
//-(void) addWaveform:(float*)pWaveform length:(int)pLength color:(UIColor*)pColor;
//
//-(void) setWaveform:(float*)pWaveform length:(int)pLength index:(int)pIdx;

/* float array version */
-(id) initWithCoder:(NSCoder *)aDecoder;

-(void) drawRect:(CGRect)rect;

-(void) setDrySpec:(float *)pWaveform length:(int)pLength;

-(void) setWetSpec:(float *)pCutoff length:(int)pLength;

-(void) setFilterCurve:(float *)pFilterCurve length:(int)pLength;

-(void) setFreqzLinspace:(int)pLength;

@end



