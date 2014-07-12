//
//  EnvelopeViewController.m
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnvelopeViewController.h"

@interface EnvelopeViewController ()

@end

@implementation EnvelopeViewController
@synthesize delegate, envelopeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)clearPressed:(id)sender {
    [envelopeView clearDrawing];
}

-(IBAction)donePressed:(id)sender {
    NSLog(@"done pressed");
    if ([delegate respondsToSelector:@selector(envelopeDone)]) {
        [delegate envelopeDone];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
