//
//  Snake.m
//  Snakes
//
//  Created by Bevis on 12-9-28.
//
//

#import "Snake.h"
#import "cocos2d.h"

@implementation Snake {
    // 正在吃东西？
    BOOL ate;
    int rows;
    int cols;
    // 移动的目标方向（下一步进行移动）
    enum DIRECTION nextDirection;

}

// 初始化长度
int initLinkSize = 10;


- (Snake *) initWithGrids: (int) _rows cols: (int) _cols {
    ate = NO;
    rows = _rows;
    cols = _cols;
    if (self = [super init]) {
        
        self.head = [[SnakePart alloc] init: HEAD direction: LEFT];
        self.tail = [[SnakePart alloc] init: TAIL direction: LEFT];
        self.parts = [[NSMutableArray alloc] init];
        
        // 头部
        [self.parts addObject: self.head];
        // 身体
        for (int i = 0; i < initLinkSize; i++) {
            [self.parts addObject: [[SnakePart alloc] init: LINK direction: LEFT]];
        }
        // 尾巴
        [self.parts addObject: self.tail];
        
        for (int i = self.parts.count - 1, j = 0; i >= 0; i--, j++) {
            ((SnakePart*)[self.parts objectAtIndex:i]).gridIndex = ccp(_cols - j, _rows);
        }
    }
    
    return self;
    
}
- (void) move {
    if (nextDirection != 0) {
        self.head.direction = nextDirection;
        nextDirection = 0;
    }
    
    // 如果吃了，则尾巴不动一次，其它位置移动以伸展躯体
    // 计算出需要移动的关节的数量
    int needMovePartCount = ate == YES ? self.parts.count - 1: self.parts.count;
    for (int i = 0; i < needMovePartCount; i++) {
        SnakePart *part = [self.parts objectAtIndex:i];
        
        switch (part.direction) {
            case LEFT:
                part.gridIndex = ccp(part.gridIndex.x - 1 < 1 ? cols : part.gridIndex.x - 1, part.gridIndex.y);
                break;
            case RIGHT:
                part.gridIndex = ccp(part.gridIndex.x + 1 > cols ? 1 : part.gridIndex.x + 1, part.gridIndex.y);
                break;
            case UP:
                part.gridIndex = ccp(part.gridIndex.x, part.gridIndex.y + 1 > rows ? 1 : part.gridIndex.y + 1);
                break;
            case DOWN:
                part.gridIndex = ccp(part.gridIndex.x, part.gridIndex.y - 1 < 1 ? rows : part.gridIndex.y - 1);
                break;
            default:
                break;
        }
        [part rotate];
        
    }
    
    for (int i = self.parts.count - (ate ? 2 : 1); i > 0 ; --i) {
        ((SnakePart *)self.parts[i]).direction = ((SnakePart *)self.parts[i - 1]).direction;
    }
    
    // 吃完了
    ate = NO;

}

// 吃东西，添加一段身体
- (SnakePart*) eat {
    // 新关节的位置与第二关节相同
    ate = YES;
    SnakePart *newLink = [[SnakePart alloc] init: LINK direction: self.tail.direction];
    newLink.gridIndex = self.tail.gridIndex;
    newLink.sprite.position = self.tail.sprite.position;
    
    // 添加新关节要插入在尾巴前，顺序不能错乱，所以，先删除尾巴，插入新关节后再插回尾巴
    [self.parts removeObject: self.tail];
    [self.parts addObject: newLink];
    [self.parts addObject: self.tail];
    
    return newLink;
}

// 移动方向
- (void) redirect: (enum DIRECTION) to {
    nextDirection = to;
}

// 获取蛇身尺寸（刨去头尾）
- (int) size {
    return self.parts.count - 2;
}

// 获取蛇吃的食物数量
- (int) ateCount {
    return [self size] - initLinkSize;
}
- (oneway void) release {
    [self.parts release];
}
@end
