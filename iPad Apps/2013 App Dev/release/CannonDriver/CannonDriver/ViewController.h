//
//  ViewController.h
//  CannonDriver
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioOutput.h"
#import "DrawView.h"
#import "SpectrumView.h"
#import "OBSlider.h"
#import "AudioParameters.h"
#import "MathFunctions.h"
#import "SimpleFFT.h"
@interface ViewController : UIViewController <AudioOutputDelegate> {
    
    
    AudioOutput *audioOut;
    IBOutlet DrawView *audioDraw;
    IBOutlet SpectrumView *spectrumDraw;
    IBOutlet OBSlider *freqSlider;
    IBOutlet UILabel *freqLabel;
    float baseFrequency;
    IBOutlet UISegmentedControl *waveSelector;
    float *audioBuffer;
    int waveType;
    float theta;
    float *sampleTimes;
    float *waveDrawValues;
    SimpleFFT *fft;
    int bufferLength;
    float *fftPhase;
    float *fftMag;
    int fftStopIndex;
    int numReplicas;
    float *fftValues;
    BOOL isRunning;
    int counter;
    BOOL fftCalled;
    BOOL audioDrawCalled;
    
    IBOutlet UIButton* playButton;
}

-(IBAction)waveTypeChanged:(id)sender;

-(IBAction)freqSliderChanged:(id)sender;

-(IBAction)stopPressed:(id)sender;

-(IBAction)playPressed:(id)sender;

-(void) drawNoise;

-(void) drawSineWave;

-(void) drawFFT;

@end
