//
//  AudioOutput.h
//  InstrumentAcoustics
//
//  Created by Matthew Zimmerman on 6/20/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioOutProtocols.h"
#import <AudioUnit/AudioUnit.h>

@interface AudioOutput : NSObject {
    
    AudioComponentInstance toneUnit;

    @public
    
    double frequency;
    double theta;
    double sampleRate;
    int counter;
    
}

-(void) stop;

-(void) setupAudioOutput;

@end
