//
//  Snake.h
//  Snakes
//
//  Created by Bevis on 12-9-28.
//
//

#import <Foundation/Foundation.h>
#import "SnakePart.h"

@interface Snake : NSObject {

}

// 头部
@property(assign) SnakePart *head;
// 全身数组
@property(assign) NSMutableArray *parts;
// 尾巴
@property(assign) SnakePart *tail;

// 移动
- (void) move;

// 移动方向
- (void) moveTo: (enum DIRECTION) to;

// 停止
- (SnakePart*) eat;

- (Snake *) initWithGrids: (int) rows cols: (int) cols ;
@end
