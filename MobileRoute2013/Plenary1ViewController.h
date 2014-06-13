//
//  Plenary1ViewController.h
//  Plenary1
//
//  Created by ryan3374 on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GameKit/GameKit.h>
#import <ArcGIS/ArcGIS.h>
#import "LegendDataSource.h"

@class SlideOutView;
@class CustomCalloutViewController;
@class BarChartViewController;
@class RulerView;
@class AGSMapView;
@class AGSGeoprocessor;
@class AGSSymbol;
@class AGSQueryTask;
@class AGSPictureMarkerSymbol;
@class AGSGraphic;
@class AGSGraphicsLayer;
@class AGSClassBreaksRenderer;
@class AGSServiceAreaTask;
@class AGSServiceAreaTaskParameters;
@class AGSFeatureSet;
@class AGSEnvelope;
@class AGSSimpleFillSymbol;
@class AGSCompositeSymbol;
@protocol AGSGeoprocessorDelegate;
@protocol AGSMapViewDelegate;
@protocol AGSMapViewTouchDelegate;
@protocol AGSMapViewCalloutDelegate;
@protocol AGSServiceAreaTaskDelegate;
@protocol AGSInfoTemplateDelegate;
@protocol AGSQueryTaskDelegate;


@interface Plenary1ViewController : UIViewController<AGSGeoprocessorDelegate, GKSessionDelegate, AGSQueryTaskDelegate, AGSInfoTemplateDelegate, AGSMapViewTouchDelegate,CLLocationManagerDelegate, AGSGeoprocessorDelegate, AGSMapViewCalloutDelegate, AGSServiceAreaTaskDelegate, AGSMapViewLayerDelegate> {
	BOOL _hasGraphicsToShare;
	BOOL _extentChangedByCollaborator;
	
	BOOL _isServer;
    UIView *_chooseAreaView;
    UILabel *_selectedAreaLabel;
    UITableView *_legendTableView;
    UIButton *_areaTypeButton;
    UIBarButtonItem *_polygonSegmentedControl;
}

@property (nonatomic, retain) NSArray *chartLabels;
@property (nonatomic, retain) NSArray *chartValues;
@property (nonatomic, retain) BarChartViewController *bcvc;
@property (nonatomic, retain) IBOutlet UIView *demographicPlotView;
@property (nonatomic, retain) IBOutlet UILabel *zoneAreaLabel;
@property (nonatomic, retain) IBOutlet UILabel *householdsLabel;
@property (nonatomic, retain) IBOutlet UILabel *avgHHSizeLabel;
@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *resultsView;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIView *statusView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sharingSegmentControl;
@property (nonatomic, retain) IBOutlet UIView *collaborationStatusView;
@property (nonatomic, retain) IBOutlet UILabel *collaborationStatusLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *collaborationActivityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *acceptBtn;
@property (nonatomic, retain) IBOutlet UIButton *declineBtn;
@property (nonatomic, retain) IBOutlet UIView *chooseAreaView;
@property (nonatomic, retain) IBOutlet UILabel *selectedAreaLabel;
@property (nonatomic, retain) IBOutlet UITableView *legendTableView;
@property (nonatomic, retain) AGSFeatureSet *censusBlockFS;
@property (nonatomic, retain) UIImage *sharingImg;
@property (nonatomic, retain) UIImage *stopSharingImg;
@property (nonatomic, retain) NSMutableArray *peers;
@property (nonatomic, retain) GKSession *gkSession;

@property (nonatomic, retain) SlideOutView *slideOutView;
@property (nonatomic, retain) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) AGSGeoprocessor *gpTask;
@property (nonatomic, retain) AGSGeoprocessor *gpLocAlloc;
@property (nonatomic, retain) AGSQueryTask *censusQueryTask;
@property (nonatomic, retain) AGSQueryTask *populationQueryTask;
@property (nonatomic, retain) AGSPictureMarkerSymbol *schoolPMS;
@property (nonatomic, retain) AGSClassBreaksRenderer *censusBlockPointRenderer;
@property (nonatomic, retain) AGSGraphic *paZone;
@property (nonatomic, retain) CustomCalloutViewController *ccvc;
@property (nonatomic, retain) AGSSymbol *selectedSchoolSym;
@property (nonatomic, retain) AGSSymbol *allRoutesSymbol;
@property (nonatomic, retain) NSMutableArray *selectedSchools; // would need to be reset
@property (nonatomic, retain) AGSServiceAreaTask *serviceAreaTask;
@property (nonatomic, retain) NSOperation *currentServiceAreaOp;
@property (nonatomic, retain) AGSServiceAreaTaskParameters *serviceAreaDefaultParams;
@property (nonatomic, retain) AGSGraphic *serviceAreaGraphic;

@property (nonatomic, retain) NSMutableArray *censusBlockPoints;

@property (nonatomic, retain) NSMutableArray *allSchools;
@property (nonatomic, retain) AGSGraphicsLayer *schoolLayer;
@property (nonatomic, retain) AGSQueryTask *schoolQueryTask;
@property (nonatomic, retain) UIView *xCalloutView;

@property (nonatomic, copy) NSString *waitingPeerId;


// Added for FEMA demo
@property (nonatomic, retain) AGSDynamicMapServiceLayer *areaTypeLayer;
@property (nonatomic, retain) AGSQueryTask *areaQueryTask;
@property (nonatomic, retain) LegendDataSource *legendDataSource;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *polygonSegmentedControl;
// end of adds for FEMA

@property (nonatomic, retain) RulerView *rulerView;

-(IBAction)baseMapChange:(id)sender;

- (IBAction)polygonTypeChange:(id)sender;

-(IBAction)analyze:(id)sender;
-(IBAction)showDRCs:(id)sender;

-(IBAction)zoomToOperationalArea:(id)sender;

-(IBAction)reset;

-(IBAction)locationAllocation:(id)sender;

-(IBAction)showChooseAreaView:(id)sender;



// symbol for protective action zone
- (AGSSimpleFillSymbol*)ergSymbol;
- (AGSSimpleFillSymbol*)ergSymbol2;
- (AGSCompositeSymbol*)schoolSymbol;

-(void)updateCollaborationStatus:(NSString*)status showActivity:(BOOL)activity showAccept:(BOOL)accept;
-(void)updateCollaborationStatusToEmpty;

-(void)updateStatus:(NSString*)status showActivity:(BOOL)activity;
-(void)updateStatusToEmpty;

-(void)showFilteredSchools;

-(void)mapDidEndPanning:(NSNotification *)notification;
-(void)mapDidEndZooming:(NSNotification *)notification;

- (void)sendExtent:(AGSEnvelope*)envelope;
- (void)resetSharingImg;

- (void)getPopulationInfo;
- (void)getCensusBlockPoints;

- (void)endGKSession;

- (NSData *)compressData:(NSData*)data;
- (NSData *)decompressData:(NSData*)data;
@end

