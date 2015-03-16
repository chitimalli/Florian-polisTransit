//
//  WTTableViewController.m
//  Routes
//
//

#import "RoutesTableViewController.h"
#import "RouteModel.h"
#import "DeparturesModel.h"
#import "StopModel.h"
#import "TransitData.h"

@interface RoutesTableViewController ()
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
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    self.routesHttpSessionMgr = [RoutesHTTPSessionManager sharedRouteHTTPClient];
    self.routesHttpSessionMgr.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}

//-(BOOL)prefersStatusBarHidden{return YES;}

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
    [[TransitData sharedInstance] initRoutesDataWith:@""];
    
    [self.tableView reloadData];
}

- (IBAction)quickSearch:(id)sender
{
    NSString* quickSearchName = @"Governador Irineu Bornhausen";
    
    [[TransitData sharedInstance] initRoutesDataWith:quickSearchName];
    [self.routesHttpSessionMgr findRoutesByName:quickSearchName];
}

- (IBAction)onSearch:(id)sender
{
    NSString* userSearchName = self.searchBar.text;
    
    [[TransitData sharedInstance] initRoutesDataWith:userSearchName];
    [self.routesHttpSessionMgr findRoutesByName:userSearchName];
    
    self.searchBar.text = @"";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![[TransitData sharedInstance] routes])
        return 0;
    
    return [[TransitData sharedInstance] routes].count;
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
    
    RouteModel* cellRoute = [ [[TransitData sharedInstance]routes] objectAtIndex:indexPath.row];
    cell.textLabel.text  = [NSString stringWithFormat:@"%@",cellRoute.longName];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    //RouteModel* cellRoute = [[[TransitData sharedInstance] routes] objectAtIndex:indexPath.row];
    
    //if(cellRoute)
    {
        [[TransitData sharedInstance] initDetailsDataWith:indexPath.row];
        //NSLog(@">>> About to find Stops and departures for RouteID: %d",[cellRoute id]);
    }
}

#pragma mark - Routes HTTP delegate

-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didUpdateWithRoutes:(id)routes
{
    NSDictionary *tempDict  = routes;
    
    if(tempDict)
    {
        NSArray *rows = [tempDict objectForKey:@"rows"];
        
        if(rows && [rows count] > 0)
        {
            NSError *err;
            
            for(int i=0; i< [rows count];++i)
            {
                RouteModel* routeModel =  [[RouteModel alloc] initWithDictionary:[rows objectAtIndex:i] error:&err];
                if(routeModel)
                {
                    
                    [[[TransitData sharedInstance] routes] addObject:routeModel];
                }
            }
        }else
        {
            NSString *streetTried = [[TransitData sharedInstance] searchRouteName];
            
            //NSLog(@">> Err Street name: %@",streetTried);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Routes found"
                                                                message:[NSString stringWithFormat:@"No routes for Street:%@. Try a new Street name..",streetTried]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    [self.tableView reloadData];
}

-(void)routesHTTPClient:(RoutesHTTPSessionManager *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Routes"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


@end