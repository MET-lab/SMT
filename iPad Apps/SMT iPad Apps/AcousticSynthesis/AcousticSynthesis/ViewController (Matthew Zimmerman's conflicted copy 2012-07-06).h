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

@interface ViewController : UIViewController {
    
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
    
}

-(IBAction)freqSliderChanged:(id)sender;

-(IBAction)harmonicSliderChanged:(id)sender;

-(IBAction)playPressed:(id)sender;

-(IBAction)stopPressed:(id)sender;

-(IBAction)resetPressed:(id)sender;


@end
