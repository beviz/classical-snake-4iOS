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

// 改变方向
- (void) redirect: (enum DIRECTION) to;

// 吃东西
- (SnakePart*) eat;

// 蛇身长（刨去头尾）
- (int) size;

// 获取蛇吃的食物数量
- (int) ateCount ;
    
- (Snake *) initWithGrids: (int) rows cols: (int) cols ;
@end
