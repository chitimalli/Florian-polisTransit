//
//  TransitDataSingleton.h
//  Transit
//
//  Created by Amar on 3/14/15.
//  Copyright (c) 2015 FaunaFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitData : NSObject

+ (id)sharedInstance;
@property(nonatomic,retain) NSMutableArray *routes;
@property(nonatomic,retain) NSMutableArray *routeStops;
@property(nonatomic,retain) NSMutableArray *routeDepartures;

@property(nonatomic,assign) NSString* searchRouteName;
@property(nonatomic,assign) NSInteger* searchRouteID;


-(void) initRoutesDataWith:(NSString*)searchRouteName;
-(void) initDetailsDataWith:(NSInteger*)searchRouteID;

@end
