//
//  RulerView.h
//  Plenary1
//
//  Created by Ryan Olson on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
@class Plenary1ViewController;

@interface RulerView : UIView
{
	CGPoint _p1;
	CGPoint _p2;
//	AGSMapView *_mapView;
//	UILabel *_label;
//	Plenary1ViewController *_pvc;
}

@property (nonatomic, retain) AGSMapView *mapView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) Plenary1ViewController *pvc;

@end
