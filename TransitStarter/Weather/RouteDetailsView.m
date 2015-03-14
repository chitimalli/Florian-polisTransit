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
#import "RouteModel.h"


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

-(BOOL)prefersStatusBarHidden{return YES;}

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
    //NSString* routeName     = [[TransitData sharedInstance] searchRouteName];
    [self.navigationController setToolbarHidden:YES animated:YES];

    int searchIndexID       = [[TransitData sharedInstance] searchIndexID];
    RouteModel* RouteToSearch = [[[TransitData sharedInstance] routes] objectAtIndex:searchIndexID];
    
    if(RouteToSearch)
    {
        self.title = RouteToSearch.longName;
        
        {
            [self.routesHttpSessionMgr findStopsByRouteID:RouteToSearch.id];
            [self.routesHttpSessionMgr findDeparturesByRouteID:RouteToSearch.id];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@">> NumRowsFor Table Tag: %d",(int)tableView.tag);
    
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
        int rowCount = (int)[[TransitData sharedInstance] routeDeparturesWeekday].count;

        self.routeStopsText.text = [NSString stringWithFormat:@"%d",rowCount];
        
        return rowCount;
    }else if(tableView.tag == 2)
    {
        int rowCount = (int)[[TransitData sharedInstance] routeDeparturesSat].count;
        
        self.routeStopsText.text = [NSString stringWithFormat:@"%d",rowCount];
        
        return rowCount;
    }else if(tableView.tag == 3)
    {
        int rowCount = (int)[[TransitData sharedInstance] routeDeparturesSun].count;
        
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
        static NSString *CellIdentifier = @"DepartureCellWeekday";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DeparturesModel* cellRoute = [[[TransitData sharedInstance] routeDeparturesWeekday] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",cellRoute.time];
        
    }else if(tableView.tag == 2)
    {
        static NSString *CellIdentifier = @"DepartureCellSat";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DeparturesModel* cellRoute = [[[TransitData sharedInstance] routeDeparturesSat] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",cellRoute.time];
        
    }else if(tableView.tag == 3)
    {
        static NSString *CellIdentifier = @"DepartureCellSun";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DeparturesModel* cellRoute = [[[TransitData sharedInstance] routeDeparturesSun] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",cellRoute.time];
        
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
    //NSLog(@">>>>>>>>>> Stops found : %d",(int)[[TransitData sharedInstance] routeStops].count);
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
                    
                    if([routeDepartureModel.calendar isEqualToString:@"WEEKDAY"])
                        [[[TransitData sharedInstance] routeDeparturesWeekday] addObject:routeDepartureModel];
                    else if([routeDepartureModel.calendar isEqualToString:@"SATURDAY"])
                        [[[TransitData sharedInstance] routeDeparturesSat] addObject:routeDepartureModel];
                    else if([routeDepartureModel.calendar isEqualToString:@"SUNDAY"])
                        [[[TransitData sharedInstance] routeDeparturesSun] addObject:routeDepartureModel];
                    
                }
            }
        }
    }
    
    [self.departuresWeekdayTable reloadData];
    [self.departuresSatTable reloadData];
    [self.departuresSunTable reloadData];
    

   // NSLog(@">>>>>>>>>>> Departurs found : %d",(int)[[TransitData sharedInstance] routeDepartures].count);
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
