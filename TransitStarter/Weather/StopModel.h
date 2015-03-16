//
//  StopModel.h
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import "JSONModel.h"

@interface StopModel : JSONModel
//id = 47;
//name = TICEN;
//"route_id" = 22;
//sequence = 1;

@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* route_id;
@property (assign, nonatomic) int sequence; 

@end
