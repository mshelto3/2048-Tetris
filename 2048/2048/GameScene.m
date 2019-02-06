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
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    SKNode *_touched;
    BOOL isTouch;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    SKShapeNode *tile = (SKShapeNode *)[self childNodeWithName:@"//"];
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
}


- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    UITouch* touch = [touches anyObject];
    CGPoint pos = [touch locationInNode:self];
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:pos];
    if(body){
        isTouch = true;
        _touched = body.node;
    }
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isTouch){
        UITouch* touch = [touches anyObject];
        CGPoint pos = [touch locationInNode:self];
        CGPoint pre = [touch previousLocationInNode:self];
        int nodeX = _touched.position.x + (pos.x - pre.x);
        _touched.position = CGPointMake(nodeX, _touched.position.y);
    }
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouch = false;
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
