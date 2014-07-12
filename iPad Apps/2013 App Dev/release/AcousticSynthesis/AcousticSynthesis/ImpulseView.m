//
//  ImpulseView.m
//  AcousticSynthesis
//
//  Created by Matthew Prockup on 7/7/13.
//  Copyright (c) 2013 Drexel University. All rights reserved.
//

#import "ImpulseView.h"

@implementation ImpulseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //make a impulse in the view
        [self setBackgroundColor:[UIColor blueColor]];
        
    }
    return self;
}

-(void)setIdNum:(int)idIn
{
    idNum = idIn;
}


-(void)setAmplitude:(float)amp
{
    gainVal = amp;
    int maxHeight = self.superview.frame.size.height;
    int x = self.frame.origin.x;
    int y = self.frame.origin.y;
    int w = self.frame.size.width;
    int h = self.frame.size.height;
    int newY = maxHeight-maxHeight*amp;
    [self setFrame:CGRectMake(x, newY, w, maxHeight-newY)];
}

-(float) getGainVal
{
    return gainVal;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
