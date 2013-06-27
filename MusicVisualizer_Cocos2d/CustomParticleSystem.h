//
//  CustomParticleSystem.h
//  MusicVisualizer_Cocos2d
//
//  Created by Xinrong Guo on 13-6-27.
//  Copyright 2013年 Xinrong Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"

@interface CustomParticleSystem : CCParticleSystemQuad {
    
}

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
