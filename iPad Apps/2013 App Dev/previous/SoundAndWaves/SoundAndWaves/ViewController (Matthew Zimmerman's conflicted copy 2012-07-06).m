//
//  ViewController.m
//  SoundAndWaves
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define kFFTSize 1024
#define kUseDB 0
#define kNumHarmonics 500
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
    audioOut = [[AudioOutput alloc] initWithDelegate:self];
    [audioDraw resetDrawing];
    [audioDraw setDelegate:self];
    baseFrequency = 440;
    drawnWaveform = [audioDraw getWaveform];
    graphWidth = audioDraw.frame.size.width;
    graphHeight = audioDraw.frame.size.height;
    bufferIndex = 0;
//    theta = 0;
    bufferLength = 1024;
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftPhase = (float*)calloc(kFFTSize, sizeof(float));
    fftMag = (float*)calloc(kFFTSize, sizeof(float));
//    thetaIncrement = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    [self freqSliderChanged:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    
    free(audioBuffer);
    audioBuffer = (float*)calloc(bufferSize, sizeof(float));
    bufferLength = bufferSize;
    for (int i = 0;i<bufferLength;i++) {
        buffer[i] = drawnWaveform[(int)round(bufferIndex)];
        audioBuffer[i] = buffer[i];
        bufferIndex += indexStepSize;
        if (bufferIndex > graphWidth) {
            bufferIndex -= graphWidth;
        }
    }
    [self performSelectorOnMainThread:@selector(drawFFT) withObject:nil waitUntilDone:NO];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)freqSliderChanged:(id)sender {
    baseFrequency = [freqSlider value];
    freqLabel.text = [NSString stringWithFormat:@"%.1f",baseFrequency];
    indexStepSize = ((float)graphWidth/(kOutputSampleRate/baseFrequency));
    if (!isRunning) {
        [self notRunningFFT];
    }
}

-(void) drawFFT {
    
    float *tempBuffer = (float*)calloc(graphWidth*2, sizeof(float));
    for (int i = 0;i<bufferLength;i++) {
        tempBuffer[i] = audioBuffer[i];
        tempBuffer[i+1] = 0;
    }
    
    [fft forwardWithStart:0 withBuffer:tempBuffer magnitude:fftMag phase:fftPhase useWinsow:NO];
    free(tempBuffer);
    
    if (kUseDB) {
        for (int i = 0;i<kFFTSize;i++) {
            fftMag[i] = 20*log10f(fftMag[i]);
        }
    }
    [spectrumDraw plotValues:fftMag arraySize:kFFTSize/2.0];
    
}

-(void) notRunningFFT {
    
    free(audioBuffer);
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    for (int i = 0;i<bufferLength;i++) {
        audioBuffer[i] = drawnWaveform[(int)round(bufferIndex)];
        bufferIndex += indexStepSize;
        if (bufferIndex > graphWidth) {
            bufferIndex -= graphWidth;
        }
    }
    [self drawFFT];
    
}

-(void) drawViewChanged {
    if (!isRunning) {
        [self notRunningFFT];
    }
}

-(void) drawingStarted {
    [waveControl setSelectedSegmentIndex:3];
}

-(IBAction)waveTypeChanged:(id)sender  {
    
    switch ([waveControl selectedSegmentIndex]) {
        case 0:
            waveType = 0;
            break;
        case 1:
            waveType = 1;
            break;
        case 2:
            waveType = 2;
            break;
        case 3:
            waveType = 3;
            break;
        default:
            waveType = 0;
            break;
    }
    [self drawWaveType];
}


-(void) drawWaveType {
    
    if (waveType!=3) {
        if (waveType == 0) {
            [audioDraw resetDrawing];
        } else if (waveType == 1) {
            float *pointValues = (float*)calloc(graphWidth, sizeof(float));
            for (int i = 0;i<graphWidth;i++) {
                pointValues[i] = 0;
                for (int j = 1;j<=kNumHarmonics*2;j+=2) {
                    pointValues[i] += (1.0/(float)j)*sinf(j*2*M_PI*i/graphWidth);
                }
            }
            [FloatFunctions normalize:pointValues numElements:graphWidth];
            for (int i = 0;i<graphWidth;i++) {
                pointValues[i] = pointValues[i]*(graphHeight/2.0-20)+graphHeight/2.0;
            }
            [audioDraw setWaveform:pointValues arraySize:graphWidth];
            [self drawFFT];
        } else if (waveType == 2){
            float *pointValues = (float*)calloc(graphWidth, sizeof(float));
            for (int i = 0;i<graphWidth;i++) {
                pointValues[i] = 0;
                for (int j = 1;j<=kNumHarmonics;j++) {
                    pointValues[i] += (1.0/(float)j)*sinf(j*2*M_PI*(i-5)/(graphWidth-10));
                }
            }
            [FloatFunctions normalize:pointValues numElements:graphWidth];
            for (int i = 0;i<graphWidth;i++) {
                pointValues[i] = pointValues[i]*(graphHeight/2.0-20)+graphHeight/2.0;
            }
            [audioDraw setWaveform:pointValues arraySize:graphWidth];
            [self drawFFT];
        }
    }
    
}

-(IBAction)playPressed:(id)sender {
    [audioOut startOutput];
    isRunning = YES;
    
}

-(IBAction)stopPressed:(id)sender {
    [audioOut stopOutput];
    isRunning = NO;
}

-(IBAction)resetPressed:(id)sender {
    [audioDraw resetDrawing];
    [waveControl setSelectedSegmentIndex:0];
}
@end
