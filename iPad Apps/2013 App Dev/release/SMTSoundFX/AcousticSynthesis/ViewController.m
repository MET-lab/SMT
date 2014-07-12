//
//  ViewController.m
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/4/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "ViewController.h"
#define kFFTSize 1024
@interface ViewController ()

@end

@implementation ViewController

float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    counter = 0;
    
    baseFrequency = 440;
    audioOut = [[AudioOutput alloc] initWithDelegate:self];
    numSliders = 10;
    numHarmonics = 10;
    envelopeIndex = 0;
    isRunning = NO;
    fftCalled = NO;
    theta = 0;
    numSeconds = 3;
    bufferLength = 1024;
    graphWidth = audioDraw.frame.size.width;
    graphHeight = audioDraw.frame.size.height;
    timeEnvelope = (float*)calloc(kOutputSampleRate*numSeconds, sizeof(float));
    minFrequency = baseFrequency;
    maxFrequency = (numSliders-1)*baseFrequency;

    for (int i = 0;i<kOutputSampleRate*numSeconds;i++) {
        timeEnvelope[i]=0.5;
    }
    
    // Master Volume parameter and slider
    masterVol = 1.0;
    masterVolSlider.value = 1.0;
    
    masterVolSlider.frame = CGRectMake(audioDraw.frame.origin.x-180, audioDraw.frame.origin.y+133, audioDraw.frame.size.height+20, 10);
    masterVolSlider.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
    
    
    // Hard clipping cutoff and pinch gesture recognizer
    distCutoffPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(distCutoffPinch:)];
    [[self view] addGestureRecognizer:distCutoffPinch];
    
    mLastScale = 1.0;
    clippingAmplitude = 1.1;
    thetaZero = 0;
    
    // Update the plots on the next audio buffer
    scheduleUpdate = false;
    
    // Initialize the plot buffer
    drawBuffer  = (float*)calloc(graphWidth, sizeof(float));
    dryBuffer   = (float*)calloc(bufferLength, sizeof(float));
    
    for(int i = 0; i < graphWidth; i++) 
        drawBuffer[i]  = 0;

    [audioDraw setWaveform:drawBuffer];
    
    // Initialize spectra plot buffers
    filterPlotBuffer = (float*)calloc(graphWidth, sizeof(float));
    specBuffer    = (float*)calloc(kFFTSize, sizeof(float));
    drySpecBuffer = (float*)calloc(kFFTSize, sizeof(float));
    int specLength = sizeof(specBuffer) / sizeof(float);
    
    printf("specLength = %d\n", specLength);
    printf("kFFTSize   = %d\n", kFFTSize);
    
    for(int i = 0; i < graphWidth; i++) {
        specBuffer[i] = 0;
        drySpecBuffer[i] = 0;
        filterPlotBuffer[i] = 0;
    }
    
    // ==== Filter drawing ==== //
    filterDrawEnabled = false;
    filterEnabled = true;
    
    filterDrawView = [[EnvelopeView alloc] initWithFrame:spectrumDraw.frame];
    [filterDrawView setBackgroundColor:[UIColor clearColor]];
    filterDrawView.alpha = 0.0;
    
    [self.view addSubview:filterDrawView];
    
    drawnFilter = (float*)calloc(graphWidth, sizeof(float));
    drawnFilter = [filterDrawView getWaveform];
    
    filterAmpsAtHarmonics = [[NSMutableArray alloc] init];
    
    // Initialize filter amplitudes at the harmonics to 1 (no filtering)
    for(int i = 0; i <= numHarmonics; i++)
        [filterAmpsAtHarmonics addObject:[NSNumber numberWithFloat:1.0]];
    
    // Panning gesture for shifting the filter right or left
    filterShiftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(filterShiftPan:)];
    filterShiftPan.minimumNumberOfTouches = 2;
    filterShiftPan.maximumNumberOfTouches = 2;
    [spectrumDraw addGestureRecognizer:filterShiftPan];
    
    [self processFrequencyEnvelope];
    
    // SHITTY ADD
    // Harmonic sliders on spectrum plot
    spectrumHandles = [[NSMutableArray alloc] init];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerFired:)
                                            userInfo:nil
                                             repeats:YES];
    //
    
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    
    
    sliders = [[NSMutableArray alloc] init];
    sliderAmplitudes = [[NSMutableArray alloc] init];
    harmonicLabels = [[NSMutableArray alloc] init];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftPhase = (float*)calloc(kFFTSize/2, sizeof(float));
    fftMag = (float*)calloc(kFFTSize/2, sizeof(float));
    fftBuffer = (float*)calloc(graphWidth*2, sizeof(float));
    
    dryFftPhase = (float*)calloc(kFFTSize/2, sizeof(float));
    dryFftMag = (float*)calloc(kFFTSize/2, sizeof(float));
    dryFftBuffer = (float*)calloc(graphWidth*2, sizeof(float));
    
    int sliderX = 77;
    
    for (int i = 1; i<= numSliders; i++) {
//        if (i <=  numSliders-1) {
            UILabel *marker = [[UILabel alloc] initWithFrame:CGRectMake(i*sliderX-70, 653, 70, 24)];
            marker.text = [NSString stringWithFormat:@"%.0fHz",i*baseFrequency];
            marker.textColor = [UIColor whiteColor];
            marker.textAlignment = UITextAlignmentCenter;
            marker.backgroundColor = [UIColor clearColor];
            marker.tag = i+100;
            marker.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:marker];
            
            // SHITTY ADD
            float tempDrawWidth = spectrumDraw.frame.size.width;
            float tempDrawHeight = spectrumDraw.frame.size.height;
            float hopWidth = tempDrawWidth/9;
            
            SpectrumPoint* specPoint = [[SpectrumPoint alloc] initWithFrame:CGRectMake((i-1)*hopWidth-15,tempDrawHeight-15, 30, 30)];
            [specPoint setIdNum:(i-1)];
            [spectrumHandles addObject:specPoint];
            [spectrumDraw addSubview:[spectrumHandles objectAtIndex:(i-1)]];
            //
//        }
        
//        } else {
//            UILabel *marker = [[UILabel alloc] initWithFrame:CGRectMake(i*69-64, 650, 70, 24)];
//            marker.text = @"Noise";
//            marker.textColor = [UIColor whiteColor];
//            marker.textAlignment = UITextAlignmentCenter;
//            marker.backgroundColor = [UIColor clearColor];
//            [self.view addSubview:marker];
//        }
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(i*sliderX-123, 750, 170, 23)];
        [slider setTag:i];
        if (i==1) {
            [slider setValue:1];
        } else {
            [slider setValue:0];
        }
        [slider addTarget:self action:@selector(harmonicSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slider];
        slider.transform = trans;
        
        [slider setMinimumTrackImage:[[UIImage imageNamed:@"drexelSlider.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [sliders addObject:slider];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*sliderX-70, 845, 70, 24)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%.2f",slider.value];
        label.backgroundColor = [UIColor clearColor];
        [label setTag:i];
        [self.view addSubview:label];
        [harmonicLabels addObject:label];
        [sliderAmplitudes addObject:[NSNumber numberWithFloat:[slider value]]];
    }
    
    [self freqSliderChanged:nil];
    
    
    
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 0;i<numSliders-2;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*78+43, 600, 40,30)];
        graphFreqLabel.text = [NSString stringWithFormat:@"%.f",(i+1)*baseFrequency];
        graphFreqLabel.textColor = [UIColor grayColor];
        graphFreqLabel.alpha = 0.6;
        graphFreqLabel.backgroundColor = [UIColor clearColor];
        graphFreqLabel.tag = (i+1)+1000;
        graphFreqLabel.font = [UIFont systemFontOfSize:12];
        
        graphFreqLabel.transform = rotate;
        [self.view addSubview:graphFreqLabel];
        
    }
    
    
    
    for (int i = 0;i<=8;i+=2) {
        UILabel *graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*78+33, 136, 40,30)];
        graphTimeLabel.text = [NSString stringWithFormat:@"%.3f",(i)*(1.0/baseFrequency)];
        graphTimeLabel.textColor = [UIColor grayColor];
        graphTimeLabel.alpha = 0.6;
        graphTimeLabel.backgroundColor = [UIColor clearColor];
        graphTimeLabel.tag = i+2000;
        graphTimeLabel.font = [UIFont systemFontOfSize:12];
        graphTimeLabel.transform = rotate;
        [self.view addSubview:graphTimeLabel];
        
    }
    
    // Get the upper-left point of the time domain plot
    CGPoint ul = audioDraw.frame.origin;
    
    UILabel *graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ul.x, 68, 40,30)];
    graphTimeLabel.text = @"0.5";
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.transform = rotate;
    [self.view addSubview:graphTimeLabel];
    
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ul.x, 208, 40,30)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.transform = rotate;
    graphTimeLabel.text = @"-0.5";
    [self.view addSubview:graphTimeLabel];
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(675, 175, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"Time (ms)";
    [self.view addSubview:graphTimeLabel];
    
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ul.x + 2, 40, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"Amplitude";
    [self.view addSubview:graphTimeLabel];
    
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 365, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"Magnitude";
    [self.view addSubview:graphTimeLabel];
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 380, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"0.75";
    graphTimeLabel.transform = rotate;
    [self.view addSubview:graphTimeLabel];
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 447, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"0.5";
    graphTimeLabel.transform = rotate;
    [self.view addSubview:graphTimeLabel];
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 514, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"0.25";
    graphTimeLabel.transform = rotate;
    [self.view addSubview:graphTimeLabel];
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(650, 585, 100,20)];
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.text = @"Frequency (Hz)";
    [self.view addSubview:graphTimeLabel];
    
    
    [freqSlider setMinimumTrackImage:[[UIImage imageNamed:@"drexelSlider.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [self performSelectorOnMainThread:@selector(drawFFT) withObject:nil waitUntilDone:NO];
    
    check = false;
    
    [[sliders objectAtIndex:0] setValue:(float)0.75 animated:NO];
    masterVolSlider.value = masterVol = 0.5;
}


-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    
    free(audioBuffer);
    free(dryBuffer  );
    audioBuffer = (float*)calloc(bufferSize, sizeof(float));
    dryBuffer   = (float*)calloc(bufferSize, sizeof(float));
    bufferLength = bufferSize;
    thetaIncrement = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    
    /* Stabilization of the time domain waveform is achieved by finding
       the first phase zero in the buffer and plotting from there */
    bool found = false;
    
    for (int i = 0; i < bufferLength; i++) {
        
        buffer[i] = 0;
        
        // With "filtering"
        if(filterEnabled) {
            // Grab slider and filter amplitudes for additive sinusoidal synthesis        
            for (int j = 0;j<numSliders-1;j++)
                buffer[i] += [[filterAmpsAtHarmonics objectAtIndex:j] floatValue] * [[sliderAmplitudes objectAtIndex:j] floatValue] * sin(theta*(j+1));
        }
        
        // No "filtering"
        else {
            // Grab just slider amplitudes
            for (int j = 0;j<numSliders-1;j++)
                buffer[i] += [[sliderAmplitudes objectAtIndex:j] floatValue] * sin(theta*(j+1));
        }
        
//        // Apply noise based on noise slider
//        buffer[i] += randomFloat((-1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue],
//                                  (1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue]);
//        buffer[i] *= timeEnvelope[timeEnvelopeIndex];
        
        // Master Volume slider
        buffer[i] *= masterVol;
        
//        // Sigmoid (soft clipping) at device limit (1 Vpk, 2 Vp-p)
//        buffer[i] = 2.0 / ( 1.0 + pow(2.71828, buffer[i])) - 1.0;
        
        // Hard clipping
        if (buffer[i] > clippingAmplitude)
            buffer[i] = clippingAmplitude;
        else if (buffer[i] < -clippingAmplitude)
            buffer[i] = -clippingAmplitude;
                
        audioBuffer[i] = buffer[i];
        
        theta += thetaIncrement;
        if (theta > 2*M_PI) {
            theta -= 2*M_PI;
            
            // If we've found the first phase zero, save the index to plot from this point
            if(!found) {
                thetaZero = i;
                found = true;
            }
        }
        
        timeEnvelopeIndex++;
        if (timeEnvelopeIndex  > kOutputSampleRate*numSeconds) {
            timeEnvelopeIndex -= kOutputSampleRate*numSeconds;
        }
    }    
    
    // If a parameter has changed since the last buffer, update the plots
    if ( scheduleUpdate )
        [self performSelectorOnMainThread:@selector(drawFFT) withObject:nil waitUntilDone:NO];    
}

-(void) updateAudioWaveform {
    
    // Get the first 500 samples after the first phase zero
    int start = (int)thetaZero;
    int end   = (int)thetaZero + 500;
    
    // Get linearly-spaced samples from this range of the audio buffer to fit in the graph
    float *indices = (float*)calloc(graphWidth, sizeof(float));
    [MatlabFunctions linspace:start max:end numElements:graphWidth array:indices];
    
    // Fill the draw buffer with these samples
    for(int i = 0; i < graphWidth; i++) {
        drawBuffer[i] = audioBuffer[(int)round(indices[i])]; //*graphHeight/2+graphHeight/2;
    }
    
    // Plot them jawns
    [audioDraw setWaveform:drawBuffer];
    [audioDraw setDistCutoff:&clippingAmplitude];
}

-(void) drawFFT {
    
    scheduleUpdate = false;
    
    for (int m = 0; m < graphWidth; m++) {
        
        fftBuffer[m] = audioBuffer[m];
        fftBuffer[m+1] = 0;
    
        dryFftBuffer[m] = dryBuffer[m];
        dryFftBuffer[m+1] = 0;
    }
    
    [fft forwardWithStart:0 withBuffer:fftBuffer    magnitude:fftMag    phase:fftPhase    useWinsow:NO];
    [fft forwardWithStart:0 withBuffer:dryFftBuffer magnitude:dryFftMag phase:dryFftPhase useWinsow:NO];
    
    free(specBuffer);
//    free(drySpecBuffer);
    free(filterPlotBuffer);
    
    specBuffer       = (float*)calloc(specPlotLength, sizeof(float));
//    drySpecBuffer    = (float*)calloc(specPlotLength, sizeof(float));
    filterPlotBuffer = (float*)calloc(specPlotLength, sizeof(float));
    
    // Get linearly-spaced samples of the drawn filter to fit this new size
    float *indices = (float*)calloc(graphWidth, sizeof(float));
    [MatlabFunctions linspace:minIndex max:graphWidth numElements:specPlotLength array:indices];
    
    for(int i = 0; i < specPlotLength; i++) {
        filterPlotBuffer[i] = drawnFilter[(int)round(indices[i])] * spectrumDraw.frame.size.height;
    }
    
    // Get indices of interest from the FFT magnitudes for the spectrum plots
    int count = 0;
    for (int i = minIndex; i <= maxIndex; i++) {
        
        specBuffer[count]    = fftMag[i];
        drySpecBuffer[count] = dryFftMag[i];
        
        count++;
    }
    
    // Update the spectrum plots
//    [spectrumDraw setDrySpec:drySpecBuffer        length:specPlotLength];
    [spectrumDraw setWetSpec:specBuffer           length:specPlotLength];
    [spectrumDraw setFilterCurve:filterPlotBuffer length:specPlotLength];
    
    // Update the time domain plots
    [self updateAudioWaveform];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(IBAction)playPressed:(id)sender {
    
    if(!isRunning)
    {
        scheduleUpdate = true; 
        [audioOut startOutput];
        isRunning = YES;
        [playButton setImage:[UIImage imageNamed:@"stopButton.png"] forState:UIControlStateNormal];
    }
    else{
        [audioOut stopOutput];
        isRunning = NO;
        timeEnvelopeIndex = 0;
        [playButton setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)stopPressed:(id)sender {
    
    [audioOut stopOutput];
    isRunning = NO;
    timeEnvelopeIndex = 0;
}

-(IBAction) distCutoffPinch:(UIPinchGestureRecognizer *)sender {
    
    // Grab the center point of the pinch gesture
    CGPoint touchLocation = [sender locationInView:sender.view];
    
    // Recognize the pinch if its center is within the time domain plot bounds
    if(touchLocation.x > audioDraw->upperLeft.x && touchLocation.y < audioDraw->lowerRight.x &&
       touchLocation.y > audioDraw->upperLeft.y && touchLocation.y < audioDraw->lowerRight.y) {
    
        scheduleUpdate = true;
        
        // Reset the current and previous scales on a new pinch gesture
        if(sender.state == UIGestureRecognizerStateBegan) {
           
            mCurrentScale = 1.0;
            mLastScale    = 1.0;
        }
        
        // Otherwise, increment or decrement by a constant depending on the direction of the pinch
        else {
            
            mCurrentScale = sender.scale;
            
            clippingAmplitude += (mCurrentScale > mLastScale ? 0.01 : -0.01);
            
            mLastScale = mCurrentScale;
        }
        
        // Bound the clipping amplitudes
        if(clippingAmplitude >  1.1) clippingAmplitude =  1.1;
        if(clippingAmplitude < 0.01) clippingAmplitude = 0.01;
    }
}

-(IBAction)freqSliderChanged:(id)sender {
    
    scheduleUpdate = true;
    
    fftCalled = NO;
    baseFrequency = [freqSlider value];
    freqLabel.text = [NSString stringWithFormat:@"%.1f",baseFrequency];
    freqLabel.textColor = [UIColor whiteColor];
    freqLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    
    indexStepSize = ((float)graphWidth/(kOutputSampleRate/baseFrequency));
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] > 100 && subView.tag < 100+numSliders) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.0fHz",(tempLabel.tag-100)*baseFrequency];
            } else if ([subView tag] > 1000 && [subView tag] < 1000+(numSliders-1)) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.0f",(tempLabel.tag-1000)*baseFrequency];
            } else  if ([subView tag] > 2000 && [subView tag] <= 2008) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.0f",(tempLabel.tag-2000)*(1000.0/baseFrequency)];
            }
        }
    }
    thetaIncrement = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    
//    [filterDrawController setBaseFrequency:baseFrequency];
//    [filterDrawController updateFrequencyLabels];
    minFrequency = baseFrequency;
    maxFrequency = (numSliders)*baseFrequency;
    
    // Update indices of frequencies of interest for the spectrum plots
    minIndex = floor(minFrequency/((kOutputSampleRate/2.0)/(kFFTSize/2.0)));
    maxIndex = floor(maxFrequency/((kOutputSampleRate/2.0)/(kFFTSize/2.0)));
    specPlotLength = maxIndex - minIndex + 2;
    
    [spectrumDraw setFreqzLinspace:specPlotLength];
}

-(IBAction)harmonicSliderChanged:(id)sender {
    
    scheduleUpdate = true;
    
    fftCalled = NO;
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] == [sender tag]) {
                UILabel *tempLabel = (UILabel*)subView;
                UISlider *tempSlider = (UISlider*)sender;
                tempLabel.text = [NSString stringWithFormat:@"%.2f",[tempSlider value]];
                [sliderAmplitudes replaceObjectAtIndex:([subView tag]-1) withObject:[NSNumber numberWithFloat:[tempSlider value]]];
                
                // SHITTY ADD
                if(([subView tag]-1)<10)
                {
                    [[spectrumHandles objectAtIndex:([subView tag]-1)] setAmplitude:(1-[tempSlider value])];
                    
                }
                
                break;
            }
        }
    }
}

-(void) drawingEnded {
    
} 


-(void) updateSpectrumLabels {
    
}

//-(IBAction)timeEnvelopePressed:(id)sender {
//    [timePopover presentPopoverFromRect:timeEnvelopeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}

//-(IBAction)frequencyEnvelopePressed:(id)sender {
//    [filterDrawPopover presentPopoverFromRect:freqEnvelopeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}

-(void) timeEnvelopeDonePressed {
    [timePopover dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:timePopover];
}

-(void) freqEnvelopeDonePressed {
//    [filterDrawPopover dismissPopoverAnimated:YES];
//    [self popoverControllerDidDismissPopover:filterDrawPopover];
    
    scheduleUpdate = true;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    if (popoverController == timePopover) {
//        [self newTimeEnvelope];
//    } else if (popoverController == filterDrawPopover) {
//        [self processFrequencyEnvelope];
//    }
//    
//    if (popoverController == filterDrawPopover)
//        [self processFrequencyEnvelope];
}

-(void) newTimeEnvelope {
    int numSamples = kOutputSampleRate*numSeconds;
    float *tempIndices = (float*)calloc(numSamples, sizeof(float));
    [MatlabFunctions linspace:0 max:graphWidth numElements:numSamples array:tempIndices];
    for (int i = 0;i<numSamples;i++) {
        timeEnvelope[i] = drawnTimeEnvelope[(int)round(tempIndices[i])];
        if (timeEnvelope[i] < 0.05) {
            timeEnvelope[i] = 0.001;
        }
    }
}

-(void) processFrequencyEnvelope {
    
    float *indices = (float*)calloc(numSliders, sizeof(float));
    [MatlabFunctions linspace:0 max:graphWidth numElements:numSliders array:indices];
    
    float val;
    int count;
    
    // For each harmonic, get the filter amplitude at the slider's frequency
    for(int i = 1; i < numSliders; i++) {
        
        val = 0;
        count = 0;
        
        for (int j = indices[i-1]; j < indices[i]; j++) {
            val += drawnFilter[j];
            count++;
        }
        
//        printf("val[%d] = %1.2f\n", i, val);
        
        [filterAmpsAtHarmonics replaceObjectAtIndex:(i-1) withObject:[NSNumber numberWithFloat:(val/(float)count)]];
    }
    
    free(indices);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


-(void) setSliderValues:(NSMutableArray*)sliderValues {
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UISlider class]]) {
            UISlider *slider = (UISlider*)subview;
            int tagNum = slider.tag;
            if (tagNum <= numSliders-1 && tagNum > 0) {
                [slider setValue:[[sliderValues objectAtIndex:(tagNum-1)] floatValue]];
            }
        } else if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)subview;
            int tagNum = label.tag;
            if (tagNum <= numSliders-1 && tagNum > 0) {
                [label setText:[NSString stringWithFormat:@"%.2f",[[sliderValues objectAtIndex:(tagNum-1)] floatValue]]];
            }
        }
    }
//    [self updateAudioWaveform];
}

-(IBAction)filterDrawButtonPressed:(id)sender {
    
//    [filterDrawPopover presentPopoverFromRect:filterDrawButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    // If we're exiting filter draw mode
    if(filterDrawEnabled) {
        
        filterEnabled = true;
        filterDrawEnabled = false;
        filterDrawView.alpha = 0.0;
        
        spectrumDraw->filterDrawEnabled = true;
        
//        drawnFilter = [filterDrawView getWaveform];
        
//        [self processFrequencyEnvelope];
    }
    
    // If we're entering filter draw mode
    else {
        
        filterEnabled = false;
        filterDrawEnabled = true;
        
        [filterDrawView setBackgroundColor:[UIColor grayColor]];
        filterDrawView.alpha = 0.5;
        
        spectrumDraw->filterDrawEnabled = false;
        
        [filterDrawView setScaledValues:drawnFilter arraySize:filterDrawView.frame.size.width]; 
    }
    
    scheduleUpdate = true;
    drawnFilter = [filterDrawView getWaveform];
    [self processFrequencyEnvelope];
}

-(IBAction) filterShiftPan:(UIPanGestureRecognizer *)sender {
    
//    printf("translation = %1.2f, velocity = %1.2f\n", [sender translationInView:spectrumDraw].x, [sender velocityInView:spectrumDraw].x);
    
    // Thought: Should we take the center point of the touches relative to the center of the view and use it to
    // copy the drawn filter curve into a new curve shifted by that number of indices?
    
    // Grab the center point of the gesture
    CGPoint touchLocation = [sender locationInView:sender.view];
    
    // Shift by a number of indices determined by the current location
    int shiftByN;
    
    if(sender.state == UIGestureRecognizerStateBegan) {
        previousSwipeLocation = touchLocation;
    }
    
    else {
        
        // Shift to the right
        if(touchLocation.x > previousSwipeLocation.x) {
            
            shiftByN = round(touchLocation.x - previousSwipeLocation.x);

            for(int n = 0; n < shiftByN; n++) {
                for(int i = graphWidth - 1; i >= 0; i--)
                    drawnFilter[i+1] = drawnFilter[i];
            }
        }
        
        // Shfit to the left
        else {
        
            shiftByN = round(previousSwipeLocation.x - touchLocation.x);
            
            for(int n = 0; n < shiftByN; n++) {
                for(int i = 1; i <= graphWidth; i++)
                    drawnFilter[i-1] = drawnFilter[i];
            }
        }
        
        previousSwipeLocation = touchLocation;
        
    }
    
    [self processFrequencyEnvelope];

    scheduleUpdate = true;
    
//    @try {
//        // Shift to the right
//        if([sender translationInView:spectrumDraw].x - previousTranslation > 0.0) {
//            
//            for(int i = graphWidth - 1; i >= 0; i--)
//                drawnFilter[i+1] = drawnFilter[i];
//            
//            for(int i = graphWidth - 1; i >= 0; i--)
//                drawnFilter[i+1] = drawnFilter[i];
//            
//            for(int i = graphWidth - 1; i >= 0; i--)
//                drawnFilter[i+1] = drawnFilter[i];
//        }
//        
//        // Shift to the left
//        else {
//            for(int i = 1; i <= graphWidth; i++)
//                drawnFilter[i-1] = drawnFilter[i];
//            
//            for(int i = 1; i <= graphWidth; i++)
//                drawnFilter[i-1] = drawnFilter[i];
//            
//            for(int i = 1; i <= graphWidth; i++)
//                drawnFilter[i-1] = drawnFilter[i];
//        }
//        
//        previousTranslation = [sender translationInView:spectrumDraw].x;
//        
//        [self processFrequencyEnvelope];
//        
//        scheduleUpdate = true;
//    }
//    
//    @catch (NSException *e) {
//        NSLog(@"Exception: %@", e);
//    }
}

-(IBAction) masterVolumeChanged:(UISlider*)sender {
    masterVol = sender.value;
    
    scheduleUpdate = true;
}

// SHITTY ADD
-(void)timerFired:(NSTimer *) theTimer
{
//    NSLog(@"timerFired @ %@", [theTimer fireDate]);
    NSMutableArray *sliderValues = [[NSMutableArray alloc] init];
    for(int i = 0; i<[spectrumHandles count];i++)
    {
        float tempJawn = [[spectrumHandles objectAtIndex:i] getGainVal];
        [sliderValues addObject:[NSNumber numberWithFloat:tempJawn]];
        [sliderAmplitudes replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:tempJawn]];
        
    }
    [self setSliderValues:sliderValues];
}
//

@end
















