//
//  DrawingViewController.h
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

@protocol DrawingViewDelegate <NSObject>

@optional

-(void) drawingViewDone;

@end

@interface DrawingViewController : UIViewController {
    
    float *pointValues;
    IBOutlet DrawView *drawView;
    id <DrawingViewDelegate> delegate;
}

@property id <DrawingViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet DrawView *drawView;

-(IBAction)clearPressed:(id)sender;

-(IBAction)donePressed:(id)sender;

@end
