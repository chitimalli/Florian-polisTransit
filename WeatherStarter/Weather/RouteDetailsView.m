//
//  RouteDetailsView.m
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import "RouteDetailsView.h"
#import "StopModel.h"
#import "DeparturesModel.h"
#import "TransitData.h"


@interface RouteDetailsView ()

@end

@implementation RouteDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routesHttpSessionMgr = [RoutesHTTPSessionManager sharedRouteHTTPClient];
    self.routesHttpSessionMgr.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    NSString* routeName = [[TransitData sharedInstance] searchRouteName];
    
    if(routeName)
        self.title = routeName;
    
    int searchRouteID = [[TransitData sharedInstance] searchRouteID];
    
    if(searchRouteID>0)
    {
        [self.routesHttpSessionMgr findStopsByRouteID:searchRouteID];
        [self.routesHttpSessionMgr findDeparturesByRouteID:searchRouteID];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@">> NumRowsFor Table Tag: %d",(int)tableView.tag);
    
    if(tableView.tag == 0)
    {
//        if(![[TransitData sharedInstance] routeStops])
//            return 0;
        //NSLog(@">> Route Stops");
        int rowCount = (int)[[TransitData sharedInstance] routeStops].count;
        
        self.routeStopsText.text = [NSString stringWithFormat:@"%d",rowCount];
        return rowCount;

    }else if(tableView.tag == 1)
    {
//        if(![[TransitData sharedInstance] routeDepartures])
//            return 0;

        //NSLog(@"++ Route Departures");

        int rowCount = (int)[[TransitData sharedInstance] routeDepartures].count;

        self.routeStopsText.text = [NSString stringWithFormat:@"%d",rowCount];
        
        return rowCount;
    }
    
    //NSLog(@"-- Returning default count 0");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"** CellForIndexPath Table Tag: %d",(int)tableView.tag);

    UITableViewCell *cell = nil;
    if(tableView.tag == 0)
    {
        static NSString *CellIdentifier = @"StopCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        StopModel* cellRoute = [[[TransitData sharedInstance] routeStops] objectAtIndex:indexPath.row];
        cell.textLabel.text  =  [NSString stringWithFormat:@"%d:%@",cellRoute.id,cellRoute.name];
    }else if(tableView.tag == 1)
    {
        static NSString *CellIdentifier = @"DepartureCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DeparturesModel* cellRoute = [[[TransitData sharedInstance] routeDepartures] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d : %@ : %@",cellRoute.id,cellRoute.calendar,cellRoute.time];
        
    }
    
    if(cell == nil)
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
    else
        return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Route Details Loaded
//-(void)routesStopsHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteStops:(id)routeStops{}

-(void)routesStopsHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteStops:(id)routeStops
{
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
                    //NSLog(@">> %@",routeStopModel);
                    [[[TransitData sharedInstance] routeStops] addObject:routeStopModel];
                }
            }
        }
    }
    [self.stopsTable reloadData];
    NSLog(@">>>>>>>>>> Stops found : %d",(int)[[TransitData sharedInstance] routeStops].count);
}

-(void)routesDeparturesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRouteDepartures:(id)routeDepartures
{
    
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
                    //NSLog(@">> %@",routeDepartureModel);
                    [[[TransitData sharedInstance] routeDepartures] addObject:routeDepartureModel];
                }
            }
        }
    }
    [self.departuresTable reloadData];

    NSLog(@">>>>>>>>>>> Departurs found : %d",(int)[[TransitData sharedInstance] routeDepartures].count);
}


-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didFailWithError:(NSError *)error
{
    //NSLog(@"%@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Details"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end
