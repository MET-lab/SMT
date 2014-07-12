//
//  TimeEnvelopeViewController.h
//  AcousticSynthesis
//
//  Created by Matthew Zimmerman on 7/5/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvelopeView.h"
#import "MathFunctions.h"

@protocol TimeEnvelopeDelegate <NSObject>

@optional

-(void) timeEnvelopeDonePressed;

@end

@interface TimeEnvelopeViewController : UIViewController {
    
    EnvelopeView *envelopeDraw;
    
    id <TimeEnvelopeDelegate> delegate;
    
}

@property id <TimeEnvelopeDelegate> delegate;
@property (strong, nonatomic) EnvelopeView *envelopeDraw;

-(IBAction)resetPressed:(id)sender;

-(IBAction)donePressed:(id)sender;
@end
