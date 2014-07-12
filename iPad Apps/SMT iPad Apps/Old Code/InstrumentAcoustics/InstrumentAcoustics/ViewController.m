//
//  ViewController.m
//  InstrumentAcoustics
//
//  Created by Matthew Zimmerman on 6/20/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "ViewController.h"
#import "AudioOutput.h"
#import <AudioUnit/AudioUnit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   AudioOutput *output = [[AudioOutput alloc] init];
    
    output = nil;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
