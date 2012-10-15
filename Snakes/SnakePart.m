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

- (SnakePart *) init: (enum PART_TYPE) type direction:(enum DIRECTION)direction{
    if (self = [super init]) {
        switch (type) {
            case HEAD:
                self.sprite = [CCSprite spriteWithFile:@"head.png"];
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
    return self;
}
@end
