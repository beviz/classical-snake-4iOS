//
//  GameOverScene.m
//  CocosDemo
//
//  Created by Bevis on 12-9-27.
//
//

#import "GameOverLayer.h"
#import "FMDatabase.h"

@implementation GameOverLayer

CCLabelTTF *label;

+ (CCScene *) scene: (int) score
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	[layer setScore: score];
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
    if( (self=[super initWithColor:ccc4(63, 196, 128, 255)])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
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

// 设置得分
- (void) setScore: (int) score {
    NSString *results;
    if (score == 0) {
        results = @"Ops..啥都没吃着 :(";
    } else if (score < 20) {
        results = [NSString stringWithFormat:@"你吃到了%d个苹果", score];
    } else if (score < 40) {
        results = [NSString stringWithFormat:@"%d！不错，再接再厉！", score];
    } else if (score < 60) {
        results = [NSString stringWithFormat:@"%d！真棒！下一目标：60", score];
    } else if (score < 100) {
        results = [NSString stringWithFormat:@"%d！你的技术真是一绝！下一目标：100！", score];
    } else if (score < 150){
        results = [NSString stringWithFormat:@"%d！WOW！神一般！最终挑战：150！", score];
    } else {
        results = [NSString stringWithFormat:@"%d！难以置信！你已经超神了！", score];
    }

    [label setString:results];
    [self saveScore:score];
}

- (void) saveScore: (int) score{
    NSString *dbPath = [NSString stringWithFormat: @"%@/Documents/db.sqlite3", NSHomeDirectory()];
    FMDatabase *db = [FMDatabase databaseWithPath: dbPath];
    
    [db open];
    BOOL saved = [db executeUpdate:@"insert into scores(name, score) values(?, ?)", @"Bevis", [NSNumber numberWithInt:score]];
    if (!saved) {
        CCLOG(@"得分保存失败！");
    }
    [db close];
}

- (void)dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}

@end