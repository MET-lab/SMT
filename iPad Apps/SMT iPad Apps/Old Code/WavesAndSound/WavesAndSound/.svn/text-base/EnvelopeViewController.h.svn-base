//
//  EnvelopeViewController.h
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvelopeView.h"
@protocol EnvelopeControllerDelegate <NSObject>

@optional

-(void) envelopeDone;


@end

@interface EnvelopeViewController : UIViewController {
    
    
    id <EnvelopeControllerDelegate> delegate;
    IBOutlet EnvelopeView *envelopeView;
    float *pointValues;
    
}

@property id <EnvelopeControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet EnvelopeView *envelopeView;

-(IBAction)clearPressed:(id)sender;

-(IBAction)donePressed:(id)sender;


@end
