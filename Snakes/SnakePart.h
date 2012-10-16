//
//  SnakePart.h
//  Snakes
//
//  Created by Bevis on 12-9-28.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SnakePart : NSObject {

}

// 类型
@property (assign) enum PART_TYPE type;

// 当前移动方向
@property(assign) enum DIRECTION direction;

// 对应的sprite
@property(assign) CCSprite *sprite;

// 在grid中的索引位置
@property(assign) CGPoint gridIndex;

- (SnakePart *) init: (enum PART_TYPE) type;
- (SnakePart *) init: (enum PART_TYPE) type direction:(enum DIRECTION)direction;
// 旋转
- (void) rotate;
@end

enum DIRECTION {
    UP = 1, DOWN = 2, LEFT = 3, RIGHT = 4
};

enum PART_TYPE {
  HEAD, TAIL, LINK
};