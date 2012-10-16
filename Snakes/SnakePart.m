//
//  SnakePart.m
//  Snakes
//
//  Created by Bevis on 12-9-28.
//
//

#import "SnakePart.h"
#import "Snake.h"

@implementation SnakePart

- (SnakePart *) init: (enum PART_TYPE) type {
    return [self init: type direction: LEFT];
}

- (SnakePart *) init: (enum PART_TYPE) type direction:(enum DIRECTION) direction{
    if (self = [super init]) {
        switch (type) {
            case HEAD:
                self.sprite = [CCSprite spriteWithFile:@"head.png"];

                self.sprite.zOrder = 1;
                break;
            case TAIL:
                self.sprite = [CCSprite spriteWithFile:@"tail.png"];
                break;
            case LINK:
                self.sprite = [CCSprite spriteWithFile:@"link.png"];
                break;
            default:
                break;
        }
    }
    self.type = type;
    self.direction = direction;
    
    [self rotate];
    return self;
}
// 旋转
- (void) rotate {
    int angle = 0;
    switch (self.direction) {
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
    [self.sprite setRotation:angle];
}
@end
