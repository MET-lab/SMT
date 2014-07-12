//
//  TimeEnvelopeViewController.m
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/5/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "TimeEnvelopeViewController.h"

@interface TimeEnvelopeViewController ()

@end

@implementation TimeEnvelopeViewController
@synthesize delegate, envelopeDraw;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 706, 306)];
    [background setImage:[UIImage imageNamed:@"specGrid.png"]];
    [self.view addSubview:background];
    envelopeDraw = [[EnvelopeView alloc] initWithFrame:CGRectMake(0, 0, 700, 306)];
    [envelopeDraw setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:envelopeDraw];

    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 1;i<=8;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake((i-1)*78+80, 265, 40,30)];
        graphFreqLabel.text = [NSString stringWithFormat:@"%.2f",(i/9.0)*3.0];
        graphFreqLabel.textColor = [UIColor grayColor];
        graphFreqLabel.alpha = 0.6;
        graphFreqLabel.backgroundColor = [UIColor clearColor];
        graphFreqLabel.tag = (i)+1000;
        graphFreqLabel.font = [UIFont systemFontOfSize:12];
        graphFreqLabel.transform = rotate;
        [self.view addSubview:graphFreqLabel];
    }
    
    UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(650, 280, 100,30)];
    graphFreqLabel.text = @"Time (s)";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:graphFreqLabel];
    
    graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100,30)];
    graphFreqLabel.text = @"Amplitude";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:graphFreqLabel];
    
    
    graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 18, 100,30)];
    graphFreqLabel.text = @"0.75";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    graphFreqLabel.transform = rotate;
    [self.view addSubview:graphFreqLabel];
    
    graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 95, 100,30)];
    graphFreqLabel.text = @"0.5";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    graphFreqLabel.transform = rotate;
    [self.view addSubview:graphFreqLabel];
    
    graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 170, 100,30)];
    graphFreqLabel.text = @"0.25";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    graphFreqLabel.transform = rotate;
    [self.view addSubview:graphFreqLabel];
    
    graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(-10, 247, 100,30)];
    graphFreqLabel.text = @"0";
    graphFreqLabel.textColor = [UIColor grayColor];
    graphFreqLabel.alpha = 0.6;
    graphFreqLabel.backgroundColor = [UIColor clearColor];
    graphFreqLabel.font = [UIFont systemFontOfSize:12];
    graphFreqLabel.transform = rotate;
    [self.view addSubview:graphFreqLabel];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)resetPressed:(id)sender {
    [envelopeDraw resetDrawing];
}

-(IBAction)donePressed:(id)sender {
    if ([delegate respondsToSelector:@selector(timeEnvelopeDonePressed)]) {
        [delegate timeEnvelopeDonePressed];
    }
}



@end
