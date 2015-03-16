//
//  TransitMap.m
//  Transit
//
//  Created by Amar on 3/14/15.
//  Copyright (c) 2015 FaunaFace. All rights reserved.
//

#import "TransitMapView.h"

#define METERS_PER_MILE 1609.344

@interface TransitMapView ()

@end

@implementation TransitMapView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Pick a street";
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = -27.6142357; 
    zoomLocation.longitude= -48.4828247;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    [self.mapview setRegion:viewRegion animated:NO];
    
    UILongPressGestureRecognizer *lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self.mapview action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration           = 2.0;
    [self.mapview addGestureRecognizer:lpgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapview];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapview convertPoint:touchPoint toCoordinateFromView:self.mapview];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate         = touchMapCoordinate;//CLLocationCoordinate2DMake(51.49795, -0.174056);
    myAnnotation.title              = @"Street to go";
    myAnnotation.subtitle           = @"streets";
    [self.mapview addAnnotation:myAnnotation];
}

@end
