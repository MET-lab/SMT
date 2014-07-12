//
//  ViewController.h
//  SoundAndWaves
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBSlider.h"
#import "DrawView.h"
#import "SpectrumView.h"
#import "AudioOutput.h"
#import "AudioParameters.h"
#import "MathFunctions.h"
#import "SimpleFFT.h"

@interface ViewController : UIViewController <AudioOutputDelegate,DrawViewDelegate> {
    
    IBOutlet OBSlider *freqSlider;
    IBOutlet DrawView *audioDraw;
    IBOutlet SpectrumView *spectrumDraw;
    IBOutlet UILabel *freqLabel;
    
    float *audioBuffer;
    float baseFrequency;
    float *drawnWaveform;
    
    int graphWidth;
    int graphHeight;
    int bufferLength;
    
    float indexStepSize;
    float bufferIndex;
    AudioOutput *audioOut;
    
    SimpleFFT *fft;
    float *fftPhase;
    float *fftMag;
    
    BOOL isRunning;
    float theta;
    float thetaIncrement;
    
    int waveType;
    IBOutlet UISegmentedControl *waveControl;
    
    UISlider *ampSlider;
    UILabel *ampLabel;
    float amplitude;
    
    int drawCount;
    
    
}

-(IBAction)freqSliderChanged:(id)sender;

-(IBAction)playPressed:(id)sender;

-(IBAction)stopPressed:(id)sender;

-(void) ampSliderChanged;

-(void) drawFFT;

-(void) notRunningFFT;

-(IBAction)waveTypeChanged:(id)sender;

-(void) drawWaveType;

@end
