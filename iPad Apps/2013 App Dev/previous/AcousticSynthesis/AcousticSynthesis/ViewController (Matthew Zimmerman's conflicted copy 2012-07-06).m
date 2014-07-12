//
//  ViewController.m
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/4/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    baseFrequency = 440;
    
    numSliders = 10;
    sliders = [[NSMutableArray alloc] init];
    sliderAmplitudes = [[NSMutableArray alloc] init];
    harmonicLabels = [[NSMutableArray alloc] init];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    for (int i = 1; i<=numSliders; i++) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(i*75-112, 720, 166, 23)];
        [slider setTag:i];
        if (i==1) {
            [slider setValue:1];
        } else {
            [slider setValue:0];
        }
        [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slider];
        slider.transform = trans;
        [sliders addObject:slider];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*75-62, 810, 70, 24)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%.2f",slider.value];
        label.backgroundColor = [UIColor clearColor];
        [label setTag:i];
        [self.view addSubview:label];
        [harmonicLabels addObject:label];
        [sliderAmplitudes addObject:[NSNumber numberWithFloat:[slider value]]];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)sliderChanged:(id)sender {
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            if ([subView tag] == [sender tag]) {
                UILabel *tempLabel = (UILabel*)subView;
                UISlider *tempSlider = (UISlider*)sender;
                tempLabel.text = [NSString stringWithFormat:@"%.2f",[tempSlider value]];
                [sliderAmplitudes replaceObjectAtIndex:([subView tag]-1) withObject:[NSNumber numberWithFloat:[tempSlider value]]];
                break;
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(IBAction)playPressed:(id)sender {
    
    
}

-(IBAction)stopPressed:(id)sender {
    
    
}

-(IBAction)resetPressed:(id)sender {
    
}

-(IBAction)freqSliderChanged:(id)sender {
    
    baseFrequency = [freqSlider value];
    freqLabel.text = [NSString stringWithFormat:@"%.1f",baseFrequency];
    
    
}

-(IBAction)harmonicSliderChanged:(id)sender {
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
