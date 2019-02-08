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
    SKLabelNode *_label;
    SKNode *_touched;
    BOOL isTouch;
    SKPhysicsBody *_newBody;
    var _num;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    SKPhysicsBody* border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = border;
    self.physicsBody.friction = 0.0f;
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//number"];
    _tile = (SKSpriteNode *)[self childNodeWithName:@"//tile"];
    _newBody = _tile.physicsBody;
    _num = 0;
    _label.text = _num;
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    
}


- (void)touchDownAtPoint:(CGPoint)pos {

}

- (void)touchMovedToPoint:(CGPoint)pos {

}

- (void)touchUpAtPoint:(CGPoint)pos {

}

- (void)addBlock{
    SKSpriteNode *newNode = [_tile copy];
    [self addChild:newNode];
    newNode.position = CGPointMake(-325, -150);
    newNode.physicsBody = [_newBody copy];
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
    [self addBlock];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
