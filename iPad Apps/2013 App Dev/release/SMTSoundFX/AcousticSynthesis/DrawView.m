//
//  DrawView.m
//  SoundBuilder
//
//  Created by Matthew Zimmerman on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
//@synthesize values, drawEnabled;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    
    if (self) {
        // Initialization code
    }
    return self;
}

//-(id) initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//
//    drawEnabled = YES;
//    
//    mainPlot = (float*)calloc(self.frame.size.width, sizeof(float));
//    auxPlot = (float*)calloc(self.frame.size.width, sizeof(float));
//    
//    fullValues = (float*)calloc(self.frame.size.width, sizeof(float));
//    scaledValues = (float*)calloc(self.frame.size.width, sizeof(float));
//    mainSet = (int*)calloc(self.frame.size.width, sizeof(int));
//    auxSet = (int*)calloc(self.frame.size.width, sizeof(int));
//    
//    counter = 0;
//    
//    [self zeroPlot];    // Start with nothing on the plot
//    
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self setNeedsDisplay];
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

//-(id) initWithCoder:(NSCoder *)aDecoder {
//    
//    self = [super initWithCoder:aDecoder];
//    drawEnabled = YES;
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
////    scaledBuffer = [[NSMutableArray alloc] init];
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

///* Initialize the plot buffer to zeros, with only one plot row */
//-(void) zeroPlot {
//    for (int i = 0; i < self.frame.size.width-1; i++) {
//        mainPlot[i] = 0;
//        auxPlot[i] = 0;
//        mainSet[i] = 1;
//        auxSet[i] = 1;
//    }
//    
//    // To Do: Multi plotting
//    // ===============
////    NSMutableArray *subBuffer = [[NSMutableArray alloc] init];
////    
////    for(int i = 0; i < self.frame.size.width; ++i) 
////        [subBuffer addObject:[NSNumber numberWithFloat:0.0]];        
//    // ===============
//    
//    [self setNeedsDisplay];
//    
//}

//-(void) resetDrawing {
//    mainPlot[0] = self.frame.size.height/2.0;
//    mainSet[0] = 1;
//    
//    for (int i = 1;i<self.frame.size.width-1;i++) {
//        mainPlot[i] = -sin(2*M_PI*i/self.frame.size.width)*self.frame.size.height/2.0+self.frame.size.height/2.0;
//        mainSet[i] = 1;
//    }
//    mainPlot[(int)self.frame.size.width-1] = self.frame.size.height/2;
//    mainSet[(int)self.frame.size.width-1] = 1;
//    [self setNeedsDisplay];
//}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (drawEnabled){
//        UITouch *touch = [touches anyObject];
//        CGPoint touchLocation = [touch locationInView:self];
//        previousLocation = touchLocation;
//    }
//    
//    if ([delegate respondsToSelector:@selector(drawingStarted)]) {
//        [delegate drawingStarted];
//    }
//}
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if (drawEnabled) {
//        UITouch *touch = [touches anyObject];
//        CGPoint touchLocation = [touch locationInView:self];
////        if (touchLocation.x < 0 || touchLocation.x >= self.frame.size.width ||
////            touchLocation.y < 0 || touchLocation.y >= self.frame.size.height) {
////            return;
////        }
//        
//        if (touchLocation.x >= 0 && touchLocation.x <= self.frame.size.width) {
//            if (touchLocation.y >= self.frame.size.height) {
//                mainPlot[(int)touchLocation.x] = self.frame.size.height;
//            } else if (touchLocation.y <= 0) {
//                mainPlot[(int)touchLocation.x] = 0;
//            } else {
//                mainPlot[(int)touchLocation.x] = touchLocation.y;
//            }
//            mainSet[(int)touchLocation.x] = 1;
//        }
//        
//        [self resetPointsBetween:previousLocation.x andEndIndex:touchLocation.x];
////        mainSet[(int)touchLocation.x] = 1;
////        mainPlot[(int)touchLocation.x] = touchLocation.y;
//        
//        [self setNeedsDisplay];
//        previousLocation = touchLocation;
//    }
//}

//-(void) resetPointsBetween:(int)startIndex andEndIndex:(int)endIndex {
//    int temp;
//    if (endIndex<startIndex) {
//        temp = startIndex;
//        startIndex = endIndex;
//        endIndex = temp;
//    }
//    for (int i = startIndex+1;i<endIndex;i++) {
//        if (mainSet[i] == 1) {
//            mainSet[i] = 0;
//            mainPlot[i] = 0;
//        }
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (drawEnabled) {
//        UITouch *touch = [touches anyObject];
//        CGPoint touchLocation = [touch locationInView:self];
//        previousLocation = touchLocation;
//    }
//    
//    if ([delegate respondsToSelector:@selector(drawingEnded)]) {
//        [delegate drawingEnded];
//    }
//}

//-(CGPoint) getPreviousSetPointFromIndex:(int)index {
//    
//    CGPoint point = CGPointMake(index, mainPlot[index]);
//    BOOL done = NO;
//    int i = index;
//    while (!done) {
//        if (i<=0) {
//            point = CGPointMake(0, mainPlot[0]);
//            done = YES;
//        } else {
//            if (mainSet[i]==1) {
//                point = CGPointMake(i, mainPlot[i]);
//                done = YES;
//            }
//        }
//        i--;
//    }
//    return point;
//}
//
//-(CGPoint) getNextSetPointFromIndex:(int)index {
//    CGPoint point = CGPointMake(index, mainPlot[index]);
//    BOOL done = NO;
//    int i = index;
//    while (!done) {
//        if (i>=self.frame.size.width) {
//            point = CGPointMake(self.frame.size.width-1, mainPlot[(int)self.frame.size.width-1]);
//            done = YES;
//        } else {
//            if (mainSet[i]==1) {
//                point = CGPointMake(i, mainPlot[i]);
//                done = YES;
//            }
//        }
//        i++;
//    }
//    return point;
//}

///* Draw the main and aux buffers within the passed-in rectangle */
//-(void) drawRect:(CGRect)rect {
//       
//    // Grab the current context and set the line width to 1.0
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1.0);
//    
//    // Keep track of previous points in both plots for drawing lines
//    CGPoint prevMain = CGPointMake(0, self.frame.size.height/2);
//    CGPoint prevAux  = CGPointMake(0, self.frame.size.height/2);
//    
//    // For each point, grab the current main and auxiliary points and draw lines from previous points
//    for (int i = 0;i<=self.frame.size.width;i++) {
//        if (mainSet[i] == 1) {
//            // Main plot in black
//            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//            
//            // Append line from previous point to current point
//            CGContextMoveToPoint(context, prevMain.x, prevMain.y);
//            CGContextAddLineToPoint(context, i, mainPlot[i]);
//            
//            // Current point becomes previous
//            prevMain = CGPointMake(i, mainPlot[i]);
//            
//            // Draw
//            CGContextStrokePath(context);
//        }
//        
//        if (auxSet[i] == 1) {
//            // Main plot in black
//            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//            
//            // Append line from previous point to current point
//            CGContextMoveToPoint(context, prevAux.x, prevAux.y);
//            CGContextAddLineToPoint(context, i, auxPlot[i]);
//            
//            // Current point becomes previous
//            prevAux = CGPointMake(i, auxPlot[i]);
//            
//            // Draw
//            CGContextStrokePath(context);
//        }
//    }
//
////    if (counter%1==0) {
////        [self interpolateFullFrame];
////    }
////    counter++;
//    if ([delegate respondsToSelector:@selector(drawViewChanged)]) {
//        [delegate drawViewChanged];
//    }
//}
//
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
//    for (int m = 1; m <= self.frame.size.width - 1; m++) {
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
//            CGContextAddLineToPoint(context, m, [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            
//            // Make the current point and convert to NSValue
//            CGPoint  cnt = CGPointMake(m, [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            NSValue *val = [NSValue valueWithCGPoint:cnt];
//            
//            // Current point becomes the previous point
//            [previous replaceObjectAtIndex:n withObject:val];
//            
//            // Draw
//            CGContextStrokePath(context);
//        }
//    }
//    
//    //    if (counter%1==0) {
//    //        [self interpolateFullFrame];
//    //    }
//    //    counter++;
//    if ([delegate respondsToSelector:@selector(drawViewChanged)]) {
//        [delegate drawViewChanged];
//    }
//}
//
//-(float) interpolateIndex:(int)index {
//    CGPoint last = [self getPreviousSetPointFromIndex:index];
//    CGPoint next = [self getNextSetPointFromIndex:index];
//    float result = self.frame.size.height/2;
//    if (next.x-last.x != 0) {
//        result = (((index-last.x)*(next.y-last.y))/(next.x-last.x))+last.y;
//    }
//    return result;
//}
//
//-(void) clearDrawing {
//    mainSet[0] = 1;
//    mainPlot[0] = self.frame.size.height/2;
//    for (int i = 1;i<self.frame.size.width-1;i++) {
//        mainSet[i] = 0;
//        mainPlot[i] = 0;
//    }
//    mainSet[(int)self.frame.size.width-1] = 1;
//    mainSet[(int)self.frame.size.width-1] = self.frame.size.height/2;
//    [self setNeedsDisplay];
//    counter = 0;
//}
//
//-(void) interpolateFullFrame {
//    float value;
//    for (int i = 0;i<self.frame.size.width;i++) {
//        if (mainSet[i]==1) {
//            fullValues[i] = mainPlot[i];
//        } else {
//            value = [self interpolateIndex:i];
//            fullValues[i] = value;
//        }
//        
////        if (auxSet[i]==1) {
////            fullValues[i] = auxPlot[i];
////        }
////        else {
////            value = [self interpolateIndex:i];
////            fullValues[i] = value;
////        }
//        
//        scaledValues[i] = (self.frame.size.height/2.0-fullValues[i])/(self.frame.size.height/2.0);
//    }
//}
//
//-(float*) getWaveform {
//    return scaledValues;
//}
//
//-(void) setWaveform:(float*)newValues arraySize:(int)size {
//    
//    for (int i = 0;i<size;i++) {
//        mainPlot[i] = newValues[i];
//        mainSet[i] = 1;
//    }
//    [self setNeedsDisplay];
//}

//-(void) addWaveform:(float*)pWaveform length:(int)pLength color:(UIColor*)pColor {
//    
//    @try {
//        // Create a new row for this waveform
//        NSMutableArray *newRow = [[NSMutableArray alloc] init];
//
//        // Add the waveform to the row, scaling on the way in
//        for(int m = 0; m <= self.frame.size.width; m++)
//            [newRow addObject:[NSNumber numberWithFloat:((-pWaveform[m] / pixelQuant) + (self.frame.size.height / 2))]];
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
//        NSNumber *temp;
//        
//        // Replace the contents of the plot buffer with the updated waveform
//        for(int m = 0; m < self.frame.size.width; m++) {
//            
//            temp = [NSNumber numberWithFloat:((-pWaveform[m] / pixelQuant) + (self.frame.size.height / 2))];
//            [plotBuffer[pIdx] replaceObjectAtIndex:m withObject:temp];
//        }
//        
//        [self setNeedsDisplay];
//    }
//    
//    @catch (NSException *e) {
//        NSLog(@"DrawView.setWaveform():Exception: %@\n", e);
//    }
//}

//-(void) scalePlotBuffer {
//    
//    float scaled;
//    
//    for(int m = 0; m <= self.frame.size.width; m++) {
//        for( int n = 0; n < nWaveforms; n++) {
//            
//            scaled = ([[plotBuffer[n] objectAtIndex:m] floatValue] / pixelQuant) + (self.frame.size.height / 2);
//
//        }
//    }
//}
//
///* Set the display limits of the y-axis and rescale the waveforms */
//-(void) setYlim:(double)pYlim {
//    
//    float scaled;
//    
//    yLim = pYlim;
//    pixelQuant = (2*yLim) / self.frame.size.height;
//    
//    for(int m = 0; m <= self.frame.size.width; m++) {
//        for( int n = 0; n < nWaveforms; n++) {    
//            
//            printf("m = %d\n", m);
//            
//            scaled = [[plotBuffer[n] objectAtIndex:m] floatValue] * pixelQuant + self.frame.size.height;
//            
//            printf("plotBuffer[%d] = %1.2f, scaled = %1.2f\n", m, [[plotBuffer[n] objectAtIndex:m] floatValue], scaled);
//         
////            if(m < [scaledBuffer count])
////                [scaledBuffer[n] replaceObjectAtIndex:m withObject:[NSNumber numberWithFloat:scaled]];
////            
//            [scaledBuffer[n] addObject:[NSNumber numberWithFloat:scaled]];
//            
//            printf("scaledBuffer[m] = %1.2f\n", [[plotBuffer[n] objectAtIndex:m] floatValue]);
//            
//        }
//    }
//}


-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];

    waveform = (float*)calloc(self.frame.size.width, sizeof(float));
    
    for(int m = 0; m < self.frame.size.width; m++)
        waveform[m] = 0.0;

    upperCutoff =  1.0;
    lowerCutoff = -1.0;
    
    yLim = 1.0;
    pixelQuant = (2.0*yLim) / self.frame.size.height;

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
    CGPoint previous = CGPointMake(0, waveform[0]);

    // Plot the main waveform
    for (int m = 0; m <= self.frame.size.width; m++) {
        
//        printf("waveform[%2d] = %1.2f\n", m, waveform[m]);
        
        // Main plot in black
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

        // Append line from previous point to current point
        CGContextMoveToPoint(context, previous.x, previous.y);
        CGContextAddLineToPoint(context, m, waveform[m]);

        // Current point becomes previous
        previous = CGPointMake(m, waveform[m]);

        // Draw
        CGContextStrokePath(context);
    }

    // Plot the distortion cutoff amplitudes in red
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGPoint distUL = CGPointMake(0,                     upperCutoff);   // Upper left
    CGPoint distUR = CGPointMake(self.frame.size.width, upperCutoff);   // Upper right
    CGPoint distLL = CGPointMake(0,                     lowerCutoff);   // Lower left
    CGPoint distLR = CGPointMake(self.frame.size.width, lowerCutoff);   // Lower right
    
    // Upper cutoff line
    CGContextMoveToPoint   (context, distUL.x, distUL.y);
    CGContextAddLineToPoint(context, distUR.x, distUR.y);
    CGContextStrokePath(context);
    
    // Lower cutoff line
    CGContextMoveToPoint   (context, distLL.x, distLL.y);
    CGContextAddLineToPoint(context, distLR.x, distLR.y);
    CGContextStrokePath(context);
    
    if ([delegate respondsToSelector:@selector(drawViewChanged)]) {
        [delegate drawViewChanged];
    }    
}

/* Set the main waveform, scale on the way in */
-(void) setWaveform:(float *)pWaveform {
    
    for(int m = 0; m < self.frame.size.width; m++)
        waveform[m] = (-pWaveform[m] / pixelQuant) + (self.frame.size.height / 2);
      
    [self setNeedsDisplay];
}

/* Set the distortion cutoff amplitudes (symmetrically), scale on the way in */
-(void) setDistCutoff:(float *)pCutoff {
    
    upperCutoff = -(*pCutoff / pixelQuant) + (self.frame.size.height / 2);
    lowerCutoff =  (*pCutoff / pixelQuant) + (self.frame.size.height / 2);
    
    [self setNeedsDisplay];
}

@end
