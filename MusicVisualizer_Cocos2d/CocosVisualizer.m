//
//  CocosVisualizer.m
//  MusicVisualizer_Cocos2d
//
//  Created by Xinrong Guo on 13-6-27.
//  Copyright 2013年 Xinrong Guo. All rights reserved.
//

#import "CocosVisualizer.h"
#import "CustomParticleSystem.h"


@implementation CocosVisualizer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CocosVisualizer *layer = [CocosVisualizer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        
        
        CustomParticleSystem *particleSys = [CustomParticleSystem particleWithFile:@"ParticleSys.plist"];
//        NSLog(@"%@", NSStringFromCGPoint(particleSys.position));
//        [particleSys setPosition:CGPointMake(160, 240)];
//        NSLog(@"%@", NSStringFromCGPoint(particleSys.position));
        [self addChild:particleSys];
        
        [self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)delta {
    
}


@end
