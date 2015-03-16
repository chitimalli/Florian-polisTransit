//
//  TransitMap.h
//  Transit
//
//  Created by Amar on 3/14/15.
//  Copyright (c) 2015 FaunaFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocation/CoreLocation.h"

@interface TransitMapView : UIViewController<MKMapViewDelegate>//MKMapViewDelegate
@property(weak,nonatomic) IBOutlet MKMapView *mapview;

@end
