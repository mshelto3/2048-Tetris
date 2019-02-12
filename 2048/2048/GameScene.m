//
//  GameScene.m
//  2048
//
//  Created by Marc Shelton on 2/6/19.
//  Copyright © 2019 Marc Shelton. All rights reserved.
//

#import "GameScene.h"
#import <gamekit/gamekit.h>
#include <stdlib.h>



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
    NSTimer *_timer2;
    int set;
    bool faster;
}

- (void)didMoveToView:(SKView *)view {
    // Setup screen physics body
    SKPhysicsBody* border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.restitution = 0.0;
    border.friction = 0.0f;
    self.physicsBody = border;
    self.physicsWorld.contactDelegate = self;
    
    
    // initializations
    _score = (SKLabelNode *)[self childNodeWithName:@"//score"];
    _sNum = 0;
    _score.text = [NSString stringWithFormat:@"%d", _sNum];
    _countdown = (SKLabelNode *)[self childNodeWithName:@"//countdown"];
    _cNum = 60;
    _countdown.text = [NSString stringWithFormat:@"%d", _cNum];
    _tile = (SKSpriteNode *)[self childNodeWithName:@"//tile"];
    _newBody = _tile.physicsBody;
    set = 0;
    faster = false;
    
    //timers
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(cDown) withObject:nil waitUntilDone:NO];}];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];}];
    
    
}


- (void)addBlock{
    SKSpriteNode *newNode = [_tile copy];
    newNode.physicsBody = [_newBody copy];
    SKLabelNode *nodeNum = (SKLabelNode *)[newNode childNodeWithName:@"//number"];
    int r = arc4random_uniform(4);
    if(r == 0){
        nodeNum.text = @"4";
    }
    else{
        nodeNum.text = @"2";
    }
    [self addChild:newNode];
    if(set == 0){
        newNode.position = CGPointMake(3.251, -1.27);
        set = 1;
    }
    else if(set == 1){
        newNode.position = CGPointMake(-325, -1.27);
        set = 2;
    }
    else if(set == 2){
        newNode.position = CGPointMake(325, -1.27);
        set = 2;
    }
    
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
    
    SKSpriteNode *a = (SKSpriteNode *)contact.bodyA.node;
    SKSpriteNode *b = (SKSpriteNode *)contact.bodyB.node;
    
    if(a == self || b == self) return;
    
    SKLabelNode *first = (SKLabelNode *)[a childNodeWithName:@"number"];
    SKLabelNode *second = (SKLabelNode *)[b childNodeWithName:@"number"];
    int one = first.text.intValue;
    int two = second.text.intValue;
    if(one == two){
        _sNum += one*10;
        if(_sNum > 100 && !faster){
            [_timer2 invalidate];
            _timer2 = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];}];
            faster = true;
        }
        _score.text = [NSString stringWithFormat:@"%d", _sNum];
        one*=2;
        if(one == 4096){
            [a removeFromParent];
            [b removeFromParent];
            return;
        }
        first.text = [NSString stringWithFormat:@"%d", one];
        [b removeFromParent];
    }

}

@end
