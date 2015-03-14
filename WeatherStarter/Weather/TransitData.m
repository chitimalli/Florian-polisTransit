//
//  TransitDataSingleton.m
//  Transit
//
//  Created by Amar on 3/14/15.
//  Copyright (c) 2015 FaunaFace. All rights reserved.
//

#import "TransitData.h"

@implementation TransitData

+ (id)sharedInstance {
    static TransitData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void) initRoutesDataWith:(NSString*)searchRouteName
{
    self.searchRouteName = searchRouteName;
    self.routes = nil;
    self.routes = [[NSMutableArray alloc] initWithObjects: nil];
}

-(void) initDetailsDataWith:(NSInteger*)searchRouteID
{
    self.searchRouteID      = searchRouteID;
    self.routeDepartures    = nil;
    self.routeStops         = nil;
    self.routeDepartures    = [[NSMutableArray alloc] initWithObjects: nil];
    self.routeStops         = [[NSMutableArray alloc] initWithObjects: nil];
}

@end
