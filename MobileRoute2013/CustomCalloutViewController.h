//
//  CustomCalloutViewController.h
//  Plenary1
//
//  Created by ryan3374 on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface CustomCalloutViewController : UIViewController
//{
//	AGSMapView *_mapView;
//	AGSGraphic *_graphic;
//	AGSGraphic *_pushpinGraphic;
//	AGSGraphicsLayer *_graphicsLayer;
//	NSObject *_target;
//	SEL _selectedSelector;
//	SEL _serviceAreaSelector;
//}

@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *stateLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipLabel;

@property (nonatomic, retain) IBOutlet UIButton *selectButton;
@property (nonatomic, retain) IBOutlet UIButton *serviceAreaButton;

@property (nonatomic, retain, readonly) AGSGraphic *graphic;
@property (nonatomic, retain) AGSGraphic *pushpinGraphic;
@property (nonatomic, retain) AGSGraphicsLayer *graphicsLayer;

@property (nonatomic, assign) NSObject *target;
@property (nonatomic, assign) SEL selectedSelector;
@property (nonatomic, assign) SEL serviceAreaSelector;

-(void)updateWithGraphic:(AGSGraphic*)graphic;

-(IBAction)accessoryButtonPressed:(id)sender;
-(IBAction)serviceAreaButtonPressed:(id)sender;

@end
