//
//  GameScene.m
//  2048
//
//  Created by Marc Shelton on 2/6/19.
//  Copyright © 2019 Marc Shelton. All rights reserved.
//

#import "GameScene.h"
#import <gamekit/gamekit.h>



@implementation GameScene {
    SKSpriteNode *_tile;
    SKLabelNode *_score;
    SKLabelNode *_countdown;
    SKNode *_touched;
    BOOL isTouch;
    SKPhysicsBody *_newBody;
    int _sNum;
    int _cNum;
    NSTimer *_timer;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    SKPhysicsBody* border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.restitution = 0.0;
    self.physicsBody = border;
    self.physicsBody.friction = 0.0f;
    self.physicsWorld.contactDelegate = self;
    
    
    // Get label node from scene and store it for use later
    _score = (SKLabelNode *)[self childNodeWithName:@"//score"];
    _sNum = 0;
    _score.text = [NSString stringWithFormat:@"%d", _sNum];
    _countdown = (SKLabelNode *)[self childNodeWithName:@"//countdown"];
    _cNum = 60;
    _countdown.text = [NSString stringWithFormat:@"%d", _cNum];
    _tile = (SKSpriteNode *)[self childNodeWithName:@"//tile"];
    _newBody = _tile.physicsBody;
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(cDown) withObject:nil waitUntilDone:NO];}];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];
    }];
    
    
}


- (void)addBlock{
    SKSpriteNode *newNode = [_tile copy];
    newNode.physicsBody = [_newBody copy];
    [self addChild:newNode];
    newNode.position = CGPointMake(3.251, -1.27);
    
}

- (void)cDown{
    _cNum--;
    _countdown.text = [NSString stringWithFormat:@"%d", _cNum];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInNode:self];
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:pos];
    if(body){
        isTouch = true;
        _touched = body.node;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isTouch){
        UITouch* touch = [touches anyObject];
        CGPoint pos = [touch locationInNode:self];
        CGPoint pre = [touch previousLocationInNode:self];
        int nodeX = _touched.position.x + (pos.x - pre.x);
        _touched.position = CGPointMake(nodeX, _touched.position.y);
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouch = false;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact detected");
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
}

@end
