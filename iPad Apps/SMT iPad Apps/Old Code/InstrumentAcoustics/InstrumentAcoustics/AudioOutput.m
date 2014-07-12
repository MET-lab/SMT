//
//  AudioOutput.m
//  InstrumentAcoustics
//
//  Created by Matthew Zimmerman on 6/20/12.
//  Copyright (c) 2012 Drexel University. All rights reserved.
//

#import "AudioOutput.h"
#import <AudioToolbox/AudioToolbox.h>
OSStatus RenderTone(
                    void *inRefCon, 
                    AudioUnitRenderActionFlags 	*ioActionFlags, 
                    const AudioTimeStamp 		*inTimeStamp, 
                    UInt32 						inBusNumber, 
                    UInt32 						inNumberFrames, 
                    AudioBufferList 			*ioData)

{
	// Fixed amplitude is good enough for our purposes
	const double amplitude = 0.25;
	// Get the tone parameters out of the view controller
	AudioOutput *audioOutput = (__bridge AudioOutput *)inRefCon;
	double theta = audioOutput->theta;
	double theta_increment = 2.0 * M_PI * audioOutput->frequency / audioOutput->sampleRate;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
    int numHarmonics = 100;
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++) 
	{
		buffer[frame] = sin(theta) * amplitude;
		
        for (int harmonic = 3;harmonic<=numHarmonics*2;harmonic+=2) { 
            buffer[frame] = buffer[frame] +sin(harmonic*theta)*amplitude/(double)harmonic;
        }
        
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
    int counter = audioOutput->counter;
    
    if (counter == 5) {
        for (int i = 0;i<inNumberFrames;i++) {
            
            printf("%f ",buffer[i]);
            
        }
    }
    counter++;
    audioOutput->counter = counter;
	audioOutput->theta = theta;
    return noErr;
}

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	AudioOutput *audioOutput =(__bridge AudioOutput *)inClientData;
	[audioOutput stop];
}

@implementation AudioOutput 

-(id) init {
    
    self  = [super init];
    
	OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInterruptionListener, (__bridge void*)self);
	if (result == kAudioSessionNoError)
	{
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	}
	AudioSessionSetActive(true);;
    
    
    return  self;
}

-(void) setupAudioOutput {
    
}

-(void) stop {
    
}

@end
