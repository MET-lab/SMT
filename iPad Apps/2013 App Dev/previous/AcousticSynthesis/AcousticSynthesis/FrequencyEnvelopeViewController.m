//
//  FrequencyEnvelopeViewController.m
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/6/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "FrequencyEnvelopeViewController.h"

@interface FrequencyEnvelopeViewController ()

@end

@implementation FrequencyEnvelopeViewController
@synthesize delegate, envelopeDraw, baseFrequency;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    baseFrequency = 440;
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 706, 306)];
    [background setImage:[UIImage imageNamed:@"specGrid.png"]];
    [self.view addSubview:background];
    envelopeDraw = [[EnvelopeView alloc] initWithFrame:CGRectMake(0, 0, 700, 306)];
    [envelopeDraw setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:envelopeDraw];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/4.0);
    for (int i = 0;i<=8;i++) {
        UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake((i-1)*78+80, 265, 40,30)];
        graphFreqLabel.text = [NSString stringWithFormat:@"%.0f",(i+1)*baseFrequency];
        graphFreqLabel.textColor = [UIColor grayColor];
        graphFreqLabel.alpha = 0.6;
        graphFreqLabel.backgroundColor = [UIColor clearColor];
        graphFreqLabel.tag = (i)+1000;
        graphFreqLabel.font = [UIFont systemFontOfSize:12];
        graphFreqLabel.transform = rotate;
        [self.view addSubview:graphFreqLabel];
        
    }
    
    UILabel *graphFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(650, 280, 100,30)];
    graphFreqLabel.text = @"Frequency (Hz)";
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
    
    
    return self;
}

-(void) updateFrequencyLabels {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
             if ([subView tag] >= 1000 && [subView tag] < 1010) {
                UILabel *tempLabel = (UILabel*)subView;
                tempLabel.text = [NSString stringWithFormat:@"%.0f",(tempLabel.tag-1000+1)*baseFrequency];
            }
        }
    }
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
    if ([delegate respondsToSelector:@selector(freqEnvelopeDonePressed)]) {
        [delegate freqEnvelopeDonePressed];
    }
    
}

@end
