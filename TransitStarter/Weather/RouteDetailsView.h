//
//  RouteDetailsView.h
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import <UIKit/UIKit.h>
#import "RoutesHTTPSessionManager.h"

@interface RouteDetailsView : UIViewController<RoutesHTTPClientDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) RoutesHTTPSessionManager *routesHttpSessionMgr;

@property(weak,nonatomic) IBOutlet UITableView *stopsTable;
@property(weak,nonatomic) IBOutlet UITableView *departuresWeekdayTable;
@property(weak,nonatomic) IBOutlet UITableView *departuresSatTable;
@property(weak,nonatomic) IBOutlet UITableView *departuresSunTable;

@property (nonatomic,assign) IBOutlet UILabel *routeStopsText;
@property (nonatomic,assign) IBOutlet UILabel *routedeparturesText; 


@end
