//
//  ViewController.m
//  CannonDriver
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#define kFFTSize 1024
#define kUseDB 0
#define kMaxFrequency 1500
@interface ViewController ()

@end

@implementation ViewController

float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isRunning = NO;
    baseFrequency = 440.0;
    [freqSlider setValue:baseFrequency];
    waveType = 0;
    theta = 0;
    fftCalled = NO;
    audioDrawCalled = NO;
    bufferLength = 1024;
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    audioOut = [[AudioOutput alloc] initWithDelegate:self];
    sampleTimes =  (float*)malloc(sizeof(float)*audioDraw.frame.size.width);
    [MatlabFunctions linspace:0 max:0.05 numElements:audioDraw.frame.size.width array:sampleTimes];
    waveDrawValues = (float*)calloc(audioDraw.frame.size.width,sizeof(float));
    fftPhase = (float*)calloc(kFFTSize, sizeof(float));
    fftMag = (float*)calloc(kFFTSize, sizeof(float));
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftStopIndex = (int)ceil(kMaxFrequency/((kOutputSampleRate/2)/(kFFTSize/2)));
    fftValues = (float*)calloc(fftStopIndex+1,sizeof(float));
    [self drawSineWave];
    [self drawFFT];
    [audioDraw setDrawEnabled:NO];
    numReplicas = 3;
    [audioDraw setBackgroundColor:[UIColor clearColor]];
    [spectrumDraw setBackgroundColor:[UIColor clearColor]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    

    if (waveType == 0) {
        float theta_increment = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
        for (int i = 0;i<bufferSize;i++) {
            theta += theta_increment;
            buffer[i] = sin(theta);
            if (theta >= 2*M_PI) {
                theta -= 2*M_PI;
            }
        }
        
    } else if (waveType == 1) {
        for (int i = 0;i<bufferSize;i++) {
            buffer[i] = randomFloat(-1, 1);
        }
        
    }
    free(audioBuffer);
    audioBuffer = malloc(sizeof(float)*bufferSize);
    for (int i = 0;i<bufferSize;i++) {
        audioBuffer[i] = buffer[i];
    }
    bufferLength = bufferSize;
    if (waveType == 0) {
        [self performSelectorOnMainThread:@selector(drawSineWave) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(drawNoise) withObject:nil waitUntilDone:NO];
    }
} 

-(IBAction)waveTypeChanged:(id)sender {
    
    audioDrawCalled = NO;
    fftCalled = NO;
    waveType = [waveSelector selectedSegmentIndex];
    if (waveType == 0) {
        [self drawSineWave];
        [freqSlider setUserInteractionEnabled:YES];
    } else if (waveType == 1) {
        [self drawNoise];
        [freqSlider setUserInteractionEnabled:NO];
    }
}

-(IBAction)freqSliderChanged:(id)sender {
    OBSlider *slider = (OBSlider*)sender;
    baseFrequency = [slider value];
    freqLabel.text = [NSString stringWithFormat:@"%.1f",baseFrequency];
    if (waveType == 0){
    fftCalled = NO;
    audioDrawCalled = NO;
    }
    if (waveType == 0) {
        [self drawSineWave];
    }
    
}

-(IBAction)stopPressed:(id)sender {
    [audioOut stopOutput];
    isRunning = NO;
    
}

-(IBAction)playPressed:(id)sender {
    isRunning = YES;
    [audioOut startOutput];
}

-(void) drawNoise {
    if (!audioDrawCalled) {
        for (int i = 0;i<audioDraw.frame.size.width;i++) {
            waveDrawValues[i] = randomFloat(20,audioDraw.frame.size.height-20);
        }
        [audioDraw setWaveform:waveDrawValues arraySize:audioDraw.frame.size.width];
        [self drawFFT];
        audioDrawCalled = YES;
    }
}

-(void) drawFFT {
    
    
    
    if (!isRunning) {
        free(audioBuffer);
        audioBuffer = malloc(sizeof(float)*bufferLength);
        if (waveType == 0) {
            float theta_increment = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
            for (int i = 0;i<bufferLength;i++) {
                theta += theta_increment;
                audioBuffer[i] = sin(theta);
                if (theta >= 2*M_PI) {
                    theta -= 2*M_PI;
                }
            }
            
        } else if (waveType == 1) {
            for (int i = 0;i<bufferLength;i++) {
                audioBuffer[i] = randomFloat(-1, 1);
            }
        }
        theta = 0;
        fftCalled = NO;
    }
    
    if (!fftCalled) {
        
        float *tempBuffer = (float*)malloc(sizeof(float)*bufferLength*2);
        for (int i = 0;i<bufferLength;i++) {
            tempBuffer[i] = audioBuffer[i];
            tempBuffer[i+1] = 0;
        }
        [fft forwardWithStart:0 withBuffer:tempBuffer magnitude:fftMag phase:fftPhase useWinsow:NO];
        free(tempBuffer);
        if (!isRunning) {
            counter =5;
        }
        
        if (kUseDB) {
            if (counter == 5) {
                for (int i = 0;i<=fftStopIndex;i++) {
                    
                    fftValues[i] = 20*log10f(fftMag[i]);
                }
                counter = 0;
            }
            counter++;
        } else {
            if (counter == 5) {
                for (int i = 0;i<=fftStopIndex;i++) {
                    
                    fftValues[i] = fftMag[i];
                }
                counter = 0;
            }
            counter++;
        }
        
        fftCalled = YES;
        [spectrumDraw plotValues:fftValues arraySize:(fftStopIndex+1)];
    }
}

-(void) drawSineWave {
    
    
    if (!audioDrawCalled) {
        for (int i = 0;i<audioDraw.frame.size.width;i++) {
            waveDrawValues[i] = sin(2*M_PI*sampleTimes[i]*baseFrequency)*audioDraw.frame.size.height/2+audioDraw.frame.size.height/2;
        }
        [audioDraw setWaveform:waveDrawValues arraySize:audioDraw.frame.size.width];
        [self drawFFT];
        audioDrawCalled = YES;
    }
}

@end
