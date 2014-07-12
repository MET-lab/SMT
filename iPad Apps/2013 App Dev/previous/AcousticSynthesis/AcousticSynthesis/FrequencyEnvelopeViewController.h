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

@property (nonatomic, strong) id <FrequencyEnvelopeDelegate> delegate;
@property (nonatomic, strong) EnvelopeView *envelopeDraw;
@property float baseFrequency;

-(IBAction)resetPressed:(id)sender;

-(IBAction)donePressed:(id)sender;

-(void) updateFrequencyLabels;

@end