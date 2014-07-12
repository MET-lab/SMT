//
//  SpectrumView.m
//  CannonDriver
//
//  Created by Matthew Zimmerman on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpectrumView.h"
#import "MathFunctions.h"

//@implementation SpectrumPoint
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        //make a damn dot in the view
//        UIImageView* imageDotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotJawn.png"]];
//        [imageDotView setFrame:CGRectMake(0,0,self.frame.size.width, frame.size.height)];
//        [self addSubview:imageDotView];
//    }
//    return self;
//}
//
//-(void)setIdNum:(int)idIn
//{
//    idNum = idIn;
//}
//
//
//-(void)setAmplitude:(float)amp
//{
//    gainVal = 1-amp;
//    int maxHeight = self.superview.frame.size.height;
//    int x = self.frame.origin.x;
//    int y = self.frame.origin.y;
//    int w = self.frame.size.width;
//    int h = self.frame.size.height;
//    int newY = maxHeight*amp-15;
//    
//    
//    [self setFrame:CGRectMake(x, newY, w, h)];
//}
//
//-(float) getGainVal
//{
//    return gainVal;
//    
//}
//
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Began: %d", idNum);
//}
//- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"Moved: %d", idNum);
//    int maxHeight = self.superview.frame.size.height;
//    int x = self.frame.origin.x;
//    int y = self.frame.origin.y;
//    int w = self.frame.size.width;
//    int h = self.frame.size.height;
//    
//    UITouch *touch = [touches anyObject];
//    
//    // Get the specific point that was touched
//    CGPoint point = [touch locationInView:self.superview];
//    NSLog(@"Y Location: %f",point.y);
//    int newY = point.y-15;
//    if((point.y > 0) && point.y<=(maxHeight))
//    {
//        [self setFrame:CGRectMake(x, newY, w, h)];
//        gainVal = 1.0 - (((float)newY)+ 16.0) /((float)maxHeight);
//    }
//}
//@end
//
// ======================================================================================= //

@implementation SpectrumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// ===================== Original ===================== //

//-(id) initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        indexValues = (float*)calloc(self.frame.size.width, sizeof(float));
//        pointValues = (float*)calloc(self.frame.size.width, sizeof(float));
//        numPoints = self.frame.size.width;
//        [self setBackgroundColor:[UIColor clearColor]];
//    }
//    return self;
//}


//-(void) plotValues:(float *)array arraySize:(int)size {
//    
//    numPoints = size;
//    [MatlabFunctions linspace:0 max:self.frame.size.width numElements:numPoints array:indexValues];
//    for (int i = 0;i<numPoints;i++) {
//        pointValues[i] = array[i];
//    }
//    [FloatFunctions normalize:pointValues numElements:numPoints];
//    for (int i = 0;i<numPoints;i++) {
//        pointValues[i] = -pointValues[i]*self.frame.size.height+self.frame.size.height;
////        printf("%f ",pointValues[i]);
//    }
////    printf("\n\n");
//    
//    [self setNeedsDisplay];
//}
//
//-(void) drawRect:(CGRect)rect {
////    NSLog(@"drawing");
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1.0);
//    CGPoint prevPoint = CGPointMake(0, self.frame.size.height);
//    for (int i = 0;i<numPoints;i++) {
//            CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
//            CGContextAddLineToPoint(context,indexValues[i],pointValues[i]);
//            prevPoint = CGPointMake(indexValues[i], pointValues[i]);
//            CGContextStrokePath(context);
//    }
//    CGContextMoveToPoint(context,prevPoint.x,prevPoint.y);
//    CGContextAddLineToPoint(context,self.frame.size.width ,self.frame.size.height);
//    CGContextStrokePath(context);
//}


// ===================== NSMutableArray ===================== //

//-(id) initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super initWithCoder:aDecoder];
//    
//    indexValues = (float*)calloc(self.frame.size.width, sizeof(float));         // ??
//    
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self setNeedsDisplay];
//    
//    nWaveforms = 0;
//    plotBuffer = [[NSMutableArray alloc] init];
//    plotColors = [[NSMutableArray alloc] init];
//    
//    yLim = 1.0;
//    pixelQuant = (2*yLim) / self.frame.size.height;
//    
//    // Computer the bounds of the object
//    upperLeft.x = self.frame.origin.x;
//    upperLeft.y = self.frame.origin.y;
//    
//    frameSize = self.bounds.size;
//    
//    lowerRight.x = upperLeft.x + frameSize.width;
//    lowerRight.y = upperLeft.y + frameSize.height;
//    
//    return self;
//}

///* Draw the current waveforms within the passed-in rectangle */
//-(void) drawRect:(CGRect)rect {
//    
//    // Grab the current context and set the line width to 1.0
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1.0);
//    
//    // Keep $nWaveforms$ previous points for each waveform
//    NSMutableArray *previous = [[NSMutableArray alloc] init];
//    
//    for(int n = 0; n < nWaveforms; n++) {
//        CGPoint pPoint  = CGPointMake(0, [[plotBuffer[n] objectAtIndex:0] floatValue]);
//        
//        // CGPoint is a C struct, so it must be converted to an NSValue to store in the array
//        NSValue *pValue = [NSValue valueWithCGPoint:pPoint];
//        [previous addObject:pValue];
//    }
//    
//    // For each buffer index, append a line from the previous point to the current point for each waveform
//    for (int m = 1; m <= numPoints; m++) {
//        for( int n = 0; n < nWaveforms; n++) {
//            
////            printf("buffer[%3d][%d] = %1.3f\n", m, n, [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            
//            CGContextBeginPath(context);
//            
//            // Set the color for this waveform
//            UIColor *color = [plotColors objectAtIndex:n];
//            CGContextSetStrokeColorWithColor(context, color.CGColor);
//            
//            // Append line from previous point to current point
//            CGContextMoveToPoint(context, [previous[n] CGPointValue].x , [previous[n] CGPointValue].y);
//            CGContextAddLineToPoint(context, indexValues[m], [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            
//            // Make the current point and convert to NSValue
//            CGPoint  cnt = CGPointMake(indexValues[m], [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            NSValue *val = [NSValue valueWithCGPoint:cnt];
//            
//            // Current point becomes the previous point
//            [previous replaceObjectAtIndex:n withObject:val];
//            
//            // Draw
//            CGContextStrokePath(context);
//        }
//    }
//}
//
//-(void) addWaveform:(float*)pWaveform length:(int)pLength color:(UIColor*)pColor {
//    
//    @try {
//        
//        numPoints = pLength;
//        
//        // Create a new row for this waveform
//        NSMutableArray *newRow = [[NSMutableArray alloc] init];
//        
//        // Add the waveform to the row, scaling on the way in
//        for(int m = 0; m <= pLength; m++)
//            [newRow addObject:[NSNumber numberWithFloat:self.frame.size.height - pWaveform[m]]];
//        
//        // Add the new row and its color to the plot buffer
//        [plotBuffer addObject:newRow];
//        [plotColors addObject:pColor];
//        
//        [self setNeedsDisplay];
//        
//        nWaveforms++;
//        
//        printf("nWaveforms = %d\n", nWaveforms);
//    }
//    
//    @catch (NSException *e) {
//        NSLog(@"DrawView.addWaveform():Exception: %@\n", e);
//    }
//}
//
//-(void) setWaveform:(float*)pWaveform length:(int)pLength index:(int)pIdx {
//    
//    @try {
//        
//        numPoints = pLength;
//        
//        [MatlabFunctions linspace:0 max:self.frame.size.width numElements:pLength array:indexValues];
//        
//        // Replace the contents of the plot buffer with the updated waveform
//        for(int m = 0; m < pLength; m++) {
//            
//            [plotBuffer[pIdx] replaceObjectAtIndex:m withObject:[NSNumber numberWithFloat:self.frame.size.height - pWaveform[m]]];
//        }
//        
//        [self setNeedsDisplay];
//    }
//    
//    @catch (NSException *e) {
//        NSLog(@"DrawView.setWaveform():Exception: %@\n", e);
//    }
//}

// ===================== Float Arrays ===================== //

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    drySpec = (float*)calloc(self.frame.size.width, sizeof(float));
    wetSpec = (float*)calloc(self.frame.size.width, sizeof(float));
    filter  = (float*)calloc(self.frame.size.width, sizeof(float));
    freqz   = (float*)calloc(self.frame.size.width, sizeof(float));
    
    filterDrawEnabled = true;
    
    yLim = 1.0;
    pixelQuant = (2*yLim) / self.frame.size.height;
        
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];

    // Computer the bounds of the object
    upperLeft.x = self.frame.origin.x;
    upperLeft.y = self.frame.origin.y;

    frameSize = self.bounds.size;

    lowerRight.x = upperLeft.x + frameSize.width;
    lowerRight.y = upperLeft.y + frameSize.height;
    
    return self;
}

-(void) drawRect:(CGRect)rect {
    
    // Grab the current context and set the line width to 1.0
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    // Keep track of previous point for line drawing
    CGPoint previous = CGPointMake(0, drySpec[0]);
    
    // Append a line from the previous point to the current point and draw
    for (int m = 1; m <= plotLength; m++) {
        
        CGContextBeginPath(context);
        
        // Plot the dry spectrum in black
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        
        // Append line from previous point to current point
        CGContextMoveToPoint(context, previous.x , previous.y);
        CGContextAddLineToPoint(context, freqz[m], drySpec[m]);
        
        // Current point becomes the previous point
        previous = CGPointMake(freqz[m], drySpec[m]);
        
        // Draw
        CGContextStrokePath(context);
    }
    
    previous = CGPointMake(0, wetSpec[0]);
    
    // Append a line from the previous point to the current point and draw
    for (int m = 1; m <= plotLength; m++) {
        
        CGContextBeginPath(context);
        
        // Plot the dry spectrum in black
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
        
        // Append line from previous point to current point
        CGContextMoveToPoint(context, previous.x , previous.y);
        CGContextAddLineToPoint(context, freqz[m], wetSpec[m]);
        
        // Current point becomes the previous point
        previous = CGPointMake(freqz[m], wetSpec[m]);
        
        // Draw
        CGContextStrokePath(context);
    }
    
    
    if(filterDrawEnabled) {
        
        previous = CGPointMake(0, filter[0]);
        
        // Append a line from the previous point to the current point and draw
        for (int m = 1; m <= plotLength-1; m++) {
            
    //        printf("idx[%3d] = %1.2f\n", m, freqz[m]);
            
            CGContextBeginPath(context);
            
            // Plot the dry spectrum in black
            CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
            
            // Append line from previous point to current point
            CGContextMoveToPoint(context, previous.x , previous.y);
            CGContextAddLineToPoint(context, freqz[m], filter[m]);
            
            // Current point becomes the previous point
            previous = CGPointMake(freqz[m], filter[m]);
            
            // Draw
            CGContextStrokePath(context);
        }
    }
}

-(void) setDrySpec:(float *)pWaveform length:(int)pLength {
    
//    plotLength = pLength;
//    [MatlabFunctions linspace:0 max:self.frame.size.width numElements:pLength array:freqz];
    
    for(int m = 0; m < self.frame.size.width; m++)
        drySpec[m] = self.frame.size.height - pWaveform[m];
    
    [self setNeedsDisplay];
}

-(void) setWetSpec:(float *)pWaveform length:(int)pLength {
    
    for(int m = 0; m < self.frame.size.width; m++)
        wetSpec[m] = self.frame.size.height - pWaveform[m];
    
    [self setNeedsDisplay];
}

-(void) setFilterCurve:(float *)pFilterCurve length:(int)pLength {
    
    for(int m = 0; m < self.frame.size.width; m++)
        filter[m] = self.frame.size.height - pFilterCurve[m];
    
    [self setNeedsDisplay];
}

-(void) setFreqzLinspace:(int)pLength {

    plotLength = pLength;    
    [MatlabFunctions linspace:0 max:self.frame.size.width numElements:pLength array:freqz];
}


@end
