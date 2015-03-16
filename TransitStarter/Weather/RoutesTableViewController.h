//
//  WTTableViewController.h
//  Routes
//
//

#import <UIKit/UIKit.h>
#import "RoutesHTTPSessionManager.h"

@interface RoutesTableViewController : UITableViewController<RoutesHTTPClientDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property(nonatomic) RoutesHTTPSessionManager *routesHttpSessionMgr;
@property(nonatomic,weak) IBOutlet UITextField *searchBar;
@property(nonatomic,weak) IBOutlet UIButton    *cancelBtn;

// Actions
- (IBAction)onSearch:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)quickSearch:(id)sender;



@end