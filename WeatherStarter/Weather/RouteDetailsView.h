//
//  RouteDetailsView.h
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import <UIKit/UIKit.h>

@interface RouteDetailsView : UIViewController//<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) NSMutableArray *routeStops;
@property(nonatomic,retain) NSMutableArray *routeDepartures;

@property(weak,nonatomic) IBOutlet UITableView *stopsTable;
@property(weak,nonatomic) IBOutlet UITableView *departuresTable;

@end
