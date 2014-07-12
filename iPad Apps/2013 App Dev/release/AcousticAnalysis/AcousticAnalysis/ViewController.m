//
//  ViewController.m
//  AcousticAnalysis
//
//  Created by Matthew Zimmerman on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RangeSlider.h"
#define kFFTSize 4096
#define kRangeFactor 16.0
#define kFFTScaleFactor 150

int NFFT(float windowSize) {
    return (int)pow(2,ceil(log2f(windowSize)));
}

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

@synthesize button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    numSecondsInBuffer = 5;
    fullWaveform = (float*)calloc(kInputSampleRate*numSecondsInBuffer, sizeof(float));
    audioBuffer = (float*)calloc(kInputNumSamples, sizeof(float));
    [audioDraw setDrawEnabled:NO];
    isRunning = NO;
    fftDone = YES;
    
    audioIn = [[AudioInput alloc] initWithDelegate:self];
    graphWidth = (int)audioDraw.frame.size.width;
    graphHeight = (int)audioDraw.frame.size.height;
    
    fftBuffer = (float*)calloc(kInputNumSamples*2, sizeof(float));
    fftPhase = (float*)calloc(kFFTSize, sizeof(float));
    fftMag = (float*)calloc(kFFTSize, sizeof(float));
    plottingBuffer = (float*)calloc(graphWidth, sizeof(float));
    
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fullAudioIndices = (float*)calloc(fullAudioDraw.frame.size.width, sizeof(float));
    [MatlabFunctions linspace:0 max:kInputSampleRate*numSecondsInBuffer numElements:fullAudioDraw.frame.size.width array:fullAudioIndices];

    [fullAudioDraw setDrawEnabled:NO];
    fullAudioDrawBuffer = (float*)calloc(fullAudioDraw.frame.size.width, sizeof(float));
    
    for (int i = 0;i<fullAudioDraw.frame.size.width;i++) {
        fullAudioDrawBuffer[i] = fullAudioDraw.frame.size.height/2;
    }
//    fullWaveDrawBuffer = (float*)calloc(fullAudioDraw.frame.size.width, sizeof(float));
    fullNumDrawAudioSamples = (int)ceil((kInputNumSamples/(kInputSampleRate*numSecondsInBuffer))*fullAudioDraw.frame.size.width);
    fullAudioDrawBufferIndices = (float*)calloc(fullNumDrawAudioSamples, sizeof(float));
    [MatlabFunctions linspace:0 max:fullAudioDraw.frame.size.width numElements:fullNumDrawAudioSamples array:fullAudioDrawBufferIndices];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self drawFullWave];
    [self drawFFT];
    [self drawAudioWave];
    
    CGAffineTransform move = CGAffineTransformMakeTranslation(23, 475);
    windowSlider = [[RangeSlider alloc] initWithFrame:CGRectMake(-8, -78, 736, 250)];
    //    windowSlider = [[RangeSlider alloc] initWithFrame:CGRectMake(0, 100, 720, 250)];
    [windowSlider setMaximumValue:kInputSampleRate*numSecondsInBuffer];
    [windowSlider setMinimumValue:0];
    //[windowSlider setSelectedMaximumValue:kInputSampleRate*numSecondsInBuffer/2+20*kInputNumSamples];
    //[windowSlider setSelectedMinimumValue:kInputSampleRate*numSecondsInBuffer/2];
    [windowSlider setSelectedMaximumValue:windowSlider.maximumValue];
    [windowSlider setSelectedMinimumValue:windowSlider.minimumValue];
    [windowSlider setMinimumRange:5*kInputNumSamples];
    windowSlider.transform = move;
    [windowSlider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:windowSlider];
    
    
    float frameWidth = (windowSlider.selectedMinimumValue/(kInputSampleRate*numSecondsInBuffer))*fullAudioDraw.frame.size.width;
    //leftBox = [[UIView alloc] initWithFrame:CGRectMake(34, 330, frameWidth, 86)];
    leftBox = [[UIView alloc] initWithFrame:CGRectMake(fullAudioDraw.frame.origin.x, fullAudioDraw.frame.origin.y, frameWidth, fullAudioDraw.frame.size.height)];
    leftBox.backgroundColor = [UIColor lightGrayColor];
    leftBox.alpha = 0.6;
    [self.view addSubview:leftBox];
    
    
    float rightStart = (windowSlider.selectedMaximumValue/(kInputSampleRate*numSecondsInBuffer))*fullAudioDraw.frame.size.width+fullAudioDraw.frame.origin.x;
    rightBox = [[UIView alloc] initWithFrame:CGRectMake(rightStart, fullAudioDraw.frame.origin.y, fullAudioDraw.frame.size.width-rightStart+fullAudioDraw.frame.origin.x, fullAudioDraw.frame.size.height)];
    [rightBox setBackgroundColor:[UIColor lightGrayColor]];
    [rightBox setAlpha:0.6];
    [self.view addSubview:rightBox];
    
    windowSamples = (float*)calloc(kInputNumSamples*5, sizeof(float));
    [spectrumDraw setBackgroundColor:[UIColor clearColor]];
    [audioDraw setBackgroundColor:[UIColor clearColor]];
    [fullAudioDraw setBackgroundColor:[UIColor clearColor]];
    
    
    numberSamples = kInputNumSamples;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 1;i<=9;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*70, 230, 40,30)];
        //graphFreqLabel.text = [NSString stringWithFormat:@"%.3f",(i/10.0)*(20*numberSamples/kInputSampleRate)];
        graphFreqLabel.text = [NSString stringWithFormat:@"%.0f",floor((i/10.0*(kInputSampleRate/kRangeFactor)))];
        graphFreqLabel.textColor = [UIColor grayColor];
        graphFreqLabel.alpha = 0.8;
        graphFreqLabel.backgroundColor = [UIColor clearColor];
        graphFreqLabel.tag = i+1000;
        graphFreqLabel.font = [UIFont systemFontOfSize:12.5]; 
        graphFreqLabel.transform = rotate;
        //[self.view addSubview:graphFreqLabel];
        [spectrumDraw addSubview:graphFreqLabel];
        
    }
    
    graphOverlay = [[UIView alloc] initWithFrame:audioDraw.frame];
    
    float overlayWidth = 150;
    float overlayHeight = 65;
    float overlayOffset = 20;
    
    
    spectrumOverlay = [[UIView alloc] initWithFrame:CGRectMake(spectrumDraw.frame.size.width-overlayWidth, spectrumDraw.frame.origin.y+overlayOffset, overlayWidth, overlayHeight)];
    graphOverlay.backgroundColor = [UIColor clearColor];
    spectrumOverlay.backgroundColor = [UIColor colorWithRed:0/255.0 green:52/255.0 blue:120/255.0 alpha:1];
    [spectrumOverlay setAlpha:0.75];
    [self.view addSubview:graphOverlay];
    [self.view addSubview:spectrumOverlay];
    
    
    UIColor *drexelYellow = [UIColor colorWithRed:255/255.0 green:198/255.0 blue:0/255.0 alpha:1];
    spectrumDot = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
    graphDot = [[UIImageView alloc] initWithFrame:CGRectMake(-100, -100, 10, 10)];
    [graphDot setImage:[UIImage imageNamed:@"pointer.png"]];
    [spectrumDot setImage:[UIImage imageNamed:@"pointer.png"]];
    
    
    ampLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, spectrumOverlay.frame.size.width-10, 30)];
    ampLabel.text = @"Amp: Jawn";
    ampLabel.textColor = drexelYellow;
    [ampLabel setBackgroundColor:[UIColor clearColor]];
    
    freqLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,ampLabel.frame.size.height, spectrumOverlay.frame.size.width-10, 30)];
    freqLabel.text = @"Freq: Jawn";
    freqLabel.textColor = drexelYellow;
    [freqLabel setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    [spectrumOverlay addSubview:freqLabel];
    [spectrumOverlay addSubview:ampLabel];
    
    
    [spectrumOverlay removeFromSuperview];   
    
    

}

-(void) updateTimeLabels {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] > 1000 && [subView tag] < 1010) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.3f",(([subView tag]-1000)/10.0)*(numberSamples/kInputSampleRate)];
            }
        }
    }
}

-(void) valueChangedForDoubleSlider:(id)sender {
    
    float frameWidth = (windowSlider.selectedMinimumValue/(kInputSampleRate*numSecondsInBuffer))*fullAudioDraw.frame.size.width;
    leftBox.frame = CGRectMake(fullAudioDraw.frame.origin.x, fullAudioDraw.frame.origin.y, frameWidth, fullAudioDraw.frame.size.height);
    
    float rightStart = (windowSlider.selectedMaximumValue/(kInputSampleRate*numSecondsInBuffer))*fullAudioDraw.frame.size.width+fullAudioDraw.frame.origin.x;
    rightBox.frame = CGRectMake(rightStart, fullAudioDraw.frame.origin.y, fullAudioDraw.frame.size.width-rightStart+fullAudioDraw.frame.origin.x, fullAudioDraw.frame.size.height);
    [leftBox setNeedsDisplay];
    [rightBox setNeedsDisplay];
    
    
    int min = (int)round([windowSlider selectedMinimumValue]);
    int max = (int)round([windowSlider selectedMaximumValue]);
    numberSamples = max-min;
    
    if (!isRunning) {
        [self updateTimeLabels];
        [self showWindowInformation];
    }
}
- (void)viewDidUnload
{
    [self setButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void) processInputBuffer:(float*)buffer numSamples:(int)numSamples {
    hasSignal = NO;
    for (int i = 0;i<numSamples;i++) {
        audioBuffer[i] = buffer[i];
    }
    numBufferSamples = numSamples;
    [self performSelectorOnMainThread:@selector(updateEverything) withObject:nil waitUntilDone:NO];
}

-(void) updateEverything {
    
    [self shiftFullWave];
    int count = 0 ;
    for (int i = kInputSampleRate*numSecondsInBuffer-numBufferSamples+1;i<kInputSampleRate*numSecondsInBuffer;i++) {
        fullWaveform[i] = audioBuffer[count];
        count++;
    }
    count = 0;
    [self shiftFullDrawBuffer];
    for (int i = fullAudioDraw.frame.size.width-fullNumDrawAudioSamples;i<fullAudioDraw.frame.size.width;i++) {
        fullAudioDrawBuffer[i] = audioBuffer[(int)round(fullAudioDrawBufferIndices[count])]*fullAudioDraw.frame.size.height/2+fullAudioDraw.frame.size.height/2;
        count++;
    }
    
    [self updateDrawings];
//    [self showWindowInformation];
}

-(void) updateDrawings {
    [self drawAudioWave];
    [self drawFFT];
    [self drawFullWave];
}

-(void) drawAudioWave {
    
    float *indices = (float*)calloc(graphWidth, sizeof(float));
    [MatlabFunctions linspace:0 max:numBufferSamples numElements:graphWidth array:indices];
    for (int i = 0; i<graphWidth; i++) {
        plottingBuffer[i] = audioBuffer[(int)roundf(indices[i])]*graphHeight/2+graphHeight/2;
    }
    
    //int numZeroCrossings = 0;
    //for (int i = 0; i < graphWidth; i++) {
    //    if ( (int)fabsf(plottingBuffer[i] - graphHeight/2) + (int)fabsf(plottingBuffer[i+1] - graphHeight/2) != (int)fabsf((plottingBuffer[i] - graphHeight/2) + (plottingBuffer[i+1]-graphHeight/2)) )
    //        numZeroCrossings++;
    //}
    //if (numZeroCrossings < numBufferSamples) {
    //    [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:YES];
    //}
    
//    if ( windowSlider.selectedMaximumValue - windowSlider.selectedMinimumValue < 0.5 *  kInputSampleRate)
//            [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:YES];
//    else {
    [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:NO];
    [audioDraw setAvgEnvelopeForArraySize:graphWidth withSampleWidth:10 needsDisplay:YES];
//  }
    
    free(indices);
}

-(void) drawFFT {
    
    for (int i = 0;i<numBufferSamples;i++) {
        fftBuffer[i] = audioBuffer[i];
        fftBuffer[i+1] = audioBuffer[i+1];
    }
    [fft forwardWithStart:0 withBuffer:fftBuffer magnitude:fftMag phase:fftPhase useWinsow:NO bufferSize:numBufferSamples];
    //NSLog(@"Samples: %d", numBufferSamples);
    [spectrumDraw plotValues:fftMag arraySize:kFFTSize/kRangeFactor scaleFactor:kFFTScaleFactor];
}

-(void) drawFullWave {
    [fullAudioDraw setWaveform:fullAudioDrawBuffer arraySize:fullAudioDraw.frame.size.width needsDisplay:NO];
    [fullAudioDraw setAvgEnvelopeForArraySize:graphWidth withSampleWidth:10 needsDisplay:YES];
    
}

-(void) shiftFullWave {
    for (int i = numBufferSamples;i<kInputSampleRate*numSecondsInBuffer;i++) {
        fullWaveform[i-numBufferSamples] = fullWaveform[i];
    }
}

-(void) shiftFullDrawBuffer {
    for (int i = fullNumDrawAudioSamples;i<fullAudioDraw.frame.size.width;i++) {
        fullAudioDrawBuffer[i-fullNumDrawAudioSamples] = fullAudioDrawBuffer[i];
    }
}

-(IBAction)recordPressed:(id)sender {
    if (!runOnce) {
        runOnce = YES;
    }
    numberSamples = kInputNumSamples;
    [self updateTimeLabels];
    if (isRunning) {
        button.selected = NO;
        int min = (int)round([windowSlider selectedMinimumValue]);
        int max = (int)round([windowSlider selectedMaximumValue]);
        numberSamples = max-min;
        [self updateTimeLabels];
        [audioIn stop];
        isRunning = NO;
        [self showWindowInformation];
    }
    else if (!isRunning) {
        button.selected = YES;
        [fft fftSetSize:kFFTSize];
        [audioIn start];
        isRunning = YES;
        [spectrumDot removeFromSuperview];
        [spectrumOverlay removeFromSuperview];
    }

}

// Functionality moved up to recordPressed ^ (and button removed)
//-(IBAction)pausePressed:(id)sender {
//    if (isRunning) {
//
//        int min = (int)round([windowSlider selectedMinimumValue]);
//        int max = (int)round([windowSlider selectedMaximumValue]);
//        numberSamples = max-min;
//        [self updateTimeLabels];
//        [audioIn stop];
//        isRunning = NO;
//        [self showWindowInformation];
//    }
//}


//SHITTY: SHOWS TIME DOMSAIN SIGNAL AND FFT OF SELECTED WINDOW
-(void) showWindowInformation {
    
    int minIndex = (int)round([windowSlider selectedMinimumValue]);
    int maxIndex = (int)round([windowSlider selectedMaximumValue]);
    
    int numSamples = maxIndex - minIndex+1;
    free(windowSamples);
    windowSamples = (float*)calloc(numSamples, sizeof(float));
    numWindowSamples = numSamples;
    int count = 0;
    for (int i = minIndex;i<maxIndex;i++) {
        windowSamples[count] = fullWaveform[i];
        count++;
    }
    float *indices = (float*)calloc(graphWidth, sizeof(float));
    [MatlabFunctions linspace:minIndex max:maxIndex numElements:graphWidth array:indices];
    
    for (int i = 0;i<graphWidth;i++) {
        plottingBuffer[i] = fullWaveform[(int)round(indices[i])]*graphHeight/2+graphHeight/2;
    }
    free(indices);

    // Slowly lowers the samples rate of the envelope to transition to raw waveform
    if ( windowSlider.selectedMaximumValue - windowSlider.selectedMinimumValue < 0.3 *  kInputSampleRate)
        [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:YES];
    else if ( windowSlider.selectedMaximumValue - windowSlider.selectedMinimumValue < 0.6 * kInputSampleRate) {
        [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:NO];
        [audioDraw setAvgEnvelopeForArraySize:graphWidth withSampleWidth:5 needsDisplay:YES];
    }
    else if ( windowSlider.selectedMaximumValue - windowSlider.selectedMinimumValue < 0.45 * kInputSampleRate) {
        [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:NO];
        [audioDraw setAvgEnvelopeForArraySize:graphWidth withSampleWidth:3 needsDisplay:YES];
    }
    else {
        [audioDraw setWaveform:plottingBuffer arraySize:graphWidth needsDisplay:NO];
        [audioDraw setAvgEnvelopeForArraySize:graphWidth withSampleWidth:10 needsDisplay:YES];
    }
    
    free(fftMag);
    free(fftPhase);
    
    
    //DRAWS FFT
   // NSLog(@"%i",numSamples);
    

    //FFT SIZE Should be fixed, not a variable number of samples.
    int fftSize = [fft fftSetSize:kFFTSize];
    tempFFTSize = fftSize;
    //int fftSize = [fft fftSetSize:numSamples];
    //tempFFTSize = fftSize;
    if (fftDone) {
        fftDone = NO;
        fftMag = 0;
        fftPhase = 0;
        fftMag = (float*)realloc(fftMag,fftSize*sizeof(float));
        fftPhase = (float*)realloc(fftPhase, fftSize*sizeof(float));
        fftSize = [fft fftSetSize:fftSize];
        int fftCount = 0;
        float* fftSum = (float*)calloc(fftSize, sizeof(float));
        
        //FOR LOOP GOES HERE
        int sampleIndex = 0; //variable to keep track of which sample the fft is at
        int fftIndex = 1; //keeps track of which fft this is in sequence

        for (int i = sampleIndex; i < fftIndex * fftSize; i++ ) {
            if (numSamples < fftSize) {
                float *tempWindow = (float*)calloc(fftSize, sizeof(float));
                for (int i = 0;i<numSamples;i++) {
                    tempWindow[i] = windowSamples[i];
                }
                fftDone = [fft forwardWithStart:0 withBuffer:tempWindow magnitude:fftMag phase:fftPhase useWinsow:YES bufferSize:tempFFTSize];
                free(tempWindow);
            } else {
                fftDone = [fft forwardWithStart:0 withBuffer:windowSamples magnitude:fftMag phase:fftPhase useWinsow:YES bufferSize:tempFFTSize];
            }
            
            for (int i = 0;i<fftSize;i++) {
                fftSum[i] += fftMag[i];
            }
            fftCount++;
            sampleIndex += tempFFTSize;
        }
        //ENDS HERE
        
        
        //AVG ALL FFTS FROM FIXED WINDOWS
        for (int i = 0;i<fftSize;i++) {
            fftSum[i] = fftSum[i]/fftCount/2;
        }
        fftMag = fftSum;
    }
    
    indices = (float*)calloc(spectrumDraw.frame.size.width, sizeof(float));
    [MatlabFunctions linspace:0 max:fftSize/kRangeFactor numElements:spectrumDraw.frame.size.width array:indices];
    
    float *tempSpectrum = (float*)calloc(spectrumDraw.frame.size.width, sizeof(float));
    for (int i = 0;i<spectrumDraw.frame.size.width;i++) {
        tempSpectrum[i] = fftMag[(int)roundf((indices[i]))];
    }
    [spectrumDraw plotValues:tempSpectrum arraySize:spectrumDraw.frame.size.width scaleFactor:fftSize/16];
    [self updateSpectrumDot];
    free(tempSpectrum);
    free(indices);
}

// Button used for printing console output
-(IBAction)printPressed:(id)sender {
    
    /*
    for (int i = 0;i<tempFFTSize/2;i++) {
        printf("%f ",fftMag[i]);
    }
    printf("\n\n");
    */
    
    /*
    for (int i = 0; i < fullAudioDraw.frame.size.width ; i++ )
        printf("%f ", [fullAudioDraw getEnvelope]) ;
     */

//NSLog(@"min value: %f, max value: %f", windowSlider.selectedMinimumValue, windowSlider.selectedMaximumValue);
    
//NSLog(@"difference: %f", windowSlider.selectedMaximumValue - windowSlider.selectedMinimumValue);
    
    //NSLog(@"SampleRate: %f", kInputSampleRate * 0.5);
    
    
//NSLog(@"numBufferSamples: %d", numBufferSamples);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!isRunning && runOnce) {
        UITouch *touch = [touches anyObject];
        
        CGPoint touchPoint = [touch locationInView:audioDraw];
        if (touchPoint.x > 0 && touchPoint.x < audioDraw.frame.size.width) {
            if (touchPoint.y > 0 && touchPoint.y < audioDraw.frame.size.height) {
                return;
            }
        }
        
        touchPoint = [touch locationInView:spectrumDraw];
        if (touchPoint.x > 0 && touchPoint.x < spectrumDraw.frame.size.width) {
            if (touchPoint.y > 0 && touchPoint.y < spectrumDraw.frame.size.height) {
                
                currentSpectrumDotX = touchPoint.x;
                [spectrumDot removeFromSuperview];
                [self updateSpectrumDot];
                return;
            }
        }
    }
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!isRunning && runOnce) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:audioDraw];
        if (touchPoint.x > 0 && touchPoint.x < audioDraw.frame.size.width) {
            if (touchPoint.y > 0 && touchPoint.y < audioDraw.frame.size.height) {
                return;
            }
        }
        
        touchPoint = [touch locationInView:spectrumDraw];
        if (touchPoint.x > 0 && touchPoint.x < spectrumDraw.frame.size.width) {
            if (touchPoint.y > 0 && touchPoint.y < spectrumDraw.frame.size.height) {
                
                currentSpectrumDotX = touchPoint.x;
                [spectrumDot removeFromSuperview];
                [self updateSpectrumDot];
            }
        }
    }
    
}

-(void) updateSpectrumDot {
    
//    [spectrumDot removeFromSuperview];
    if (!isRunning && runOnce) {
        
        float y = spectrumDraw.frame.size.height-[spectrumDraw getValueAtIndex:(int)currentSpectrumDotX];
        [spectrumDot setFrame:CGRectMake(currentSpectrumDotX-spectrumDot.frame.size.width/2, [spectrumDraw getValueAtIndex:(int)currentSpectrumDotX]-spectrumDot.frame.size.height/2, spectrumDot.frame.size.width, spectrumDot.frame.size.height)];
        [spectrumDraw addSubview:spectrumDot];
        ampLabel.text = [NSString stringWithFormat:@"Amp: %.2f",y/spectrumDraw.frame.size.height ];
//        NSLog(@"%f",y*[spectrumDraw getScaleFactor]);
        [self.view addSubview:spectrumOverlay];
        
        freqLabel.text = [NSString stringWithFormat:@"Freq: %.1f Hz",(currentSpectrumDotX/spectrumDraw.frame.size.width)*kInputSampleRate/kRangeFactor];
    }
    
}
@end
