//
//  ViewController.h
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/4/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioOutput.h"
#import "DrawView.h"
#import "SpectrumView.h"
#import "MathFunctions.h"
#import "SimpleFFT.h"
#import "AudioFunctions.h"
#import "AudioParameters.h"
#import "OBSlider.h"
#import "TimeEnvelopeViewController.h"
#import "FrequencyEnvelopeViewController.h"

@interface ViewController : UIViewController <AudioOutputDelegate, DrawViewDelegate, UIPopoverControllerDelegate, TimeEnvelopeDelegate, FrequencyEnvelopeDelegate> {
    
    float *audioBuffer;
    NSMutableArray *sliderAmplitudes;
    NSMutableArray *sliders;
    NSMutableArray *harmonicLabels;
    IBOutlet OBSlider *freqSlider;
    IBOutlet UILabel *freqLabel;
    
    IBOutlet DrawView *audioDraw;
    IBOutlet SpectrumView *spectrumDraw;
    
    int numSliders;
    float baseFrequency;
    
    AudioOutput *audioOut;
    float bufferIndex;
    int bufferLength;
    int timeEnvelopeIndex;
    
    
    int envelopeIndex;
    
    float *drawnWaveform;
    float *timeEnvelope;
    int numSeconds;
    float indexStepSize;
    
    int graphWidth;
    int graphHeight;
    float *drawBuffer;
    
    float theta;
    float thetaIncrement;
    
    SimpleFFT *fft;
    float *fftPhase;
    float *fftMag;
    float *fftBuffer;
    
    int counter;
    BOOL isRunning;
    BOOL fftCalled;
    
    TimeEnvelopeViewController *timeEnvelopeController;
    UIPopoverController *timePopover;
    float *drawnTimeEnvelope;
    
    FrequencyEnvelopeViewController *frequencyEnvelopeController;
    UIPopoverController *frequencyPopover;
    float *drawnFrequencyEnvelope;
    
    IBOutlet UIButton *timeEnvelopeButton;
    IBOutlet UIButton *freqEnvelopeButton;
    
    float minFrequency;
    float maxFrequency;
    
    float minPlottedFreq;
    float maxPlottedFreq;
    
    float *specBuffer;
    
}

-(void) updateSpectrumLabels;

-(IBAction)freqSliderChanged:(id)sender;

-(IBAction)harmonicSliderChanged:(id)sender;

-(IBAction)playPressed:(id)sender;

-(IBAction)stopPressed:(id)sender;

-(void) updateAudioWaveform;

-(void) drawFFT;

-(IBAction)timeEnvelopePressed:(id)sender;

-(IBAction)frequencyEnvelopePressed:(id)sender;

-(void) processFrequencyEnvelope;

-(void) setSliderValues:(NSMutableArray*)sliderValues;

@end
