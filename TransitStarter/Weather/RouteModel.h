//
//  RouteModel.h
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import "JSONModel.h"

@interface RouteModel : JSONModel

@property (assign, nonatomic) int agencyId;
@property (assign, nonatomic) int id;
@property (assign, nonatomic) NSDate* lastModifiedDate;
@property (strong, nonatomic) NSString* longName;
@property (assign, nonatomic) int shortName; 


@end
