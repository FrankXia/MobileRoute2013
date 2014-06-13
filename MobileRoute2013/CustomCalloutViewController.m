//
//  CustomCalloutViewController.m
//  Plenary1
//
//  Created by ryan3374 on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomCalloutViewController.h"
//#import "NSDictionary+AGSAdditions.h"

@interface CustomCalloutViewController ()
@property (nonatomic, retain, readwrite) AGSGraphic *graphic;
@end

@implementation CustomCalloutViewController
@synthesize mapView; // = _mapView;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize zipLabel;
@synthesize graphic; // = _graphic;
@synthesize graphicsLayer;// = _graphicsLayer;
@synthesize pushpinGraphic;// = _pushpinGraphic;
@synthesize target;// = _target;
@synthesize selectedSelector;// = _selectedSelector;
@synthesize serviceAreaSelector;// = _serviceAreaSelector;
@synthesize selectButton;
@synthesize serviceAreaButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
	//
	//
	// NOTE:
	// DO NOT GIVE THIS OUT TO ANYBODY OUTSIDE ESRI!!!!
	//
	//
	NSString *appId = @"ApW8SZU7fZGUZ9eoEfyp6nJZdrcVM7s2TMWqtDx7PWEh74OZBN1lHVaAiZf-fUwZ";
	AGSBingMapLayer *bingLyr = [[AGSBingMapLayer alloc]initWithAppID:appId style:AGSBingMapLayerStyleAerial];
	[self.mapView insertMapLayer:bingLyr withName:@"BaseMap" atIndex:0];
	
	self.graphicsLayer = [[AGSGraphicsLayer alloc]init];
	[self.mapView addMapLayer:self.graphicsLayer withName:@"gl"];
	AGSPictureMarkerSymbol *symbol = [[AGSPictureMarkerSymbol alloc]initWithImageNamed:@"RedPushpin.png"];
	symbol.offset = CGPointMake(9, -16);
	symbol.leaderPoint = CGPointMake(-9, -11);
	self.pushpinGraphic = [AGSGraphic graphicWithGeometry:nil symbol:symbol attributes:nil infoTemplateDelegate:nil];
	[self.graphicsLayer addGraphic:self.pushpinGraphic];
	
	self.view.backgroundColor = [UIColor clearColor];
	
    [super viewDidLoad];
}

-(void)updateWithGraphic:(AGSGraphic*)g{
	self.graphic = g;
	
	double scale = self.mapView.mapScale;
	double targetScale = 8000;
	[self.mapView zoomWithFactor:targetScale/scale atAnchorPoint:CGPointZero animated:NO];
	
	self.pushpinGraphic.geometry = graphic.geometry;
	
	[self.mapView centerAtPoint:graphic.geometry.envelope.center animated:YES];
	self.nameLabel.text = [self.graphic attributeAsStringForKey:@"NAME"];
	self.addressLabel.text = [NSString stringWithFormat:@"Water: %d gallons",[[self.graphic.allAttributes objectForKey:@"WATER"] intValue]];
	self.cityLabel.text = [NSString stringWithFormat:@"Food: %d lbs.", [[graphic.allAttributes objectForKey:@"FOOD"] intValue]];
	self.stateLabel.text = [NSString stringWithFormat:@"First Aid: %d kits", [[graphic.allAttributes objectForKey:@"FIRST_AID"] intValue]];
    //NSObject *obj = [NSDictionary safeGetObjectFromDictionary:graphic.attributes withKey:@"FIRST_AID"];
	self.zipLabel.text = @"";//[NSDictionary safeGetObjectFromDictionary:graphic.attributes withKey:@"ZIP"];
   // NSLog(@"what is: %@", obj);
}

-(IBAction)accessoryButtonPressed:(id)sender{
	[self.target performSelector:self.selectedSelector withObject:self];
}

-(IBAction)serviceAreaButtonPressed:(id)sender{
	[self.target performSelector:self.serviceAreaSelector withObject:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
