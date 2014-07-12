//
//  ViewController.h
//  WavesAndSound
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioOutput.h"
#import "EnvelopeViewController.h"
#import "DrawingViewController.h"
#import "OBSlider.h"
#import "DrawView.h"
#import "MathFunctions.h"
#import "SimpleFFT.h"
#import "AudioFunctions.h"

@interface ViewController : UIViewController <AudioOutputDelegate, DrawViewDelegate> {
    
    AudioOutput *audioOut;
    int numSliders;
    double theta;
    NSMutableArray *ampArray;
    IBOutlet OBSlider *freqSlider;
    IBOutlet UILabel *freqLabel;
    float baseFrequency;
    float *waveForm;
    float *freqValues;
    IBOutlet DrawView *waveDraw;
    float* sampleIndices;
    SimpleFFT *fft;
    float *fftAudio;
    float *fftMag;
    float *fftPhase;
    int counter;
    int fftLowerIndex;
    int fftUpperIndex;
    
    IBOutlet DrawView *fftView;
    
}

-(IBAction)sliderChanged:(id)sender;

-(IBAction)freqSliderChanged:(id)sender;

-(IBAction)resetWaveformPressed:(id)sender;

-(void) createNewSampleIndices;

-(void) getFFTBounds;

@end
