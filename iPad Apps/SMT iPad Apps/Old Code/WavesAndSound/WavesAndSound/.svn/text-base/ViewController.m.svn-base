//
//  ViewController.m
//  WavesAndSound
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


#define kFFTSize 1024

@interface ViewController ()

@end



@implementation ViewController

int nextPow2(int num){
    int count = 1;
    while (pow(2, count)<num) {
        count++;
    }
    return (int)pow(2, count);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [waveDraw setDelegate:self];
    numSliders = 10;
    ampArray = [[NSMutableArray alloc] init];
    baseFrequency = 100;
    audioOut = [[AudioOutput alloc] initWithDelegate:self];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    for (int i = 1; i<=numSliders; i++) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(i*70-85, 770, 166, 23)];
        [slider setTag:i];
        if (i==1) {
            [slider setValue:1];
        } else {
            [slider setValue:0];
        }
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slider];
        slider.transform = trans;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*70-20, 875, 40, 24)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%.2f",slider.value];
        label.backgroundColor = [UIColor clearColor];
        [label setTag:i];
        [self.view addSubview:label];
        [ampArray addObject:[NSNumber numberWithFloat:[slider value]]];
    }
	// Do any additional setup after loading the view, typically from a nib.
    sampleIndices = (float*)calloc(waveDraw.frame.size.width, sizeof(float));
//    waveForm = (float*)calloc(waveDraw.frame.size.width, sizeof(float));
    [waveDraw interpolateFullFrame];
    waveForm = [waveDraw getWaveform];
    fft = [[SimpleFFT alloc] init];
    [fft fftSetSize:kFFTSize];
    fftAudio = (float*)malloc(2*waveDraw.frame.size.width*sizeof(float));
    fftMag = (float*)malloc(2*kFFTSize*sizeof(float));
    fftPhase = (float*)malloc(2*kFFTSize*sizeof(float));
    
    [audioOut startOutput];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)sliderChanged:(id)sender {
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] == [sender tag]) {
                UILabel *tempLabel = (UILabel*)subView;
                UISlider *tempSlider = (UISlider*)sender;
                tempLabel.text = [NSString stringWithFormat:@"%.2f",[tempSlider value]];
                [ampArray replaceObjectAtIndex:([subView tag]-1) withObject:[NSNumber numberWithFloat:[tempSlider value]]];
                break;
            }
        }
    }
    
    float angle = 0;
    float *newWave = (float*)malloc(sizeof(float)*waveDraw.frame.size.width);
    float angleIncrement = 2*M_PI/(int)waveDraw.frame.size.width;
    for (int i = 0;i<=waveDraw.frame.size.width;i++) {
        newWave[i] = 0;
        for (int j = 1;j<=numSliders;j++) {
            newWave[i] += -sin(angle*j)*[[ampArray objectAtIndex:(j-1)] floatValue];
        }
        angle+=angleIncrement;
    }
    [FloatFunctions normalize:newWave numElements:waveDraw.frame.size.width];
    for (int i = 0;i<waveDraw.frame.size.width;i++) {
        newWave[i] *= waveDraw.frame.size.height/2;
        newWave[i] += waveDraw.frame.size.height/2;
    }
    [waveDraw setWaveform:newWave arraySize:waveDraw.frame.size.width];
}

-(IBAction)freqSliderChanged:(id)sender {
    freqLabel.text = [NSString stringWithFormat:@"%.1f",[freqSlider value]];
    baseFrequency = [freqSlider value];
    [self createNewSampleIndices];
    [self getFFTBounds];
}


-(void) createNewSampleIndices {
    
    int numSamples = (int)roundf(kOutputSampleRate/baseFrequency);
    [MatlabFunctions linspace:0 max:waveDraw.frame.size.width numElements:numSamples array:sampleIndices];
    //    [FloatFunctions round:sampleIndices numElements:bufferSize];
    
}

-(void) drawViewChanged {
    for (int i = 0;i<waveDraw.frame.size.width;i++) {
        fftAudio[2*i] = waveForm[i];
        fftAudio[2*i+1] = 0;
    }
    [fft fftSetSize:kFFTSize];
    [fft forwardWithStart:0 withBuffer:fftAudio magnitude:fftMag phase:fftPhase useWinsow:NO];
    
    
    if  (counter == 100) {
        for (int i = 0;i<kFFTSize/4;i++) {
            printf("%f ",fftMag[i]);
        }
        
    }
    counter++;
}


-(void) getFFTBounds {
    
    int size = kFFTSize/4;
    float *spacings = (float*)malloc(sizeof(float)*size);
    [MatlabFunctions linspace:0 max:kOutputSampleRate numElements:size array:spacings];
    
    int i = 0;
    while (spacings[i] < baseFrequency) {
        i++;
    }
    fftLowerIndex = i;
    while (spacings[i] <baseFrequency*10) {
        i++;
    }
    fftUpperIndex = i;
    NSLog(@"%i,%i",fftLowerIndex,fftUpperIndex);
    free(spacings);
}

-(void) resetWaveformPressed:(id)sender {
    [waveDraw resetDrawing];
}

-(void) AudioDataToOutput:(float *)buffer bufferLength:(int)bufferSize {
    
    float theta_increment = 2.0 * M_PI * baseFrequency / kOutputSampleRate;
    for (int i = 0;i<bufferSize;i++) {
        buffer[i] = 0;                                          
        for (int j = 1;j<=numSliders;j++) {
            buffer[i]  += sin(j*theta)*[[ampArray objectAtIndex:(j-1)] floatValue];
        }
        theta += theta_increment;
        if (theta > 2*M_PI) {
            theta -= 2.0 * M_PI;
        }
    }
}

@end
