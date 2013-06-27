//
//  CustomParticleSystem.m
//  MusicVisualizer_Cocos2d
//
//  Created by Xinrong Guo on 13-6-27.
//  Copyright 2013年 Xinrong Guo. All rights reserved.
//

#import "CustomParticleSystem.h"
#import "MeterTable.h"

@implementation CustomParticleSystem {
    MeterTable meterTable;
}

/*
 * This method is called in method update: of CCParticleSystem.m near line 599
 * We overwrite this method here just to inject into the update method, and then
 * we can change the size of each particle
 * 
 * Comparing with the UIKit version: Seems that cocos2d doesn't support child
 * emitter (which means each partitle that was emitted by the particle system 
 * is a new emiiter and can emit its own particle), so we cannot use the same
 * trick as we did with CAEmitterLayer.
 * 
 */

- (void)updateQuadWithParticle:(tCCParticle *)particle newPosition:(CGPoint)pos {
    if (_audioPlayer && _audioPlayer.playing) {
        [_audioPlayer updateMeters];
        float power = 0.0f;
        for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
        }
        power /= [_audioPlayer numberOfChannels];
        float level = meterTable.ValueAt(power);
        
        // Here the size is not related to the preset anymore
        particle->size = 50.0 * level * 3;
    }
    
    [super updateQuadWithParticle:particle newPosition:pos];
}

@end
