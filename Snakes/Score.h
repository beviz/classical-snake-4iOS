//
//  Score.h
//  Snakes
//
//  Created by Bevis on 12-10-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject

@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * createdAt;

@end
