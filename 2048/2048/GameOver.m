//
//  GameOver.m
//  2048
//
//  Created by Marc Shelton on 2/13/19.
//  Copyright © 2019 Marc Shelton. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
#import <gamekit/gamekit.h>
#include <stdlib.h>



@implementation GameOver {
    SKView *_view;
    SKLabelNode *_score;
    SKLabelNode *_countdown;
    int _cNum;
    NSTimer *_timer;
}

- (void)didMoveToView:(SKView *)view {
    SKPhysicsBody* border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    border.restitution = 0.0;
    border.friction = 0.0f;
    self.physicsBody = border;
    _score = (SKLabelNode *)[self childNodeWithName:@"//number"];
    _score.text = [NSString stringWithFormat:@"%d", _sNum];
    _view = (SKView *)self.view;
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
    }
}


@end
