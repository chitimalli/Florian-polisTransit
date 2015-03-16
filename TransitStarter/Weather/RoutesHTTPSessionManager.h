//
//  RoutesHTTPClient.h
//  Weather
//
//  Created by Amar on 3/12/15.
//

#ifndef Weather_RoutesHTTPClient_h
#define Weather_RoutesHTTPClient_h

#import "AFHTTPSessionManager.h"

@protocol RoutesHTTPClientDelegate;

@interface RoutesHTTPSessionManager : AFHTTPSessionManager
@property (nonatomic, weak) id<RoutesHTTPClientDelegate>delegate;

+ (RoutesHTTPSessionManager *)sharedRouteHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

-(void)findRoutesByName:(NSString *)routeName;
-(void)findStopsByRouteID:(NSInteger)routeID;
-(void)findDeparturesByRouteID:(NSInteger)routeID;

@end

@protocol RoutesHTTPClientDelegate <NSObject>
@optional
-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didFailWithError:(NSError *)error;

-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRoutes:(id)routes;
-(void)routesStopsHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteStops:(id)routeStops;
-(void)routesDeparturesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteDepartures:(id)routeDepartures;


@end

#endif
