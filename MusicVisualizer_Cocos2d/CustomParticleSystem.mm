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
