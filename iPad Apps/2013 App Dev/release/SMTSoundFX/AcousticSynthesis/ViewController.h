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
#import "SpectrumPoint.h"

@interface ViewController : UIViewController <AudioOutputDelegate, DrawViewDelegate, UIPopoverControllerDelegate, TimeEnvelopeDelegate, FrequencyEnvelopeDelegate> {
    
    IBOutlet DrawView        *audioDraw;        // Time and frequency domain plots
    IBOutlet SpectrumView *spectrumDraw;        //
    
    int minIndex, maxIndex;                     // Minimum and maximum frequency indices for spectrum plots
    int specPlotLength;                         // Number of points on the spectrum plots
    
    int graphWidth;                             // Height and width of the time domain plot
    int graphHeight;                            //
    
    int *thetaZero;                             // Stores first three locations in each buffer where theta goes from
                                                //  2*pi to zero. Used for plotting only three cycles of the waveform
    
    bool scheduleUpdate;                        // Set high when parameter values change, updates the plotss
    
    float clippingAmplitude;                    // Hard-clipping distortion threshold
    
    IBOutlet UISlider *masterVolSlider;         // Boost or attenuate the overall signal amplitude
    float masterVol;

    float *drawBuffer;                          // Buffer to plot audio
    
    UIPinchGestureRecognizer *distCutoffPinch;  // Pinch time domain plot to change hard clipping cutoff
    float mCurrentScale, mLastScale;            // Scale values for the pinch gesture
    
    UISwipeGestureRecognizer *filterDrawSwipe;  // Three-finger swipe on spectrum plot to draw filter
    UISwipeGestureRecognizer *exitFilterDrawSwipe;
    CGPoint previousSwipeLocation;
    
    IBOutlet UIButton *filterDrawButton;        //  Enables filter drawing on spectrum plot
    bool filterDrawEnabled;                     //
    
    bool filterEnabled;
    
//    FrequencyEnvelopeViewController *filterDrawController;
//    UIPopoverController *filterDrawPopover;
    float *drawnFilter;
    
    EnvelopeView *filterDrawView;               
    
    UIPanGestureRecognizer *filterShiftPan;     // Shift the filter right or left by dragging with two fingers
    float previousTranslation;              
    
    float *filterPlotBuffer;                    // Buffer for plotting the drawn filter
    
    NSMutableArray *filterAmpsAtHarmonics;      // "Filter" amplitudes at the generated harmonics
    
    int numHarmonics;                           // Number of harmonics for additive synthesis
    
    float *dryBuffer;                           // Audio before distortion
    float *dryFftPhase;                         //
    float *dryFftMag;                           //
    float *dryFftBuffer;                        //
    float *drySpecBuffer;                       //
    
    NSMutableArray* spectrumHandles;            // Harmonic amplitude sliders
    IBOutlet UIImageView* specBackgroundView;   
    NSTimer* aTimer;
    
    float *audioBuffer;
    NSMutableArray *sliderAmplitudes;
    NSMutableArray *sliders;
    NSMutableArray *harmonicLabels;
    IBOutlet OBSlider *freqSlider;
    IBOutlet UILabel *freqLabel;    
    
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
    
//    IBOutlet UIButton *timeEnvelopeButton;
//    IBOutlet UIButton *freqEnvelopeButton;
    
    float minFrequency;
    float maxFrequency;
    
    float minPlottedFreq;
    float maxPlottedFreq;
    
    float *specBuffer;
    
    bool check;
    IBOutlet UIButton* playButton;
    
}

-(void) updateSpectrumLabels;

-(IBAction) masterVolumeChanged:(UISlider*)sender;

/* Pinch to change hard clipping threshold */
-(IBAction) distCutoffPinch:(UIPinchGestureRecognizer *)recognizer;      

/* Allow drawing of filter curve on spectrum plot */
-(IBAction) filterDrawButtonPressed:(id)sender;

/* Three-finger swipe down to draw a filter */
-(IBAction) drawFilterSwipe:(UISwipeGestureRecognizer*)recognizer;

/* Shift the drawn filter right/left */
-(IBAction) filterSlider:(id)sender;

-(IBAction) freqSliderChanged:(id)sender;

-(IBAction) harmonicSliderChanged:(id)sender;

-(IBAction) playPressed:(id)sender;

-(IBAction) stopPressed:(id)sender;

-(void) updateAudioWaveform;

-(void) drawFFT;

-(IBAction) timeEnvelopePressed:(id)sender;

-(IBAction) frequencyEnvelopePressed:(id)sender;

-(void) processFrequencyEnvelope;

-(void) setSliderValues:(NSMutableArray*)sliderValues;

@end
