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

int _sNum;



@implementation GameScene {
    SKSpriteNode *_tile;
    SKLabelNode *_score;
    SKLabelNode *_countdown;
    SKNode *_touched;
    BOOL isTouch;
    SKPhysicsBody *_newBody;
    int _cNum;
    NSTimer *_timer;
    NSTimer *_timer2;
    NSTimer *_timer3;
    int set;
    int set2;
    bool faster;
    bool faster2;
    bool faster3;
    bool faster4;
    bool faster5;
    SKTransition *_fade;
    GameScene *_gameOver;
    SKView *_view;
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
    _cNum = 180;
    _countdown.text = [NSString stringWithFormat:@"%d", _cNum];
    _tile = (SKSpriteNode *)[self childNodeWithName:@"//tile"];
    _tile.color = [UIColor yellowColor];
    _newBody = _tile.physicsBody;
    set = 0;
    set2 = 0;
    faster = false;
    faster2 = false;
    faster3 = false;
    faster4 = false;
    faster5 = false;
    _fade = [SKTransition fadeWithDuration:5];
    _gameOver = (GameScene *)[SKScene nodeWithFileNamed:@"GameOver"];
    _view = view;
    _gameOver.scaleMode = SKSceneScaleModeAspectFill;
    
    
    //timers
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(cDown) withObject:nil waitUntilDone:NO];}];
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];}];
    
}


- (void)addBlock{
    SKSpriteNode *newNode = [_tile copy];
    newNode.physicsBody = [_newBody copy];
    SKLabelNode *nodeNum = (SKLabelNode *)[newNode childNodeWithName:@"number"];
    int r = arc4random_uniform(100);
    if(r == 0){
        nodeNum.text = @"512";
        newNode.color = [UIColor lightGrayColor];
    }
    else if(r == 1 || r == 2 || r == 3){
        nodeNum.text = @"256";
        newNode.color = [UIColor grayColor];
    }
    else if(4 <= r && r <= 8){
        nodeNum.text = @"128";
        newNode.color = [UIColor redColor];
    }
    else if(9 <= r && r <= 14){
        nodeNum.text = @"64";
        newNode.color = [UIColor magentaColor];
    }
    else if(15 <= r && r <= 21){
        nodeNum.text = @"32";
        newNode.color = [UIColor orangeColor];
    }
    else if(22 <= r && r <= 29){
        nodeNum.text = @"16";
        newNode.color = [UIColor blueColor];
    }
    else if(30 <= r && r <= 38){
        nodeNum.text = @"8";
        newNode.color = [UIColor cyanColor];
    }
    else if(39 <= r && r <= 48){
        nodeNum.text = @"4";
        newNode.color = [UIColor greenColor];
        
    }
    else{
        nodeNum.text = @"2";
        newNode.color = [UIColor yellowColor];
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
        set = 0;
    }
    
}

- (void)addBlankBlock{
    SKSpriteNode *newNode = [_tile copy];
    newNode.physicsBody = [_newBody copy];
    SKLabelNode *nodeNum = (SKLabelNode *)[newNode childNodeWithName:@"number"];
    [nodeNum removeFromParent];
    newNode.color = [UIColor whiteColor];
    [self addChild:newNode];
    if(set2 == 0){
        newNode.position = CGPointMake(150, -1.27);
        set2 = 1;
    }
    else if(set2 == 1){
        newNode.position = CGPointMake(-150, -1.27);
        set2 = 0;
    }
    
}

- (void)cDown{
    _cNum--;
    if(_cNum == 0){
        [_timer invalidate];
        [_view presentScene:_gameOver transition:_fade];
    }
    _countdown.text = [NSString stringWithFormat:@"%d", _cNum];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInNode:self];
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:pos];
    if(body){
        if([body.node.name isEqual: @"restart"]){
            GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [_view presentScene:scene];
        }
        else{
            isTouch = true;
            _touched = body.node;
        }
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
    SKSpriteNode *a = (SKSpriteNode *)contact.bodyA.node;
    SKSpriteNode *b = (SKSpriteNode *)contact.bodyB.node;
    
    if(a == self || b == self) return;
    
    SKLabelNode *first = (SKLabelNode *)[a childNodeWithName:@"number"];
    SKLabelNode *second = (SKLabelNode *)[b childNodeWithName:@"number"];

    int one = first.text.intValue;
    int two = second.text.intValue;
    if(one == two){
        _sNum += one*10;
        if(_sNum > 8000 && !faster5){
            [_timer3 invalidate];
            _timer3 = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlankBlock) withObject:nil waitUntilDone:NO];}];
            faster5 = true;
        }
        if(_sNum > 5000 && !faster4){
            [_timer2 invalidate];
            _timer2 = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];}];
            faster4 = true;
        }

        if(_sNum > 3000 && !faster3){
            [_timer3 invalidate];
            _timer3 = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlankBlock) withObject:nil waitUntilDone:NO];}];
            faster3 = true;
        }
        if(_sNum > 1000 && !faster){
            [_timer2 invalidate];
            _timer2 = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlock) withObject:nil waitUntilDone:NO];}];
            faster = true;
        }
        if(_sNum > 500 && !faster2){
            _timer3 = [NSTimer scheduledTimerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self performSelectorOnMainThread:@selector(addBlankBlock) withObject:nil waitUntilDone:NO];}];
            faster2 = true;
        }
        _score.text = [NSString stringWithFormat:@"%d", _sNum];
        one*=2;
        if(one == 4){
            a.color = [UIColor greenColor];
        }
        else if(one == 8){
            a.color = [UIColor cyanColor];
        }
        else if(one == 16){
            a. color = [UIColor blueColor];
        }
        else if(one == 32){
            a.color = [UIColor orangeColor];
        }
        else if(one == 64){
            a.color = [UIColor magentaColor];
        }
        else if(one == 128){
            a.color = [UIColor redColor];
        }
        else if(one == 256){
            a.color = [UIColor grayColor];
        }
        else if(one == 512){
            a.color = [UIColor lightGrayColor];
        }
        else if(one == 1024){
            a.color = [UIColor brownColor];
        }
        else if(one == 2048){
            a.color = [UIColor whiteColor];
        }
        else if(one == 4096){
            [a removeFromParent];
            [b removeFromParent];
            return;
        }
        first.text = [NSString stringWithFormat:@"%d", one];
        [b removeFromParent];
    }

}

@end
