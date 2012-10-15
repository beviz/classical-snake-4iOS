//
//  GameOverScene.m
//  CocosDemo
//
//  Created by Bevis on 12-9-27.
//
//

#import "GameOverScene.h"

@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
    
    if ((self = [super init])) {
        self.layer = [GameOverLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end

@implementation GameOverLayer
@synthesize label = _label;

-(id) init
{
    if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        _label.color = ccc3(0,0,0);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self gameOverDone];
}
- (void)gameOverDone {
    
    [[CCDirector sharedDirector] replaceScene:[SnakesLayer scene]];
    
}

- (void)dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}

@end