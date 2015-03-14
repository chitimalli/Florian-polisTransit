//
//  RoutesHTTPClient.m
//  Routes
//
//  Created by Amar on 3/12/15.
//

#import "RoutesHTTPSessionManager.h"
static NSString * const AppGluOnlineURLString = @"https://api.appglu.com/v1/queries/";

@implementation RoutesHTTPSessionManager

+ (RoutesHTTPSessionManager *)sharedRouteHTTPClient
{
    static RoutesHTTPSessionManager *_sharedRoutesHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRoutesHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:AppGluOnlineURLString]];
    });
    
    return _sharedRoutesHTTPClient;
    
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"WKD4N7YMA1uiM8V" password:@"DtdTtzMLQlA0hk2C1Yi5pLyVIlAQ68"];
        [self.requestSerializer setValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
    }
    
    return self;
}

-(void)findRoutesByName:(NSString *)routeName
{
    NSLog(@"About to find routes by Name : %@",routeName);
    
    NSString *route = [NSString stringWithFormat:@"%%%@%%", routeName];
    
    NSDictionary *routeNameDict = @{@"stopName": route};
    NSDictionary *parameters = @{@"params": routeNameDict};

    [self POST:@"findRoutesByStopName/run" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(routesHTTPClient:didUpdateWithRoutes:)]) {
            [self.delegate routesHTTPClient:self didUpdateWithRoutes:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(routesHTTPClient:didFailWithError:)]) {
            [self.delegate routesHTTPClient:self didFailWithError:error];
        }
    }];
};

-(void)findStopsByRouteID:(NSInteger)routeID
{
    int rId = (int)routeID;
    NSDictionary *routeNameDict = @{@"routeId": [NSNumber numberWithInt:rId]};
    NSDictionary *parameters = @{@"params": routeNameDict};
    
    [self POST:@"findStopsByRouteId/run" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(routesStopsHTTPClient:didUpdateWithRouteStops:)]) {
            [self.delegate routesStopsHTTPClient:self didUpdateWithRouteStops:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(routesHTTPClient:didFailWithError:)]) {
            [self.delegate routesHTTPClient:self didFailWithError:error];
        }
    }];
    
};

-(void)findDeparturesByRouteID:(NSInteger)routeID
{
    int rId = (int)routeID;
    NSDictionary *routeNameDict = @{@"routeId": [NSNumber numberWithInt:rId]};
    NSDictionary *parameters = @{@"params": routeNameDict};
    
    [self POST:@"findDeparturesByRouteId/run" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(routesDeparturesHTTPClient:didUpdateWithRouteDepartures:)]) {
            [self.delegate routesDeparturesHTTPClient:self didUpdateWithRouteDepartures:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(routesHTTPClient:didFailWithError:)]) {
            [self.delegate routesHTTPClient:self didFailWithError:error];
        }
    }];
    
};


@end
