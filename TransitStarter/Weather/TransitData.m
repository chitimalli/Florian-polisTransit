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

-(void) initDetailsDataWith:(NSInteger*)searchIndexID
{
    self.searchIndexID      = searchIndexID;

    self.routeDeparturesWeekday = nil;
    self.routeDeparturesSat     = nil;
    self.routeDeparturesSun     = nil;
    
    self.routeStops                 = nil;
    self.routeDeparturesWeekday     = [[NSMutableArray alloc] initWithObjects: nil];
    self.routeDeparturesSat         = [[NSMutableArray alloc] initWithObjects: nil];
    self.routeDeparturesSun         = [[NSMutableArray alloc] initWithObjects: nil];
    
    self.routeStops                 = [[NSMutableArray alloc] initWithObjects: nil];
}

@end
