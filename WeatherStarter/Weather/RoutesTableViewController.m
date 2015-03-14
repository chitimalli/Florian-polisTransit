//
//  WTTableViewController.m
//  Routes
//
//

#import "RoutesTableViewController.h"
#import "RouteModel.h"
#import "DeparturesModel.h"
#import "StopModel.h"

@interface RoutesTableViewController ()
@property(nonatomic,retain) NSMutableArray *routes;
@property(nonatomic,retain) NSMutableArray *routeStops;
@property(nonatomic,retain) NSMutableArray *routeDepartures;
@end

@implementation RoutesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    
    self.routesHttpSessionMgr = [RoutesHTTPSessionManager sharedRouteHTTPClient];
    self.routesHttpSessionMgr.delegate = self;
    
}

-(BOOL)prefersStatusBarHidden{return YES;}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        //UITableViewCell *cell = (UITableViewCell *)sender;
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    }
}

#pragma mark - Actions

- (IBAction)clear:(id)sender
{
    self.searchBar.text = @"";
}

- (IBAction)searchTapped:(id)sender
{
    [self.routesHttpSessionMgr findRoutesByName:@"Governador Irineu Bornhausen"];
//    [self.routesHttpSessionMgr findStopsByRouteID:22];
//    [self.routesHttpSessionMgr findDeparturesByRouteID:22];
}

- (IBAction)onSearch:(id)sender
{
    NSLog(@">>> About to search %@",self.searchBar.text);
    [self.routesHttpSessionMgr findRoutesByName:self.searchBar.text];
    self.searchBar.text = @"";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!self.routes)
        return 0;
    
    //NSLog(@">> Table Routes Count: %d",(int)self.routes.count);
    
    return self.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RouteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RouteModel* cellRoute = [self.routes objectAtIndex:indexPath.row];
    cell.textLabel.text = cellRoute.longName;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    RouteModel* cellRoute = [self.routes objectAtIndex:indexPath.row];
    
    if(cellRoute)
    {
        NSLog(@">>> %d",[cellRoute id]);
        
        [self.routesHttpSessionMgr findStopsByRouteID:[cellRoute id]];
        [self.routesHttpSessionMgr findDeparturesByRouteID:[cellRoute id]];

    }
    
}

#pragma mark - Routes HTTP delegate

-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRoutes:(id)routes
{
    self.routes = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSDictionary *tempDict  = routes;
   
    if(tempDict)
    {
        NSArray *rows = [tempDict objectForKey:@"rows"];
        
        if(rows)
        {
            NSError *err;
            
            for(int i=0; i< [rows count];++i)
            {
               RouteModel* routeModel =  [[RouteModel alloc] initWithDictionary:[rows objectAtIndex:i] error:&err];
                if(routeModel)
                {
                    NSLog(@">> %@",routeModel);
                    [self.routes addObject:routeModel];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void)routesStopsHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteStops:(id)routeStops
{
    self.routeStops = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSDictionary *tempDict  = routeStops;
    
    if(tempDict)
    {
        NSArray *rows = [tempDict objectForKey:@"rows"];
        
        if(rows)
        {
            NSError *err;
            
            for(int i=0; i< [rows count];++i)
            {
                StopModel* routeStopModel =  [[StopModel alloc] initWithDictionary:[rows objectAtIndex:i] error:&err];
                if(routeStopModel)
                {
                    NSLog(@">> %@",routeStopModel);
                    [self.routeStops addObject:routeStopModel];
                }
            }
        }
    }
    
    NSLog(@">> Stops : %d",(int)self.routeStops.count);
}

-(void)routesDeparturesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteDepartures:(id)routeDepartures
{
    self.routeDepartures = [[NSMutableArray alloc] initWithObjects:nil];
    
    NSDictionary *tempDict  = routeDepartures;
    
    if(tempDict)
    {
        NSArray *rows = [tempDict objectForKey:@"rows"];
        
        if(rows)
        {
            NSError *err;
            
            for(int i=0; i< [rows count];++i)
            {
                DeparturesModel* routeDepartureModel =  [[DeparturesModel alloc] initWithDictionary:[rows objectAtIndex:i] error:&err];
                if(routeDepartureModel)
                {
                    NSLog(@">> %@",routeDepartureModel);
                    [self.routeDepartures addObject:routeDepartureModel];
                }
            }
        }
    }
    
    NSLog(@">> Departurs : %d",(int)self.routeDepartures.count);
}


-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didFailWithError:(NSError *)error
{
    //NSLog(@"%@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Routes"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end