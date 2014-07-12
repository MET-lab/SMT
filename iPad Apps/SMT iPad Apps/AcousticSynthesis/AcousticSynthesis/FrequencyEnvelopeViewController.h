//
//  FrequencyEnvelopeViewController.h
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/6/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvelopeView.h"

@protocol FrequencyEnvelopeDelegate <NSObject>

@optional

-(void) freqEnvelopeDonePressed;

@end

@interface FrequencyEnvelopeViewController : UIViewController {
    EnvelopeView *envelopeDraw;
    id <FrequencyEnvelopeDelegate> delegate;
    float baseFrequency;
}

@property id <FrequencyEnvelopeDelegate> delegate;
@property (strong, nonatomic) EnvelopeView *envelopeDraw;
@property float baseFrequency;

-(IBAction)resetPressed:(id)sender;

-(IBAction)donePressed:(id)sender;

-(void) updateFrequencyLabels;

@end