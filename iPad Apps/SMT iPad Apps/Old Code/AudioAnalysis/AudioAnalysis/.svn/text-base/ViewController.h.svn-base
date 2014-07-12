//
//  ViewController.h
//  AudioAnalysis
//
//  Created by Matthew Zimmerman on 6/23/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioInput.h"
#import "GraphView.h"
@interface ViewController : UIViewController <AudioInputDelegate> {
    
    AudioInput *audioInput;
    IBOutlet GraphView *grapher;
    int counter;
    
}

@property (strong, nonatomic) IBOutlet UISlider *gainSlider;
@property (strong, nonatomic) IBOutlet UILabel *gainLabel;

-(IBAction)gainChanged:(id)sender;

@end
