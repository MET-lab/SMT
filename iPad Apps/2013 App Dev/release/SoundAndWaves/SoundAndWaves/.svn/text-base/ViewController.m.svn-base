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
    drawCount = 0;
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
    amplitude = 1;
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftPhase = (float*)calloc(kFFTSize, sizeof(float));
    fftMag = (float*)calloc(kFFTSize, sizeof(float));
//    thetaIncrement = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    [self freqSliderChanged:nil];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    ampSlider = [[UISlider alloc] initWithFrame:CGRectMake(-120, 190, 300, 23)];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    [ampSlider addTarget:self action:@selector(ampSliderChanged) forControlEvents:UIControlEventValueChanged];
    ampSlider.transform = trans;
    ampSlider.value = 1;
    [self.view addSubview:ampSlider];
    ampLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 355, 40, 20)];
    ampLabel.text = [NSString stringWithFormat:@"%.2f",[ampSlider value]];
    ampLabel.textColor = [UIColor whiteColor];
    ampLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ampLabel];
    
    [spectrumDraw setBackgroundColor:[UIColor clearColor]];
    [audioDraw setBackgroundColor:[UIColor clearColor]];
    
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 1;i<=9;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*67+65, 162, 40,30)];
        graphFreqLabel.text = [NSString stringWithFormat:@"%.f",(1000*i)/baseFrequency];
        graphFreqLabel.textColor = [UIColor grayColor];
        graphFreqLabel.alpha = 0.8;
        graphFreqLabel.backgroundColor = [UIColor clearColor];
        graphFreqLabel.tag = i+1000;
        graphFreqLabel.font = [UIFont systemFontOfSize:12.5];
        graphFreqLabel.transform = rotate;
        [self.view addSubview:graphFreqLabel];
        
    }
}

-(void) ampSliderChanged {
    ampLabel.text = [NSString stringWithFormat:@"%.2f",[ampSlider value]];
    amplitude = [ampSlider value];
    if (!isRunning) {
        [self notRunningFFT];
    }
    
}

-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    
    free(audioBuffer);
    audioBuffer = (float*)calloc(bufferSize, sizeof(float));
    bufferLength = bufferSize;
    for (int i = 0;i<bufferLength;i++) {
        buffer[i] = drawnWaveform[(int)round(bufferIndex)];
        audioBuffer[i] = buffer[i];
        buffer[i] *= amplitude;
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
    drawCount = 0;
    if (!isRunning) {
        [self notRunningFFT];
    }
    
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
             if ([subView tag] > 1000 && [subView tag] < 1010) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.f",(1000*([subView tag]-1000))/baseFrequency];
            }
        }
    }
}

-(void) drawFFT {
    
    if (drawCount <2) {
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
        drawCount++;
        [spectrumDraw plotValues:fftMag arraySize:kFFTSize/8.0 amplitude:amplitude];
    }
}

-(void) notRunningFFT {
    
    free(audioBuffer);
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    for (int i = 0;i<bufferLength;i++) {
        audioBuffer[i] = drawnWaveform[(int)round(bufferIndex)];
        audioBuffer[i] *= amplitude;
        bufferIndex += indexStepSize;
        if (bufferIndex > graphWidth) {
            bufferIndex -= graphWidth;
        }
    }
    drawCount = 0;
    [self drawFFT];
    
}

-(void) drawViewChanged {
    drawCount = 0;
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
    drawCount = 0;
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

@end
