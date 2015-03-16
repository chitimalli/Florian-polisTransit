//
//  DeparturesModel.h
//  Transit
//
//  Created by Amar on 3/13/15.
//

#import "JSONModel.h"

@interface DeparturesModel : JSONModel
//calendar = WEEKDAY;
//id = 208;
//time = "05:59";

@property (strong, nonatomic) NSString* calendar;
@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString* time; 


@end
