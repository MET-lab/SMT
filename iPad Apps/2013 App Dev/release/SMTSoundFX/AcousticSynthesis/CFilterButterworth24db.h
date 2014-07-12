//
//  CFilterButterworth24db.h
//  SMTSoundFX
//
//  Created by Jeff Gregorio on 6/20/13.
//  Copyright (c) 2013 Drexel University. All rights reserved.
//

#include <math.h>

class CFilterButterworth24db
{
public:
    CFilterButterworth24db(void);
    ~CFilterButterworth24db(void);
    void SetSampleRate(float fs);
    void Set(float cutoff, float q);
    float Run(float input);
    
private:
    float t0, t1, t2, t3;
    float coef0, coef1, coef2, coef3;
    float history1, history2, history3, history4;
    float gain;
    float min_cutoff, max_cutoff;
};
