//
//  HelloWorldLayer.m
//  Snakes
//
//  Created by Bevis on 12-9-28.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "SnakesLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"

#pragma mark - SnakesLayer

#import "Snake.h"

// HelloWorldLayer implementation
@implementation SnakesLayer

Snake *snake;
CCSprite *fruit;

CGSize winSize;
int cols, rows, step, margin = 1, incrementSpeedPerLinkCount = 5, passGmaeSize = 25;
float initSpeed = .35, speed, maxSpeed = .1;

// 屏幕划分蛇移动的矩阵:MSMutableArray<MSMutableArray<CGPoint>>
//                       Y               X           坐标
NSMutableArray *grids;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SnakesLayer *layer = [SnakesLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 初始化表格式布局
- (NSMutableArray *) initGrid {
    CCSprite *sampleLink = [CCSprite spriteWithFile:@"link.png"];
    step = sampleLink.contentSize.width;
    // 将屏幕分割为表格，食物在表格中随即出现
    // 横向表格数量
    cols = winSize.width / (step + margin);
    rows = winSize.height / (step + margin);
    int winXMargin = (winSize.width - (step + margin) * cols) / 2;
    int winYMargin = (winSize.height - (step + margin) * rows) / 2;
    // 矩阵个数
    NSMutableArray *gridsPosition = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < rows; i++) {
        NSMutableArray *one = [[NSMutableArray alloc] init];
        [gridsPosition addObject: one];
        for (int j = 0; j < cols; j++) {
            CGPoint point = ccp(winXMargin + ((step + margin) * j) + sampleLink.contentSize.width / 2,
                                       winYMargin + ((step + margin) * i) + sampleLink.contentSize.height / 2);
            [one addObject: [NSValue valueWithCGPoint: point]];
        }
    }
    
    return gridsPosition;
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    if((self = [super init])) {
        winSize = [[CCDirector sharedDirector] winSize];
        // 初始化背景
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width / 2, winSize.height / 2);
        background.zOrder = 0;
        [self addChild: background];
        
        // 初始化速度
        speed = initSpeed;
        
        grids = [self initGrid];
        snake = [[Snake alloc ] initWithGrids: rows cols: cols];
        
        for (SnakePart *part in snake.parts) {
            part.sprite.position = [((NSValue *)[[grids objectAtIndex: part.gridIndex.y - 1] objectAtIndex: part.gridIndex.x - 1]) CGPointValue];
            [self addChild: part.sprite];
        }

        self.isTouchEnabled = YES;

        // 蛇身移动
        [self schedule:@selector(move:) interval: speed];
        
        [self freshFood];
	}
 
	return self;
}

// 速度递增
- (void) incrementSpeed {
    if (speed > maxSpeed) {
        // 如果已经达到了最低速（.2）则不变，否则递增速度
        speed -= .05; 
        [self unschedule:@selector(move:)];
        [self schedule:@selector(move:) interval: speed];
        
    }
}

// 刷新食物
- (void) freshFood {
    // 如果已经有食物，清理掉
    if (fruit != nil) {
        [self removeChild:fruit cleanup:YES];
    }
    
    // 罗列出所有位置
    NSMutableDictionary *locations = [[NSMutableDictionary alloc] init];
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= cols; j++) {
            NSValue *point = ((NSValue *)[[grids objectAtIndex: i - 1] objectAtIndex: j - 1]);
            [locations setObject: point forKey:[NSString stringWithFormat: @"%dx%d", i, j]];
        }
    }
    // 排除蛇所在位置，随即出一个新位置
    for (SnakePart* part in snake.parts) {
        [locations removeObjectForKey: [NSString stringWithFormat: @"%dx%d", (int)part.gridIndex.y, (int)part.gridIndex.x]];
    }
    CGPoint fruitPoint = [[[locations allValues] objectAtIndex: arc4random() % locations.count] CGPointValue];
    
    // TODO 排除蛇头的三个方向
    // 显示食物
    fruit = [CCSprite spriteWithFile:@"fruit.png"];
    fruit.position = fruitPoint;
    [self addChild: fruit];

}

// 检查是否GAME OVER（出局或者身体相撞）
- (BOOL) checkOutOver {
    
    if (snake.head.gridIndex.x < 1
        || snake.head.gridIndex.y < 1
        || snake.head.gridIndex.x > cols
        || snake.head.gridIndex.y > rows) {
        return YES;
    }
    
    // 身体是否碰撞
    for (SnakePart* part in snake.parts) {
        if (part.type == HEAD) {
            continue;
        } else {
            if (part.sprite.position.x == snake.head.sprite.position.x
                && part.sprite.position.y == snake.head.sprite.position.y) {
                return YES;
            }
        }
    }
    
    return NO;
}

// 移动身体
- (void) move:(ccTime)dt  {
    [snake move];
    
    // 判断是否出局
    if ([self checkOutOver]) {
        // GAME OVER!
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:[NSString stringWithFormat:@"游戏结束！你吃了%d个食物! :)", snake.parts.count - 2]];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
        return;

    } else {
        
        for (SnakePart *part in snake.parts) {
            part.sprite.position = [((NSValue *)[[grids objectAtIndex: part.gridIndex.y - 1] objectAtIndex: part.gridIndex.x - 1]) CGPointValue];
            int angle = 0;
            switch (part.direction) {
                case LEFT:
                    angle = -90;
                    break;
                case RIGHT:
                    angle = 90;
                    break;
                case DOWN:
                    angle = 180;
                    break;
                case UP:
                    angle = 0;
                default:
                    break;
            }
            
            [part.sprite runAction:[CCRotateTo actionWithDuration:.0 angle: angle]];
        }
        
        // 判断是否吃到了食物
        if (snake.head.sprite.position.x == fruit.position.x && snake.head.sprite.position.y == fruit.position.y) {
            SnakePart* newLink = [snake eat];
            // 播放吃东西声音
            [[SimpleAudioEngine sharedEngine] playEffect:@"chew.mp3"];
            
            [self addChild: newLink.sprite];
            [self freshFood];
            
            // 检查吃完后身长是否达到了尺寸而过关
            // 不再有结束，看自己能吃多少
//            if ((snake.parts.count - 2) == passGmaeSize) {
//                GameOverScene *gameOverScene = [GameOverScene node];
//                [gameOverScene.layer.label setString:@"你赢啦！真厉害！:）"];
//                [[CCDirector sharedDirector] replaceScene:gameOverScene];
//                return;
//            }
            
            
            // 身体每达到5节就提升速度一次
            if ((snake.parts.count - 2) % incrementSpeedPerLinkCount == 0) {
                [self incrementSpeed];
            }

        }
    }
    
}

// 点击屏幕触发蛇改变方向
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    int xBalance = location.x - snake.head.sprite.position.x,
        yBalance = location.y - snake.head.sprite.position.y;
    
    enum DIRECTION to;
    // 如果移动方向是左或者右，则变向只能是上下
    if (snake.head.direction == LEFT || snake.head.direction == RIGHT) {
        if (yBalance > 0) {
            to = UP;
        } else {
            to = DOWN;
        }
    } else {
        if (xBalance > 0) {
            to = RIGHT;
        } else {
            to = LEFT;
        }
    }
    
    [snake moveTo: to];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];

    [snake release];
    snake = nil;
    
    // TODO 内存释放问题
//    [fruit release];
//    fruit = nil;
    
//    [grids release];
//    grids = nil;
    
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
