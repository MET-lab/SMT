//
//  ImpulseView.h
//  AcousticSynthesis
//
//  Created by Matthew Prockup on 7/7/13.
//  Copyright (c) 2013 Drexel University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImpulseView : UIView
{
    float gainVal;
    float xPos;
    float yPos;
    int idNum;
}
-(void)setAmplitude:(float)amp;
-(void)setIdNum:(int)idIn;
-(float) getGainVal;

@end
