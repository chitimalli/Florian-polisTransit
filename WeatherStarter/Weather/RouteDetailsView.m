//
//  RouteDetailsView.m
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import "RouteDetailsView.h"
#import "StopModel.h"
#import "DeparturesModel.h"


@interface RouteDetailsView ()

@end

@implementation RouteDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0)
    {
        if(!self.routeStops)
            return 0;
        
        return self.routeStops.count;

    }else if(tableView.tag == 1)
    {
        if(!self.routeDepartures)
            return 0;
        
        return self.routeDepartures.count;

    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        StopModel* cellRoute = [self.routeStops objectAtIndex:indexPath.row];
        cell.textLabel.text = cellRoute.name;
    }else if(tableView.tag == 1)
    {
        static NSString *CellIdentifier = @"DepartureCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DeparturesModel* cellRoute = [self.routeDepartures objectAtIndex:indexPath.row];
        cell.textLabel.text =[NSString stringWithFormat:@"%@",cellRoute.calendar];
        
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


@end
