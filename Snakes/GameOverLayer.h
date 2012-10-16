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
+ (CCScene *) scene: (int) score;
// 最终得分
- (void) setScore: (int) score;
@end