//
//  MenuLayer.m
//  Snakes
//
//  Created by Bevis on 12-10-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "SnakesLayer.h"
#import "FMDatabase.h"
#import "Score.h"

@implementation MenuLayer


+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (MenuLayer*) init {
    if( (self=[super initWithColor:ccc4(63, 196, 128, 255)])) {
        // 检查数据库
//        [self checkDatabase];
        int highestScore = [self getHighestScore];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Welcome! %d", highestScore]
                                               fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild: label];
        
        self.isTouchEnabled = YES;
    }
    return self;

}
// 获取最高分
- (int) getHighestScore {
    NSString *dbPath = [NSString stringWithFormat: @"%@/Documents/db.sqlite3", NSHomeDirectory()];
    FMDatabase *db = [FMDatabase databaseWithPath: dbPath];
    
    [db open];
    FMResultSet *s = nil;
    @try {
        s = [db executeQuery:@"SELECT * FROM scores order by score desc limit 1"];
        if ([s next]) {
            //retrieve values for each record
            return [s intForColumn: @"score"];
        } else {
            return 0;
        }
    }
    @finally {
        if (s != nil) {
            [s close];
            [db close];
        }
    }
}

// 点击屏幕触发蛇改变方向
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[SnakesLayer scene]];
}

@end