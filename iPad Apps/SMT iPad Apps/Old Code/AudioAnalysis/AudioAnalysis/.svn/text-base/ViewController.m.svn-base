//
//  ViewController.m
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize gainSlider, gainLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    audioInput = [[AudioInput alloc] initWithDelegate:self];
    [audioInput start];
    [grapher setYStartPoint:374];
    counter = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) processInputBuffer:(float *)buffer numSamples:(int)numSamples {
        

//        for (int i = 100;i<105;i++) {
//            printf("%f ",buffer[i]);
//        }
    counter++;
    float *xBuffer = (float*)malloc(sizeof(float)*numSamples);
    for (int i = 0;i<numSamples;i++) {
        xBuffer[i] = i;
    }
    [grapher plotY:buffer withX:xBuffer arraySize:numSamples];
    free(xBuffer);


}

-(void) gainChanged:(id)sender {
    [gainLabel setText:[NSString stringWithFormat:@"%.0f",[gainSlider value]]];
    [grapher setGain:[gainSlider value]];
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

@end
