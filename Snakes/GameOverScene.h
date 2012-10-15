//
//  GameOverScene.h
//  CocosDemo
//
//  Created by Bevis on 12-9-27.
//
//

#import "cocos2d.h"
#import "SnakesLayer.h"
@interface GameOverLayer : CCLayerColor {
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end

@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end