//
//  CocosVisualizer.m
//  MusicVisualizer_Cocos2d
//
//  Created by Xinrong Guo on 13-6-27.
//  Copyright 2013年 Xinrong Guo. All rights reserved.
//

#import "CocosVisualizer.h"
#import "CustomParticleSystem.h"


@implementation CocosVisualizer {
    CustomParticleSystem *particleSys;
}

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        particleSys = [CustomParticleSystem particleWithFile:@"ParticleSys.plist"];
        [self addChild:particleSys];
        
        [self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)delta {
    
}

- (void)setAudioPlayer:(AVAudioPlayer *)audioPlayer {
    [particleSys setAudioPlayer:audioPlayer];
}

@end
