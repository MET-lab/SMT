//
//  SpectrumPoint.m
//  AcousticSynthesis
//
//  Created by Matthew Prockup on 6/30/13.
//  Copyright (c) 2013 Drexel University. All rights reserved.
//

#import "SpectrumPoint.h"

@implementation SpectrumPoint

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //make a damn dot in the view
        UIImageView* imageDotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotJawnBig.png"]];
        [imageDotView setFrame:CGRectMake(0,0,self.frame.size.width, frame.size.height)];
        [self addSubview:imageDotView];
    }
    return self;
}

-(void)setIdNum:(int)idIn
{
    idNum = idIn;
}


-(void)setAmplitude:(float)amp
{
    gainVal = 1-amp;
    int maxHeight = self.superview.frame.size.height;
    int x = self.frame.origin.x;
    int y = self.frame.origin.y;
    int w = self.frame.size.width;
    int h = self.frame.size.height;
    int newY = maxHeight*amp-15;
    [self setFrame:CGRectMake(x, newY, w, h)];
}

-(float) getGainVal
{
    return gainVal;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Began: %d", idNum);
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Moved: %d", idNum);
    int maxHeight = self.superview.frame.size.height;
    int x = self.frame.origin.x;
    int y = self.frame.origin.y;
    int w = self.frame.size.width;
    int h = self.frame.size.height;
    
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self.superview];
    NSLog(@"Y Location: %f",point.y);
    int newY = point.y-15;
    if((point.y > 0) && point.y<=(maxHeight))
    {
        [self setFrame:CGRectMake(x, newY, w, h)];
        gainVal = 1.0 - (((float)newY)+ 16.0) /((float)maxHeight);
    }
    
    
    
    
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
