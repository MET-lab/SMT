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
    numSliders = 11;
    envelopeIndex = 0;
    isRunning = NO;
    fftCalled = NO;
    theta = 0;
    numSeconds = 1;
    bufferLength = 1024;
    graphWidth = audioDraw.frame.size.width;
    graphHeight = audioDraw.frame.size.height;
    timeEnvelope = (float*)calloc(kOutputSampleRate*numSeconds, sizeof(float));
    minFrequency = baseFrequency;
    maxFrequency = (numSliders-1)*baseFrequency;
    specBuffer = (float*)calloc(kFFTSize, sizeof(float));
    for (int i = 0;i<kOutputSampleRate*numSeconds;i++) {
        timeEnvelope[i]=0.5;
    }
    
    
    
    audioBuffer = (float*)calloc(bufferLength, sizeof(float));
    drawBuffer = (float*)calloc(graphWidth, sizeof(float));
    sliders = [[NSMutableArray alloc] init];
    sliderAmplitudes = [[NSMutableArray alloc] init];
    harmonicLabels = [[NSMutableArray alloc] init];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftPhase = (float*)calloc(kFFTSize/2, sizeof(float));
    fftMag = (float*)calloc(kFFTSize/2, sizeof(float));
    fftBuffer = (float*)calloc(graphWidth*2, sizeof(float));
    
    //SHITTY ADD
    spectrumHandles = [[NSMutableArray alloc] init];
    impulseHandles = [[NSMutableArray alloc] init];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self 
                                            selector:@selector(timerFired:) 
                                            userInfo:nil 
                                             repeats:YES];
    
    //SHITTY END
    
    for (int i = 1; i<=numSliders; i++) {
        if (i <= numSliders-1) {
            UILabel *marker = [[UILabel alloc] initWithFrame:CGRectMake(i*69-60, 653, 70, 24)];
            marker.text = [NSString stringWithFormat:@"%.0fHz",i*baseFrequency];
            marker.textColor = [UIColor whiteColor];
            marker.textAlignment = UITextAlignmentCenter;
            marker.backgroundColor = [UIColor clearColor];
            marker.tag = i+100;
            marker.font = [UIFont systemFontOfSize:14];
            marker.hidden = YES; //Shitty
            [self.view addSubview:marker];
            
            
            
            //SHITTY ADD SLIDER DOTS
            
            float tempDrawWidth = spectrumDraw.frame.size.width;
            float tempDrawHeight = spectrumDraw.frame.size.height;
            float hopWidth = tempDrawWidth/9;
            
            ImpulseView *impulseJawn = [[ImpulseView alloc] initWithFrame:CGRectMake((i-1)*hopWidth-2,tempDrawHeight-2, 4, 10)];
            [impulseJawn setIdNum:(i-1)];
            [impulseHandles addObject:impulseJawn];
            [spectrumDraw addSubview:[impulseHandles objectAtIndex:(i-1)]];

            
            SpectrumPoint* specPoint = [[SpectrumPoint alloc] initWithFrame:CGRectMake((i-1)*hopWidth-15,tempDrawHeight-15, 30, 30)];
            [specPoint setIdNum:(i-1)];
            [spectrumHandles addObject:specPoint];
            [spectrumDraw addSubview:[spectrumHandles objectAtIndex:(i-1)]];
            
            
                       
            
            //SHITTY END
            
            
            
        } else {
            UILabel *marker = [[UILabel alloc] initWithFrame:CGRectMake(i*69-64, 650, 70, 24)];
            marker.text = @"Noise";
            marker.textColor = [UIColor whiteColor];
            marker.textAlignment = UITextAlignmentCenter;
            marker.backgroundColor = [UIColor clearColor];
            marker.hidden = YES; //Shitty
            [self.view addSubview:marker];
        }
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(i*69-113, 750, 170, 23)];
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
        
       
        slider.hidden = TRUE; //Shitty ADD
        
        
        
        [sliders addObject:slider];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*69 -60, 845, 70, 24)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%.2f",slider.value];
        label.backgroundColor = [UIColor clearColor];
        [label setTag:i];
        label.hidden = YES; //Shitty
        [self.view addSubview:label];
        [harmonicLabels addObject:label];
        [sliderAmplitudes addObject:[NSNumber numberWithFloat:[slider value]]];
    }
    [audioDraw setDrawEnabled:NO];
    drawnWaveform = [audioDraw getWaveform];
    [self freqSliderChanged:nil];
    
    timeEnvelopeController = [[TimeEnvelopeViewController alloc] initWithNibName:@"TimeEnvelopeViewController" bundle:nil];
    [timeEnvelopeController setDelegate:self];
    timePopover = [[UIPopoverController alloc] initWithContentViewController:timeEnvelopeController];
    [timePopover setPopoverContentSize:timeEnvelopeController.view.frame.size];
    [timePopover setDelegate:self];
    drawnTimeEnvelope = [timeEnvelopeController.envelopeDraw getWaveform];
    
    
    frequencyEnvelopeController = [[FrequencyEnvelopeViewController alloc] initWithNibName:@"FrequencyEnvelopeViewController" bundle:nil];
    [frequencyEnvelopeController setDelegate:self];
    frequencyPopover = [[UIPopoverController alloc] initWithContentViewController:frequencyEnvelopeController];
    [frequencyPopover setPopoverContentSize:frequencyEnvelopeController.view.frame.size];
    [frequencyPopover setDelegate:self];
    drawnFrequencyEnvelope = [frequencyEnvelopeController.envelopeDraw getWaveform];
    
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 0;i<numSliders-2;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*78+33, 600, 40,30)];
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
    
    UILabel *graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 68, 40,30)];
    graphTimeLabel.text = @"0.5";
    graphTimeLabel.textColor = [UIColor grayColor];
    graphTimeLabel.alpha = 0.6;
    graphTimeLabel.backgroundColor = [UIColor clearColor];
    graphTimeLabel.tag = -1;
    graphTimeLabel.font = [UIFont systemFontOfSize:12];
    graphTimeLabel.transform = rotate;
    [self.view addSubview:graphTimeLabel];
    
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 208, 40,30)];
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
    
    
    graphTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 40, 100,20)];
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
}


-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    free(audioBuffer);
    audioBuffer = (float*)calloc(bufferSize, sizeof(float));
    bufferLength = bufferSize;
    thetaIncrement = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    for (int i = 0;i<bufferLength;i++) {
        buffer[i] = 0;
        for (int j = 0;j<numSliders-1;j++) {
            buffer[i] += [[sliderAmplitudes objectAtIndex:j] floatValue]*sin(theta*(j+1));
        }
        buffer[i] += randomFloat((-1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue], (1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue]);
        buffer[i] *= timeEnvelope[timeEnvelopeIndex];
        audioBuffer[i] = buffer[i];
        theta += thetaIncrement;
        if (theta > 2*M_PI) {
            theta -= 2*M_PI;
        }
        timeEnvelopeIndex++;
        if (timeEnvelopeIndex > kOutputSampleRate*numSeconds) {
            timeEnvelopeIndex -= kOutputSampleRate*numSeconds;
        }
        
    }
    if (!fftCalled) {
        [self performSelectorOnMainThread:@selector(drawFFT) withObject:nil waitUntilDone:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


//SHITTY EDIT
-(IBAction)playPressed:(id)sender {
    
    if(!isRunning)
    {
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

-(IBAction)freqSliderChanged:(id)sender {
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
    [self updateAudioWaveform];
    
    [frequencyEnvelopeController setBaseFrequency:baseFrequency];
    [frequencyEnvelopeController updateFrequencyLabels];
    minFrequency = baseFrequency;
    maxFrequency = (numSliders-1)*baseFrequency;
    
    
}

-(IBAction)harmonicSliderChanged:(id)sender {
    fftCalled = NO;
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] == [sender tag]) {
                UILabel *tempLabel = (UILabel*)subView;
                UISlider *tempSlider = (UISlider*)sender;
                tempLabel.text = [NSString stringWithFormat:@"%.2f",[tempSlider value]];
                [sliderAmplitudes replaceObjectAtIndex:([subView tag]-1) withObject:[NSNumber numberWithFloat:[tempSlider value]]];
                
                //SHITTY ADD
                if(([subView tag]-1)<10)
                {
                    [[spectrumHandles objectAtIndex:([subView tag]-1)] setAmplitude:(1-[tempSlider value])];

                }
                                
                break;
            }
        }
    }
    
    
    [self updateAudioWaveform];
}

-(void) updateAudioWaveform {
    for (int i = 0;i<graphWidth;i++) {
        drawBuffer[i] = 0;
        for (int j = 0;j<numSliders-1;j++) {
            drawBuffer[i] += -1*[[sliderAmplitudes objectAtIndex:j] floatValue]*sin(2*M_PI*(j+1)*((float)i/graphWidth));
        }
        drawBuffer[i] += randomFloat(-1*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue]/2.0, [[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue]/2.0);
    }
    
    //SHITTY EDIT
    //[FloatFunctions normalize:drawBuffer numElements:graphWidth];
    int counterJawn = 0;
    for (int i = 0;i<graphWidth*3;i=i+3) {
        //drawBuffer[i] = (drawBuffer[i]*graphHeight/2+graphHeight/2);
        if(i<700)
        {
            drawBuffer[counterJawn] = (drawBuffer[i]*graphHeight/2/2+graphHeight/2);//shitty
        }
        else
        {
            drawBuffer[counterJawn] = drawBuffer[counterJawn-graphWidth/3];
        }
        counterJawn++;
    }
    [audioDraw setWaveform:drawBuffer arraySize:graphWidth];
    [self drawFFT];
}

-(void) drawFFT {
    
    if (isRunning) {
        for (int i = 0;i<graphWidth;i++) {
            fftBuffer[i] = audioBuffer[i];
            fftBuffer[i+1] = 0;
        }
        fftCalled = YES;
    } else {
        free(audioBuffer);
        audioBuffer = (float*)calloc(graphWidth, sizeof(float));
        for (int i = 0;i<graphWidth;i++) {
            fftBuffer[i] = 0;
            for (int j = 0;j<numSliders-1;j++) {
                fftBuffer[i] += [[sliderAmplitudes objectAtIndex:j] floatValue]*sin(theta*(j+1));
            }
            fftBuffer[i] += randomFloat((-1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue], (1.0)*[[sliderAmplitudes objectAtIndex:(numSliders-1)] floatValue]);
            theta += thetaIncrement;
            if (theta > 2*M_PI) {
                theta -= 2*M_PI;
            }
            fftBuffer[i+1] = 0;
        }  
    }
    [fft forwardWithStart:0 withBuffer:fftBuffer magnitude:fftMag phase:fftPhase useWinsow:NO];
//    [spectrumDraw plotValues:fftMag arraySize:kFFTSize/2];
    
    int minIndex = floor(minFrequency/((kOutputSampleRate/2.0)/(kFFTSize/2.0)));
    int maxIndex = floor(maxFrequency/((kOutputSampleRate/2.0)/(kFFTSize/2.0)));
    
    free(specBuffer);
    int newSize = maxIndex-minIndex+2;
    specBuffer = (float*)calloc(newSize, sizeof(float));
    minPlottedFreq = minIndex*(kOutputSampleRate/(kFFTSize/2.0));
    maxPlottedFreq = maxIndex*(kOutputSampleRate/(kFFTSize/2.0));
    
    int count = 0;
    for (int i = minIndex;i<=maxIndex;i++){
        specBuffer[count] = fftMag[i];
        count++;
    }
    [spectrumDraw plotValues:specBuffer arraySize:newSize];
}

-(void) drawingEnded {
    
} 


-(void) updateSpectrumLabels {
    
}

-(IBAction)timeEnvelopePressed:(id)sender {
    [timePopover presentPopoverFromRect:timeEnvelopeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)frequencyEnvelopePressed:(id)sender {
    [frequencyPopover presentPopoverFromRect:freqEnvelopeButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) timeEnvelopeDonePressed {
    [timePopover dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:timePopover];
}

-(void) freqEnvelopeDonePressed {
    [frequencyPopover dismissPopoverAnimated:YES];
    [self popoverControllerDidDismissPopover:frequencyPopover];
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popoverController == timePopover) {
        [self newTimeEnvelope];
    } else if (popoverController == frequencyPopover) {
        [self processFrequencyEnvelope];
    }
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
    NSMutableArray *sliderValues = [[NSMutableArray alloc] init];
    [MatlabFunctions linspace:0 max:graphWidth numElements:numSliders array:indices];
    float val;
    int count;
    for (int i = 1;i<numSliders;i++) {
        val = 0;
        count = 0;
        for (int j = indices[i-1];j<indices[i];j++) {
            val += drawnFrequencyEnvelope[j];
            count++;
        }
        [sliderValues addObject:[NSNumber numberWithFloat:(val/(float)count)]];
        [sliderAmplitudes replaceObjectAtIndex:(i-1) withObject:[NSNumber numberWithFloat:(val/(float)count)]];
        
        //SHITTY ADD
        if((i-1)<10)
        {
            [[spectrumHandles objectAtIndex:(i-1)] setAmplitude:(1-(val/(float)count))];
            
        }
        
    }
    [self setSliderValues:sliderValues];
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
    [self updateAudioWaveform];
}



//Shitty ADD
-(void)timerFired:(NSTimer *) theTimer
{    
    //190-NSLog(@"timerFired @ %@", [theTimer fireDate]);
    NSMutableArray *sliderValues = [[NSMutableArray alloc] init];
    for(int i = 0; i<[spectrumHandles count];i++)
    {
        float tempJawn = [[spectrumHandles objectAtIndex:i] getGainVal];
        
        [[impulseHandles objectAtIndex:i] setAmplitude:tempJawn];
        [sliderValues addObject:[NSNumber numberWithFloat:tempJawn]];
        [sliderAmplitudes replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:tempJawn]];
        
    }
    [self setSliderValues:sliderValues];
}


@end
