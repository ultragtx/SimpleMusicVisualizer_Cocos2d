//
//  CustomParticleSystem.m
//  MusicVisualizer_Cocos2d
//
//  Created by Xinrong Guo on 13-6-27.
//  Copyright 2013年 Xinrong Guo. All rights reserved.
//

#import "CustomParticleSystem.h"


@implementation CustomParticleSystem

- (void)update:(ccTime)dt {
    CC_PROFILER_START_CATEGORY(kCCProfilerCategoryParticles , @"CCParticleSystem - update");
    
	if( _active && _emissionRate ) {
		float rate = 1.0f / _emissionRate;
		
		//issue #1201, prevent bursts of particles, due to too high emitCounter
		if (_particleCount < _totalParticles)
			_emitCounter += dt;
		
		while( _particleCount < _totalParticles && _emitCounter > rate ) {
			[self addParticle];
			_emitCounter -= rate;
		}
        
		_elapsed += dt;
        
		if(_duration != -1 && _duration < _elapsed)
			[self stopSystem];
	}
    
	_particleIdx = 0;
    
	CGPoint currentPosition = CGPointZero;
	if( _positionType == kCCPositionTypeFree )
		currentPosition = [self convertToWorldSpace:CGPointZero];
    
	else if( _positionType == kCCPositionTypeRelative )
		currentPosition = _position;
    
	if (_visible)
	{
		while( _particleIdx < _particleCount )
		{
			tCCParticle *p = &_particles[_particleIdx];
            
			// life
			p->timeToLive -= dt;
            
			if( p->timeToLive > 0 ) {
                
				// Mode A: gravity, direction, tangential accel & radial accel
				if( _emitterMode == kCCParticleModeGravity ) {
					CGPoint tmp, radial, tangential;
                    
					radial = CGPointZero;
					// radial acceleration
					if(p->pos.x || p->pos.y)
						radial = ccpNormalize(p->pos);
                    
					tangential = radial;
					radial = ccpMult(radial, p->mode.A.radialAccel);
                    
					// tangential acceleration
					float newy = tangential.x;
					tangential.x = -tangential.y;
					tangential.y = newy;
					tangential = ccpMult(tangential, p->mode.A.tangentialAccel);
                    
					// (gravity + radial + tangential) * dt
					tmp = ccpAdd( ccpAdd( radial, tangential), _mode.A.gravity);
					tmp = ccpMult( tmp, dt);
					p->mode.A.dir = ccpAdd( p->mode.A.dir, tmp);
					tmp = ccpMult(p->mode.A.dir, dt);
					p->pos = ccpAdd( p->pos, tmp );
				}
                
				// Mode B: radius movement
				else {
					// Update the angle and radius of the particle.
					p->mode.B.angle += p->mode.B.degreesPerSecond * dt;
					p->mode.B.radius += p->mode.B.deltaRadius * dt;
                    
					p->pos.x = - cosf(p->mode.B.angle) * p->mode.B.radius;
					p->pos.y = - sinf(p->mode.B.angle) * p->mode.B.radius;
				}
                
				// color
				p->color.r += (p->deltaColor.r * dt);
				p->color.g += (p->deltaColor.g * dt);
				p->color.b += (p->deltaColor.b * dt);
				p->color.a += (p->deltaColor.a * dt);
                
				// size
				p->size += (p->deltaSize * dt);
				p->size = MAX( 0, p->size );
                
				// angle
				p->rotation += (p->deltaRotation * dt);
                
				//
				// update values in quad
				//
                
				CGPoint	newPos;
                
				if( _positionType == kCCPositionTypeFree || _positionType == kCCPositionTypeRelative )
				{
					CGPoint diff = ccpSub( currentPosition, p->startPos );
					newPos = ccpSub(p->pos, diff);
				} else
					newPos = p->pos;
                
				// translate newPos to correct position, since matrix transform isn't performed in batchnode
				// don't update the particle with the new position information, it will interfere with the radius and tangential calculations
				if (_batchNode)
				{
					newPos.x+=_position.x;
					newPos.y+=_position.y;
				}
                
				_updateParticleImp(self, _updateParticleSel, p, newPos);
                
				// update particle counter
				_particleIdx++;
                
			} else {
				// life < 0
				NSInteger currentIndex = p->atlasIndex;
                
				if( _particleIdx != _particleCount-1 )
					_particles[_particleIdx] = _particles[_particleCount-1];
                
				if (_batchNode)
				{
					//disable the switched particle
					[_batchNode disableParticle:(_atlasIndex+currentIndex)];
                    
					//switch indexes
					_particles[_particleCount-1].atlasIndex = currentIndex;
				}
                
				_particleCount--;
                
				if( _particleCount == 0 && _autoRemoveOnFinish ) {
					[self unscheduleUpdate];
					[_parent removeChild:self cleanup:YES];
					return;
				}
			}
		}//while
		_transformSystemDirty = NO;
	}
    
	if (!_batchNode)
		[self postStep];
    
	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategoryParticles , @"CCParticleSystem - update");
}

@end
