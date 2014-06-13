//
//  Plenary1ViewController.m
//  Plenary1
//
//  Created by ryan3374 on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Plenary1ViewController.h"
#import "SlideOutView.h"
#import "MaterialTypeVC.h"
#import "CustomCalloutViewController.h"
//#import "NSDictionary+AGSAdditions.h"
#import "GTMNSData+zlib.h"
#import "CorePlot-CocoaTouch.h"
#import "BingAppId.h"
#import "BarChartViewController.h"
#import "RulerView.h"
#import "AGSDefines.h"
#import <ArcGIS/ArcGIS.h>


@implementation Plenary1ViewController

@synthesize bcvc = _bcvc;
@synthesize chartLabels = _chartLabels;
@synthesize chartValues = _chartValues;
@synthesize demographicPlotView = _demographicPlotView;
@synthesize acceptBtn = _acceptBtn;
@synthesize declineBtn = _declineBtn;
@synthesize chooseAreaView = _chooseAreaView;
@synthesize selectedAreaLabel = _selectedAreaLabel;
@synthesize legendTableView = _legendTableView;
@synthesize waitingPeerId = _waitingPeerId;
@synthesize collaborationStatusView = _collaborationStatusView;
@synthesize collaborationStatusLabel=_collaborationStatusLabel;
@synthesize collaborationActivityIndicator=_collaborationActivityIndicator;
@synthesize zoneAreaLabel = _zoneAreaLabel;
@synthesize householdsLabel = _householdsLabel;
@synthesize avgHHSizeLabel = _avgHHSizeLabel;
@synthesize censusBlockFS = _censusBlockFS;
@synthesize populationQueryTask = _populationQueryTask;
@synthesize sharingImg = _sharingImg;
@synthesize stopSharingImg = _stopSharingImg;
@synthesize peers = _peers;
@synthesize mapView = _mapView;
@synthesize slideOutView = _slideOutView;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize paZone = _paZone;
@synthesize locationManager = _locationManager;
@synthesize gpTask = _gpTask;
@synthesize gpLocAlloc = _gpLocAlloc;
@synthesize censusQueryTask = _censusQueryTask;
@synthesize schoolPMS = _schoolPMS;
@synthesize censusBlockPointRenderer = _censusBlockPointRenderer;
@synthesize ccvc = _ccvc;
@synthesize selectedSchoolSym = _selectedSchoolSym;
@synthesize selectedSchools = _selectedSchools;
@synthesize serviceAreaTask = _serviceAreaTask;
@synthesize currentServiceAreaOp = _currentServiceAreaOp;
@synthesize serviceAreaDefaultParams = _serviceAreaDefaultParams;
@synthesize serviceAreaGraphic = _serviceAreaGraphic;
@synthesize resultsView = _resultsView;
@synthesize statusLabel = _statusLabel;
@synthesize activityIndicator = _activityIndicator;
@synthesize censusBlockPoints = _censusBlockPoints;
@synthesize allRoutesSymbol = _allRoutesSymbol;
@synthesize statusView = _statusView;
@synthesize allSchools = _allSchools;
@synthesize schoolLayer = _schoolLayer;
@synthesize schoolQueryTask = _schoolQueryTask;
@synthesize xCalloutView = _xCalloutView;
@synthesize gkSession = _gkSession;
@synthesize sharingSegmentControl = _sharingSegmentControl;
@synthesize rulerView = _rulerView;

// added for FEMA demo
@synthesize areaTypeLayer;
@synthesize areaQueryTask;
@synthesize legendDataSource;
@synthesize polygonSegmentedControl = _polygonSegmentedControl;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    
    // Set the client ID, updated on June 12, 2014. Todo: add ArcGIS standard license to remove the developer water mark
    NSError *error;
    NSString* clientID = @"<baMSCwEnNolQ5867";
    [AGSRuntimeEnvironment setClientID:clientID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }
    
    
	// Setup mapView, add first layer
	[self.mapView enableWrapAround];
	self.mapView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	self.mapView.showMagnifierOnTapAndHold = YES;
    
    [self.mapView addMapLayer:[AGSOpenStreetMapLayer openStreetMapLayer] withName:@"BaseMap"];
    
//	UIView<AGSLayerView> *v = [self.mapView addMapLayer:[AGSOpenStreetMapLayer openStreetMapLayer] withName:@"BaseMap"];
//	v.drawDuringPanning = YES;
//	v.drawDuringZooming = YES;
    
    self.mapView.touchDelegate = self;
    self.mapView.layerDelegate = self;
    AGSEnvelope *initialEnvelope = [AGSEnvelope envelopeWithXmin:-8947300 
                                                            ymin:2966200 
                                                            xmax:-8910700 
                                                            ymax:2982600 
                                                spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:initialEnvelope animated:NO];
	
	//
	// insert ruler view
	self.rulerView = [[RulerView alloc]initWithFrame:self.view.bounds];
	self.rulerView.mapView = self.mapView;
	self.rulerView.pvc = self;
	self.rulerView.backgroundColor = [UIColor clearColor];
	self.rulerView.hidden = YES;
	self.rulerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
	UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	self.rulerView.userInteractionEnabled = YES;
	[self.view insertSubview:self.rulerView atIndex:1];
	
	
	//
	// insert slide-out view
	float tbHeight = 0; //44
	CGRect fsv = CGRectMake(0, tbHeight, self.view.frame.size.width, self.view.frame.size.height-tbHeight);
	self.slideOutView = [[SlideOutView alloc]initWithFrame:fsv];
	[self.view insertSubview:self.slideOutView atIndex:2];
	
	
	//
	// setup location manager
	CLLocationManager *lm = [[CLLocationManager alloc] init];
	self.locationManager = lm;
	self.locationManager.delegate = self;
	self.locationManager.headingFilter = 5;
	
	//
	// setup geoprocessor objects
//	NSURL *gpERGUrl = [NSURL URLWithString:kERGByChemical];
//	self.gpTask = [AGSGeoprocessor geoprocessorWithURL:gpERGUrl];
//	self.gpTask.delegate = self;
//	self.gpTask.outputSpatialReference = [AGSSpatialReference webMercatorSpatialReference];
	
	NSURL *gpLocAllocUrl = [NSURL URLWithString:kLocAlloc];
	self.gpLocAlloc = [AGSGeoprocessor geoprocessorWithURL:gpLocAllocUrl];
	self.gpLocAlloc.delegate = self;
	self.gpLocAlloc.outputSpatialReference = [AGSSpatialReference webMercatorSpatialReference];
	
	//
	// setup query task objects
	NSURL *queryTaskUrl = [NSURL URLWithString:kCensusBlockPoints];
	self.censusQueryTask = [AGSQueryTask queryTaskWithURL:queryTaskUrl];
	self.censusQueryTask.delegate = self;
	
	NSURL *popQueryTaskUrl = [NSURL URLWithString:kCensusBlockGroup];
	self.populationQueryTask = [AGSQueryTask queryTaskWithURL:popQueryTaskUrl];
	self.populationQueryTask.delegate = self;
	
	//
	// setup custom callout view for schools/facilities
	self.ccvc = [[CustomCalloutViewController alloc]initWithNibName:@"CustomCalloutViewController" bundle:nil];
	self.ccvc.target = self;
	self.ccvc.selectedSelector = @selector(schoolSelected:);
	self.ccvc.serviceAreaSelector = @selector(serviceAreaForSchool:);
	self.mapView.callout.customView = self.ccvc.view;
	self.mapView.callout.margin = CGSizeMake(12, 12);
	self.mapView.callout.cornerRadius = 10;
	self.mapView.calloutDelegate = self;
	self.mapView.callout.color = [[UIColor blackColor] colorWithAlphaComponent:.35];
	self.mapView.callout.highlight = [[UIColor darkGrayColor] colorWithAlphaComponent:.75];
	
	//
	// initialize our selected schools array
	self.selectedSchools = [NSMutableArray array];
	
	//
	// initialize our census block points
	self.censusBlockPoints = [NSMutableArray array];
	
	//
	// make our status view look good
	self.statusView.layer.cornerRadius = 6;
	self.statusView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.statusView.layer.borderWidth = 1;
	self.statusView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
	
	// collaboration status
	self.collaborationStatusView.layer.cornerRadius = 6;
	self.collaborationStatusView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.collaborationStatusView.layer.borderWidth = 1;
	self.collaborationStatusView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	
	//
	// setup callout view for removing service area graphic
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame = CGRectMake(0, 0, 24, 24);
	[btn setImage:[UIImage imageNamed:@"blackX24.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(xCalloutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	self.xCalloutView = btn;
	
	
	// graphics layer
	self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	self.graphicsLayer.renderer = self.censusBlockPointRenderer;
	[self.mapView addMapLayer:self.graphicsLayer withName:@"gl"];
	
	// school layer
	self.schoolLayer = [AGSGraphicsLayer graphicsLayer];
	self.schoolLayer.renderer = [[AGSSimpleRenderer alloc] initWithSymbol:self.schoolPMS];
	[self.mapView addMapLayer:self.schoolLayer withName:@"schoolLayer"];
	
    // go ahead and get the DRCs (formerly schools in the plenary demo)
    [self showDRCs:nil];
    
    // add the default polygon layer
    [self polygonTypeChange:nil];
	
	// add observers for mapView notifications (pan/zoom)
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapDidEndZooming:) name:@"MapDidEndZooming" object:self.mapView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapDidEndPanning:) name:@"MapDidEndPanning" object:self.mapView];
	
	// 
	// initialize our BOOL's
	_hasGraphicsToShare = NO;
	_extentChangedByCollaborator = NO;
	_isServer = NO;
	
    [self showChooseAreaView:nil];
    
    // legend
    self.legendDataSource = [[LegendDataSource alloc] init];
    self.legendDataSource.legendTableView = self.legendTableView;
    self.legendTableView.dataSource = self.legendDataSource;
	
    [super viewDidLoad];
}

-(void)xCalloutButtonPressed:(id)sender{
	[self.graphicsLayer removeGraphic:self.serviceAreaGraphic];
	[self.graphicsLayer refresh];
	self.serviceAreaDefaultParams.facilities = nil;
	self.mapView.callout.hidden = YES;
}

-(void)schoolSelected:(CustomCalloutViewController*)ccvc{
	self.mapView.callout.hidden = YES;
	
	if ([self.selectedSchools containsObject:ccvc.graphic]){
		[self.selectedSchools removeObject:ccvc.graphic];
		ccvc.graphic.symbol = self.schoolPMS;
	}
	else {
		ccvc.graphic.symbol = self.selectedSchoolSym;
		[self.selectedSchools addObject:ccvc.graphic];
	}
	
	[self.schoolLayer refresh];
}

-(BOOL)isFeatureShowingServiceAreaFor:(AGSGraphic*)g{
	AGSFeatureSet *fs = (AGSFeatureSet*)self.serviceAreaDefaultParams.facilities;
	if (fs.features.count > 0 && [(AGSPoint*)[(AGSGraphic*)[fs.features objectAtIndex:0] geometry] isEqual:g.geometry]){
		return YES;
	}
	return NO;
}

-(void)serviceAreaForSchool:(CustomCalloutViewController*)ccvc{
	self.mapView.callout.hidden = YES;
	
	if (!self.serviceAreaDefaultParams){
		if (!self.currentServiceAreaOp){
			[self updateStatus:@"Getting service area params..." showActivity:YES];
			self.currentServiceAreaOp = [self.serviceAreaTask retrieveDefaultServiceAreaTaskParameters];
		}
		return;
	}
	
	[self.currentServiceAreaOp cancel];
	
	// if last one, just remove it (toggle)
	if ([self isFeatureShowingServiceAreaFor:ccvc.graphic]){
		[self.graphicsLayer removeGraphic:self.serviceAreaGraphic];
		[self.graphicsLayer refresh];
		self.serviceAreaDefaultParams.facilities = nil;
		return;
	}
	
	AGSServiceAreaTaskParameters *params = self.serviceAreaDefaultParams;
	params.outSpatialReference = self.mapView.spatialReference;
	params.facilities = [AGSFeatureSet featureSetWithFeatures:[NSArray arrayWithObject:ccvc.graphic]];
	params.defaultBreaks = [NSArray arrayWithObjects:
											[NSNumber numberWithDouble:5.0],
											//[NSNumber numberWithDouble:10.0],
											nil];
	self.currentServiceAreaOp = [self.serviceAreaTask solveServiceAreaWithParameters:params];
	[self updateStatus:@"Solving service area..." showActivity:YES];
}

-(void)serviceAreaTask:(AGSServiceAreaTask *)serviceAreaTask operation:(NSOperation *)op didFailToRetrieveDefaultServiceAreaTaskParametersWithError:(NSError *)error{
	self.currentServiceAreaOp = nil;
	[self updateStatusToEmpty];
}

-(void)serviceAreaTask:(AGSServiceAreaTask *)serviceAreaTask operation:(NSOperation *)op didRetrieveDefaultServiceAreaTaskParameters:(AGSServiceAreaTaskParameters *)serviceAreaParams{
	self.currentServiceAreaOp = nil;
	self.serviceAreaDefaultParams = serviceAreaParams;
	[self updateStatusToEmpty];
	[self serviceAreaForSchool:self.ccvc];
}

-(void)serviceAreaTask:(AGSServiceAreaTask *)serviceAreaTask operation:(NSOperation *)op didFailSolveWithError:(NSError *)error{
	NSLog(@"error: %@", error);
	[self updateStatusToEmpty];
}

- (AGSSimpleFillSymbol*)serviceAreaSym {
	AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbol];
	sfs.color = [[UIColor blueColor] colorWithAlphaComponent:.3];
	
	AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
	sls.color = [UIColor blueColor];
	sls.style = AGSSimpleLineSymbolStyleSolid;
	sls.width = 3;
	
	sfs.outline = sls;
	//sfs.style = AGSSimpleFillSymbolStyleForwardDiagonal;
	return sfs;
}

-(void)serviceAreaTask:(AGSServiceAreaTask *)serviceAreaTask operation:(NSOperation *)op didSolveServiceAreaWithResult:(AGSServiceAreaTaskResult *)serviceAreaTaskResult{
	
	[self.graphicsLayer removeGraphic:self.serviceAreaGraphic];
	
	AGSSymbol *sym = [self serviceAreaSym];
	//AGSMutableEnvelope *env = nil;
	for (AGSGraphic *pg in serviceAreaTaskResult.serviceAreaPolygons){
		pg.symbol = sym;
		[self.graphicsLayer addGraphic:pg];
		//if (!env) env = [[pg.geometry.envelope mutableCopy]autorelease];
		//else [env unionWithEnvelope:pg.geometry.envelope];
		self.serviceAreaGraphic = pg;
		pg.infoTemplateDelegate = self;
		//NSLog(@"pg: %@",[[pg.geometry encodeToJSON] JSONRepresentation]);
	}
	//[self.mapView zoomToEnvelope:env animated:YES];
	//self.mapView.callout.hidden = YES;
	[self.graphicsLayer refresh];
	
	_hasGraphicsToShare = YES;
	
	[self updateStatusToEmpty];
}


#pragma UIVIew overrides

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setPolygonSegmentedControl:nil];
    [self setLegendTableView:nil];
    [self setSelectedAreaLabel:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(IBAction)baseMapChange:(id)sender{
	UISegmentedControl *segControl = (UISegmentedControl*)sender;
	
	[self.mapView removeMapLayerWithName:@"BaseMap"];
	
	if (segControl.selectedSegmentIndex == 0){
		// Streets
		[self.mapView insertMapLayer:[AGSOpenStreetMapLayer openStreetMapLayer] withName:@"BaseMap" atIndex:0];
	}
	else if (segControl.selectedSegmentIndex == 1){
		// Aerial
		
		AGSBingMapLayer *bingLyr = [[AGSBingMapLayer alloc]initWithAppID:kBingAppId style:AGSBingMapLayerStyleAerialWithLabels];
		[self.mapView insertMapLayer:bingLyr withName:@"BaseMap" atIndex:0];
	}
	else if (segControl.selectedSegmentIndex == 2){
		// Satellite
		[self.mapView insertMapLayer:[AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"]] withName:@"BaseMap" atIndex:0];
	}
	else if (segControl.selectedSegmentIndex == 3){
		// Topo
		[self.mapView insertMapLayer:[AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:[NSURL URLWithString:@"http://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]] withName:@"BaseMap" atIndex:0];
	}
	
//	UIView<AGSLayerView> *v = (UIView<AGSLayerView>*)[self.mapView.mapLayerViews objectForKey:@"BaseMap"];
//	v.drawDuringPanning = YES;
//	v.drawDuringZooming = YES;
}

- (IBAction)polygonTypeChange:(id)sender {
    // set the area layer by the chosen type
    if (nil != self.areaTypeLayer) {
        [self.mapView removeMapLayerWithName:self.areaTypeLayer.name];
    }
    UISegmentedControl *areaTypeSelector = (UISegmentedControl *)sender;
    NSLog(@"kFloodPolygons=%@, # of layers=%d", kFloodPolygons, [self.mapView.mapLayers count]);
    
    if (nil == areaTypeSelector || areaTypeSelector.selectedSegmentIndex == 0) {
        self.areaTypeLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:kFloodPolygons]];
    } else {
        self.areaTypeLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:kDamagePolygons]];
    }
    self.areaTypeLayer.name = @"AreaTypeLayer";
    
    NSLog(@"layer name=%@", self.areaTypeLayer.name);
    self.areaTypeLayer.transparent = YES;
    [self.mapView insertMapLayer:self.areaTypeLayer withName:self.areaTypeLayer.name atIndex:1];

    AGSDynamicMapServiceLayer *layer = (AGSDynamicMapServiceLayer*)[self.mapView mapLayerForName:self.areaTypeLayer.name];
    layer.opacity = 0.5;
    
//    UIView<AGSLayerView> *layerView = [self.mapView insertMapLayer:self.areaTypeLayer withName:self.areaTypeLayer.name atIndex:1];
//    layerView.alpha = 0.5;
}


-(void)showResultsView{
	[self.locationManager stopUpdatingHeading];
	
	[self updateStatusToEmpty];
	self.resultsView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.resultsView.layer.borderWidth = 1.0;
	//self.resultsView.backgroundColor = [UIColor clearColor];
	
//	self.bcvc = [[BarChartViewController alloc] initWithNibName:@"BarChartViewController" 
//																		  bundle:nil];
//	[self.demographicPlotView addSubview:self.bcvc.view];

	self.bcvc = [[BarChartViewController alloc] initWithNibName:@"BarChartViewController"
                                                          labels:self.chartLabels 
                                                          values:self.chartValues];
    [self.demographicPlotView addSubview:self.bcvc.view];
    
	NSLog(@"==== bar chart view: %@", self.bcvc.view);

	self.slideOutView.inputView = self.resultsView;
}

//- (BarChartViewController*)bcvc {
//	if (_bcvc == nil) {
//		self.bcvc = [[[BarChartViewController alloc] initWithNibName:@"BarChartViewController" 
//															  labels:self.chartLabels 
//															  values:self.chartValues] autorelease];
//	}
//	return _bcvc;
//}

-(IBAction)reset{
	[self updateCollaborationStatusToEmpty];
	[self updateStatusToEmpty];
	
	// reset to navigate mode
	self.sharingSegmentControl.selectedSegmentIndex = 0;
	
	_hasGraphicsToShare = NO;
	_isServer = NO;
	_extentChangedByCollaborator = NO;
	
	// remove plot, otherwise it will be retained by this view controller
	[self.bcvc.view removeFromSuperview];
	self.bcvc = nil;
	
	[self.currentServiceAreaOp cancel];
    
	for (AGSGraphic *g in self.allSchools){
		if (g.symbol == self.selectedSchoolSym){
			g.symbol = self.schoolPMS;
		}
	}
    
    [self.schoolLayer refresh];
	self.paZone = nil;
	[self.graphicsLayer removeAllGraphics];
	[self.graphicsLayer refresh];
	[self.selectedSchools removeAllObjects];
	[self.censusBlockPoints removeAllObjects];
	self.mapView.callout.hidden = YES;
//	NSString *materialType = @"Choose Area Type";
//	[self.areaTypeButton setTitle:materialType forState:UIControlStateNormal];
//	[self.areaTypeButton setTitle:materialType forState:UIControlStateSelected];
    [self showChooseAreaView:nil];
    self.mapView.touchDelegate = self;
}

-(IBAction)locationAllocation:(id)sender {	
	if (self.selectedSchools.count == 0){
		return;
	}
	
	if (self.graphicsLayer.graphics.count > 0) {
		NSMutableArray *graphics = [self.graphicsLayer.graphics mutableCopy];
		for (AGSGraphic *g in graphics) {
			if ([g.geometry isKindOfClass:[AGSPolyline class]]) {
				[self.graphicsLayer removeGraphic:g];
			}
		}
		[self.graphicsLayer refresh];
	}
	
	NSMutableArray *gpParams = [NSMutableArray array];
	
	NSMutableArray *features = [NSMutableArray array];
	for (AGSGeometry *geom in self.censusBlockPoints) {
		AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:geom symbol:nil attributes:nil infoTemplateDelegate:nil];
		[features addObject:graphic];
	}
	
	
	//AGSFeatureSet *fs = [AGSFeatureSet featureSetWithFeatures:features];
	AGSFeatureSet *fs = [AGSFeatureSet featureSetWithFeatures:self.selectedSchools];

	AGSGPParameterValue *gpInput1 = [AGSGPParameterValue parameterWithName:kCandidateLocations 
																	  type:AGSGPParameterTypeFeatureRecordSetLayer 
																	 value:fs];
	[gpParams addObject:gpInput1];
	
	//NSLog(@"selected facilities: %d", self.selectedSchools.count);
	
	AGSGPParameterValue *gpInput2 = [AGSGPParameterValue parameterWithName:kNumFacilities
																	  type:AGSGPParameterTypeLong 
																	 value:[NSNumber numberWithInt:self.selectedSchools.count]];
	[gpParams addObject:gpInput2];
	
	AGSGraphic *g1 = [AGSGraphic graphicWithGeometry:self.paZone.geometry 
											  symbol:nil 
										  attributes:nil 
								infoTemplateDelegate:nil];
	AGSFeatureSet *selPolyFS = [AGSFeatureSet featureSetWithFeatures:[NSArray arrayWithObject:g1]];
	AGSGPParameterValue *gpInput3 = [AGSGPParameterValue parameterWithName:kSelectionPoly 
																	  type:AGSGPParameterTypeFeatureRecordSetLayer 
																	 value:selPolyFS];
	[gpParams addObject:gpInput3];

	NSMutableArray *polyBarriersFeatures = [NSMutableArray array];
	AGSSpatialReference *sr102100 = [AGSSpatialReference webMercatorSpatialReference];
	AGSMutablePolygon *pgon = [[AGSMutablePolygon alloc] initWithSpatialReference:sr102100];
	[pgon addRingToPolygon];
	AGSGraphic *polyGraphic = [AGSGraphic graphicWithGeometry:pgon symbol:nil attributes:nil infoTemplateDelegate:nil];
	[polyBarriersFeatures addObject:polyGraphic];
	AGSFeatureSet *polyBarriers = [AGSFeatureSet featureSetWithFeatures:polyBarriersFeatures];
	AGSGPParameterValue *gpInput4 = [AGSGPParameterValue parameterWithName:kPolyBarriers 
																	  type:AGSGPParameterTypeFeatureRecordSetLayer 
																	 value:polyBarriers];
	[gpParams addObject:gpInput4];

	[self.gpLocAlloc submitJobWithParameters:gpParams];
	
	[self updateStatus:@"Locating routes..." showActivity:YES];
}
	
-(IBAction)zoomToOperationalArea:(id)sender{
	// @todo TEST PURPOSES
	// naperville, feature layer for erg facilities requires this
	//AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-9852350.760815207 
//												ymin:5094069.313036005 
//												xmax:-9774079.243851293 
//												ymax:5151244.21019324
//									spatialReference:self.mapView.spatialReference];
	
	// naperville 2 (little more zoomed)
	//  xmin = -9840922.580659, ymin = 5106408.653921, xmax = -9801786.822177, ymax = 5134996.102499, spatial reference: [AGSSpatialReference: wkid = 3857, wkt = null]
	AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-9819363.569349
												ymin:5122410.511424
												xmax:-9810374.459169
												ymax:5128976.775501
									spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
	
//	AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-9838286.347610753 
//												ymin:5094145.75006429 
//												xmax:-9760014.830646839 
//												ymax:5151320.647221525 
//									spatialReference:self.mapView.spatialReference];
// Redlands
//	AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:-13057183.373498073 
//												ymin:4028078.5165711953 
//												xmax:-13037615.494257094 
//												ymax:4042372.2408605036
//									spatialReference:self.mapView.spatialReference];
	[self.mapView zoomToEnvelope:env animated:YES];
}

-(IBAction)shareClicked:(id)sender{
}

#pragma mark Layer Delegate
//- (void)mapView:(AGSMapView *) mapView didLoadLayerForLayerView:(UIView<AGSLayerView> *) layerView {
//	//Add legend for each layer added to the map
//	[self.legendDataSource addLegendForLayer:(AGSLayer *)layerView.agsLayer];
//}


#pragma mark Sketch Tools

-(IBAction)showChooseAreaView:(id)sender{
	[self updateStatusToEmpty];
	
	if (self.slideOutView.inputView != self.chooseAreaView){

		self.chooseAreaView.layer.borderColor = [UIColor whiteColor].CGColor;
		self.chooseAreaView.layer.borderWidth = 1.0;

		//self.chooseAreaView.backgroundColor = [UIColor clearColor];
		self.slideOutView.inputView = self.chooseAreaView;
	}
	
	self.mapView.callout.hidden = YES;
}

-(IBAction)areaTypeBtnClicked:(id)sender {
//	NSString *curMat = self.areaTypeButton.titleLabel.text;
//	if ([curMat isEqualToString:@"Choose Area Type"]) {
//		curMat = nil;
//	}
//	MaterialTypeVC *materialVC = [[MaterialTypeVC alloc] initWithNibName:@"MaterialTypeVC" material:curMat];
//	materialVC.delegate = self;
//	materialVC.modalPresentationStyle = UIModalPresentationFormSheet;
//	materialVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//	materialVC.didSelectMaterial = @selector(selectedMaterial:);
//	[self presentModalViewController:materialVC animated:YES];
//	[materialVC release];
}	

- (void)selectedMaterial:(NSString*)materialType {
	//NSLog(@"selected material");
	if (materialType != nil) {
		//self.materialBtn.titleLabel.text = materialType;
		//[self.areaTypeButton setTitle:materialType forState:UIControlStateNormal];
		//[self.areaTypeButton setTitle:materialType forState:UIControlStateSelected];
        
        // set the area layer by the chosen type
        if (nil != self.areaTypeLayer) {
            [self.mapView removeMapLayerWithName:self.areaTypeLayer.name];
        }
        
        if ([materialType isEqualToString:@"Flood Risk"]) {
            self.areaTypeLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:kFloodPolygons]];
        } else {
            self.areaTypeLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:[NSURL URLWithString:kDamagePolygons]];
        }
        
        self.areaTypeLayer.transparent = YES;
        
//        UIView<AGSLayerView> *layerView = [self.mapView insertMapLayer:self.areaTypeLayer withName:self.areaTypeLayer.name atIndex:1];
//        layerView.alpha = 0.5;
	}
}

#pragma mark locationManager 

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	[UIView beginAnimations:@"rotateCompass" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	//NSLog(@"bearing: %f", newHeading.trueHeading);
	//NSLog(@"bearing: %f", newHeading.magneticHeading);

}

#pragma mark Analysis

-(IBAction)analyze:(id)sender {
	// no longer needed?
}

#pragma mark drcLayer

- (IBAction)showDRCs:(id)sender {
	if (!self.allSchools) {
		self.allSchools = [NSMutableArray array];
		// do this stuff
		//school query task
		self.schoolQueryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:kERGFacilities]];
		self.schoolQueryTask.delegate = self;
		
		AGSQuery *query = [[AGSQuery alloc] init];
		query.where = @"1=1";
		query.outFields = [NSArray arrayWithObject:@"*"];
		query.returnGeometry = YES;
		query.outSpatialReference = [AGSSpatialReference webMercatorSpatialReference];
		
		[self.schoolQueryTask executeWithQuery:query];
	}
	else {
		// school query already done...just 

		[self showFilteredSchools];
	}
}

- (void)showFilteredSchools {
	[self.schoolLayer removeAllGraphics];
	
	if (!self.paZone) {
		[self.schoolLayer addGraphics:self.allSchools];
	}
	else {
		AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
		AGSPolygon *bufferedZone = [engine bufferGeometry:self.paZone.geometry byDistance:100.0];
		for (AGSGraphic *g in self.allSchools) {
			if (![engine geometry:bufferedZone containsGeometry:g.geometry]) {
				[self.schoolLayer addGraphic:g];
			}
		}		
	}

	_hasGraphicsToShare = YES;
	
	[self.schoolLayer refresh];
}

#pragma mark AGSGeoprocessorDelegate

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op jobDidFail:(AGSGPJobInfo *)jobInfo {
	if (geoprocessor == self.gpTask) {
		NSLog(@"erg gp failed");
	}
	else if (geoprocessor == self.gpLocAlloc) {
		NSLog(@"loc alloc failed");
	}
	[self updateStatusToEmpty];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op jobDidSucceed:(AGSGPJobInfo *)jobInfo {
	//NSLog(@"job succeeded");
	if (geoprocessor == self.gpTask) {
		NSLog(@"querying data");
		[self.gpTask queryResultData:jobInfo.jobId paramName:kERGOutput];
	}
	else if (geoprocessor == self.gpLocAlloc) {
		NSLog(@"loc alloc succeeded");
		[self updateStatus:@"Querying GP results..." showActivity:YES];
		//[self.gpLocAlloc queryResultData:jobInfo.jobId paramName:kChosenFacilities];
		
		
		[self.gpLocAlloc queryResultData:jobInfo.jobId paramName:kAllRoutes];
	}

}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op ofType:(AGSGPAsyncOperationType)opType didFailWithError:(NSError *)error forJob:(NSString *)jobId {
	if (geoprocessor == self.gpTask) {
		NSLog(@"erg gp op failed");
	}
	else if (geoprocessor == self.gpLocAlloc) {
		NSLog(@"loc alloc op failed");
	}
	[self updateStatusToEmpty];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor operation:(NSOperation *)op didQueryWithResult:(AGSGPParameterValue *)result forJob:(NSString *)jobId {
	NSLog(@"queried result data");
	
	if (geoprocessor == self.gpTask) {
        // this task is no longer used.  Getting the Census data is now done when a polygon is selected.
		
		// use this polygon for query of demographics...
//		AGSGeometry *unionedGeom = [engine unionGeometries:geomArray];
//		AGSMutablePolygon *unionedPoly = [[unionedGeom mutableCopy] autorelease];
//		[unionedPoly setSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:102100]];
//		
//		self.paZone = [AGSGraphic graphicWithGeometry:unionedPoly symbol:[self ergSymbol2] attributes:nil infoTemplateDelegate:nil];
//		
//		if (self.allSchools) {
//			[self showFilteredSchools];
//		}
//		
//		[self.graphicsLayer addGraphic:self.paZone];
//		
//		// README censusQueryTask
//		
//		AGSQuery *query = [AGSQuery query];
//		query.outFields = [NSArray arrayWithObjects:
//						   @"HOUSEHOLDS",
//						   @"POP2000",
//						   nil];
//		query.outSpatialReference = [AGSSpatialReference spatialReferenceWithWKID:102100]; //self.mapView.sr
//		query.geometry = unionedPoly; //self.paZone.geometry
//		query.returnGeometry = YES;
//		query.spatialRelationship = AGSSpatialRelationshipContains;
//		[self.censusQueryTask executeWithQuery:query];
//		
//		
//		[self updateStatus:@"Querying demographics..." showActivity:YES];

	}
	else if (geoprocessor == self.gpLocAlloc) {
		if ([result.name isEqualToString:kAllRoutes]) {			
			// all routes
			NSArray *colorArray = [NSArray arrayWithObjects:
								   [UIColor purpleColor],
								   [UIColor colorWithRed:0.0f green:71.0f/255.0f blue:16.0f/255.0f alpha:1.0f],
								   [UIColor orangeColor],
								   [UIColor colorWithRed:0.0f green:0.0f blue:248.0f/255.0f alpha:1.0f],
								   nil];
			NSMutableDictionary *facilityColors = [NSMutableDictionary dictionary];
			AGSFeatureSet *fs = (AGSFeatureSet*)result.value;
			for (AGSGraphic *g in fs.features) {
				NSString *facId = [g.allAttributes valueForKey:@"FacilityID"];
				
				if ([facilityColors objectForKey:facId]) {
					g.symbol = [facilityColors objectForKey:facId];
				}
				else {
					//create symbol put in dictionary and assign
					AGSCompositeSymbol *cs = [AGSCompositeSymbol compositeSymbol];
					AGSSimpleLineSymbol *outlineSLS = [AGSSimpleLineSymbol simpleLineSymbol];
					outlineSLS.width = 6;
					outlineSLS.color = [UIColor yellowColor];
					[cs addSymbol:outlineSLS];
					AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
					sls.width = 3;
					sls.color = [colorArray objectAtIndex:[facId integerValue] % colorArray.count];
					[cs addSymbol:sls];
					g.symbol = cs;
					[facilityColors setObject:cs forKey:facId];
				}
				
				[self.graphicsLayer addGraphic:g];
			}
			
			// remove hash...
			AGSSymbol *sym2 = [self ergSymbol2];
			for (AGSGraphic *g in self.graphicsLayer.graphics){
				if ([g.symbol isKindOfClass:[AGSSimpleFillSymbol class]]){
					g.symbol = sym2;
				}
			}
			
			_hasGraphicsToShare = YES;
			[self.graphicsLayer refresh];
			[self updateStatusToEmpty];
		}
		else {
			// chosen facilities
		}

	}


}

#pragma mark Symbols

- (AGSSimpleFillSymbol*)ergSymbol {
	AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
	sls.width = 3;
	sls.color = [UIColor redColor];
	AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbol];
	sfs.outline = sls;
	sfs.color = [[UIColor redColor] colorWithAlphaComponent:0.25];
	sfs.style = AGSSimpleFillSymbolStyleForwardDiagonal;
	return sfs;
}

- (AGSSimpleFillSymbol*)ergSymbol2 {
	AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
	sls.width = 3;
	sls.color = [UIColor redColor];
	AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbol];
	sfs.outline = sls;
	sfs.color = [[UIColor redColor] colorWithAlphaComponent:.1];
	return sfs;
}

- (AGSCompositeSymbol*)schoolSymbol {
	AGSCompositeSymbol *sym = [AGSCompositeSymbol compositeSymbol];
	
	AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
	sls.width = 2;
	sls.color = [UIColor blackColor];
	
	AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbol];
	sms.size = CGSizeMake(10, 10);;
	sms.style = AGSSimpleMarkerSymbolStyleCircle;
	sms.color = [UIColor greenColor];
	sms.outline = sls;
    
	[sym addSymbol:sms];
	
	return sym;
}

-(AGSSymbol*)selectedSchoolSym{
	if (!_selectedSchoolSym){
		AGSCompositeSymbol *cs = [[AGSCompositeSymbol alloc]init];
		//AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[[UIColor redColor]colorWithAlphaComponent:.3]];
		AGSSimpleMarkerSymbol *sms = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[[UIColor greenColor]colorWithAlphaComponent:.3]];
		sms.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
		sms.size = CGSizeMake(80, 80);;
		[cs addSymbol:sms];
		[cs addSymbol:[self schoolPMS]];
		_selectedSchoolSym = cs;
	}
	return _selectedSchoolSym;
}

- (AGSSymbol*)allRoutesSymbol {
	if (!_allRoutesSymbol) {
		AGSSimpleLineSymbol *sls = [[AGSSimpleLineSymbol alloc] init];
		sls.color = [UIColor blueColor];
		sls.width = 4;
		_allRoutesSymbol = sls;
	}
	return _allRoutesSymbol;
}


#pragma mark AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
	NSLog(@"query succeeded: %@", featureSet);
	
	if (queryTask == self.censusQueryTask) {
		NSLog(@"census query task");
		AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];		
		//NSLog(@"paZone: %@", self.paZone.geometry);
		for (AGSGraphic *g in featureSet.features) {
			if ([engine geometry:self.paZone.geometry containsGeometry:g.geometry]) {
				//[self.graphicsLayer addGraphic:g];
				
				// add the point to the array so we can use them as input to the
				// location allocation tool
				[self.censusBlockPoints	addObject:g.geometry];
			}
		}

		[self.graphicsLayer refresh];
		
		// @todo - where should this go??
		[self getPopulationInfo];
	}
	else if (queryTask == self.schoolQueryTask) {
		NSLog(@"school query task");
		for (AGSGraphic *g in featureSet.features) {
			g.infoTemplateDelegate = self;
			[self.allSchools addObject:g];
		}
		[self showFilteredSchools];
	}
	else if (queryTask == self.populationQueryTask) {
		NSLog(@"population query task");
		//maybe we dont need following line
		//self.censusBlockFS = featureSet;
		
		int households = 0;
		double avgHHsize = 0.0;
		double zoneArea = 0.0;
		int blocks = featureSet.features.count;
		
		int age5 = 0;
		int age5_17 = 0;
		int age18_21 = 0;
		int age22_29 = 0;
		int age30_39 = 0;
		int age40_49 = 0;
		int age50_64 = 0;
		int age65_up = 0;
		
		for (AGSGraphic *g in featureSet.features) {
			
			// @todo - check validity?
			households += [[g.allAttributes valueForKey:kHouseholds] intValue];
			avgHHsize += [[g.allAttributes valueForKey:kAveHH_SZ] doubleValue];
			zoneArea += [[g.allAttributes valueForKey:kSqMi] doubleValue];
			age5 += [[g.allAttributes valueForKey:kAgeUnder5] intValue];
			age5_17 += [[g.allAttributes valueForKey:kAge5_17] intValue];
			age18_21 += [[g.allAttributes valueForKey:kAge18_21] intValue];
			age22_29 += [[g.allAttributes valueForKey:kAge22_29] intValue];
			age30_39 += [[g.allAttributes valueForKey:kAge30_39] intValue];
			age40_49 += [[g.allAttributes valueForKey:kAge40_49] intValue];
			age50_64 += [[g.allAttributes valueForKey:kAge50_64] intValue];
			age65_up += [[g.allAttributes valueForKey:kAge65_UP] intValue];
		}
		
		self.chartLabels = [NSArray arrayWithObjects:
							@"< 5",
							@"5 - 17",
							@"18 - 21",
							@"22 - 29",
							@"30 - 39",
							@"40 - 49",
							@"50 - 64",
							@"65 & Up",
							nil];
		self.chartValues = [NSArray arrayWithObjects:
							[NSNumber numberWithInt:age5],
							[NSNumber numberWithInt:age5_17],
							[NSNumber numberWithInt:age18_21],
							[NSNumber numberWithInt:age22_29],
							[NSNumber numberWithInt:age30_39],
							[NSNumber numberWithInt:age40_49],
							[NSNumber numberWithInt:age50_64],
							[NSNumber numberWithInt:age65_up],
							nil];
		
		self.householdsLabel.text = [NSString stringWithFormat:@"%d", households];
		self.avgHHSizeLabel.text = [NSString stringWithFormat:@"%.2f", avgHHsize/blocks];
		self.zoneAreaLabel.text = [NSString stringWithFormat:@"%.3f", zoneArea];
		
		
		// show results view
		[self showResultsView];		
	}
    else if (queryTask == self.areaQueryTask)
    {
        NSLog(@"Damage/Flood Polygon query return");
        
        
        for (AGSGraphic *damagePolygon in featureSet.features) {
            
            // since there is a result, stop listening for map touches for now
            self.mapView.touchDelegate = nil;
            
            
            NSString *attributeName;
            UISegmentedControl *polygonSegControl = (UISegmentedControl *)self.polygonSegmentedControl.customView;
            if (polygonSegControl.selectedSegmentIndex == 0) {
                attributeName = @"FLD_ZONE";
            } else {
                attributeName = @"LEVEL";
            }
            self.selectedAreaLabel.text = (NSString *)[damagePolygon.allAttributes valueForKey:attributeName];
          // should be 0 or 1
            self.paZone = [AGSGraphic graphicWithGeometry:damagePolygon.geometry symbol:[self ergSymbol2] attributes:nil infoTemplateDelegate:nil];
            
            if (self.allSchools) {
                [self showFilteredSchools];
            }
            
            [self.graphicsLayer addGraphic:self.paZone];
            
            // README censusQueryTask
            
            AGSQuery *query = [AGSQuery query];
            query.outFields = [NSArray arrayWithObjects:
                               @"HOUSEHOLDS",
                               @"POP2000",
                               nil];
            query.outSpatialReference = [AGSSpatialReference spatialReferenceWithWKID:102100]; //self.mapView.sr
            query.geometry = damagePolygon.geometry; //self.paZone.geometry
            query.returnGeometry = YES;
            query.spatialRelationship = AGSSpatialRelationshipContains;
            [self.censusQueryTask executeWithQuery:query];
            
            
            [self updateStatus:@"Querying demographics..." showActivity:YES];
        }
    }
	
	_hasGraphicsToShare = YES;
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
	NSLog(@"query failed: %@", error);
	
	if (queryTask == self.censusQueryTask) {
		[self getPopulationInfo];
	}
	else if (queryTask == self.schoolQueryTask) {
		
	}
	else if (queryTask == self.populationQueryTask) {
		// show results view
		[self showResultsView];
	}

}

#pragma mark callout delegate

-(void)mapViewDidDismissCallout:(AGSMapView *)mapView{

}

-(BOOL)mapView:(AGSMapView *)mapView shouldShowCalloutForGraphic:(AGSGraphic *)graphic{
	return YES;
}

#pragma mark AGSInfoTemplateDelegate

-(UIView*)customViewForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint{
	if (graphic == self.serviceAreaGraphic){
		return self.xCalloutView;
	}
	else{
		[self.ccvc updateWithGraphic:graphic];
		if ([self.selectedSchools containsObject:graphic]){
			[self.ccvc.selectButton setTitle:@"Unselect" forState:UIControlStateNormal];
			[self.ccvc.selectButton setTitle:@"Unselect" forState:UIControlStateHighlighted];
		}
		else {
			[self.ccvc.selectButton setTitle:@"Select" forState:UIControlStateNormal];
			[self.ccvc.selectButton setTitle:@"Select" forState:UIControlStateHighlighted];
		}
		
		if ([self isFeatureShowingServiceAreaFor:graphic]){
			[self.ccvc.serviceAreaButton setTitle:@"Hide Service" forState:UIControlStateNormal];
			[self.ccvc.serviceAreaButton setTitle:@"Hide Service" forState:UIControlStateHighlighted];
		}
		else {
			[self.ccvc.serviceAreaButton setTitle:@"Service Area" forState:UIControlStateNormal];
			[self.ccvc.serviceAreaButton setTitle:@"Service Area" forState:UIControlStateHighlighted];
		}
		return self.ccvc.view;
	}
}

- (NSString*)titleForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)map {
	return [[graphic allAttributes] valueForKey:@"NAME"];
}

- (NSString*)detailForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)map {
	double area = [[[graphic allAttributes] valueForKey:@"FACAREA"] doubleValue];
	return [NSString stringWithFormat:@"Facility Area: %.2f square feet", area];
}

#pragma mark AGSFeatureLayerQueryDelegate

- (void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didSelectFeaturesWithFeatureSet:(AGSFeatureSet *)featureSet {
	NSLog(@"did select features: %@", featureSet);
}

#pragma mark AGSMapViewDelegate

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
    // Query the polygon layers here with this point.  This will be used instead of chemical plume.
    NSLog(@"Querying damage polygon");
    // query damage polygon layer.
    
    NSString *queryURL;
    UISegmentedControl *polygonSegControl = (UISegmentedControl *)self.polygonSegmentedControl.customView;
    if (polygonSegControl.selectedSegmentIndex == 0) {
        queryURL = [NSString stringWithFormat:@"%@/0", kFloodPolygons];
    } else {
        queryURL = [NSString stringWithFormat:@"%@/0", kDamagePolygons];
    }
    self.areaQueryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:queryURL]];
    AGSQuery *areaQuery = [AGSQuery query];
    areaQuery.returnGeometry = YES;
    areaQuery.geometry = mappoint;
    self.areaQueryTask.delegate = self;
    [self.areaQueryTask executeWithQuery:areaQuery];
}

#pragma mark Lazy Loading

-(UIImage*)sharingImg {
	if (!_sharingImg) {
		self.sharingImg = [UIImage imageNamed:@"Sharing.png"];
	}
	return _sharingImg;
}

-(UIImage*)stopSharingImg {
	if (!_stopSharingImg) {
		self.stopSharingImg = [UIImage imageNamed:@"StopSharing.png"];
	}
	return _stopSharingImg;
}

-(AGSServiceAreaTask*)serviceAreaTask{
	if (!_serviceAreaTask){
		_serviceAreaTask = [[AGSServiceAreaTask alloc]initWithURL:[NSURL URLWithString:kServiceAreaTaskURL]];
		_serviceAreaTask.delegate = self;
	}
	return _serviceAreaTask;
}

- (AGSPictureMarkerSymbol*)schoolPMS {
	if (_schoolPMS == nil) {
		UIImage *img = [UIImage imageNamed:kSchoolImage];
		self.schoolPMS = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:img];
	}
	return _schoolPMS;
}

- (AGSClassBreaksRenderer*)censusBlockPointRenderer {
	if (_censusBlockPointRenderer == nil) {
		self.censusBlockPointRenderer = [[AGSClassBreaksRenderer alloc] init];
		self.censusBlockPointRenderer.field = @"HOUSEHOLDS";
		//self.censusBlockPointRenderer.field = @"POP2000";
		//self.censusBlockPointRenderer.minValue
		
		UIColor *smsColor1 = [[UIColor blueColor] colorWithAlphaComponent:0.30];
		UIColor *smsColor2 = [[UIColor blueColor] colorWithAlphaComponent:0.37];
		UIColor *smsColor3 = [[UIColor blueColor] colorWithAlphaComponent:0.44];
		UIColor *smsColor4 = [[UIColor blueColor] colorWithAlphaComponent:0.50];
		AGSSimpleMarkerSymbol *sms1 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor1];
		sms1.size = CGSizeMake(10, 10);
		sms1.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
		AGSSimpleMarkerSymbol *sms2 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor2];
		sms2.size = CGSizeMake(20, 20);;
		sms2.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
		AGSSimpleMarkerSymbol *sms3 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor3];
		sms3.size = CGSizeMake(30, 30);
		sms3.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
		AGSSimpleMarkerSymbol *sms4 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor4];
		sms4.size = CGSizeMake(40, 40);
		sms4.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];

		AGSClassBreak *classBreak1 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak1"
															  description:@"level 1" 
																 maxValue:25 
																   symbol:sms1];
		AGSClassBreak *classBreak2 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak2"
															  description:@"level 2" 
																 maxValue:50 
																   symbol:sms2];
		AGSClassBreak *classBreak3 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak3"
															  description:@"level 3" 
																 maxValue:100 
																   symbol:sms3];
		AGSClassBreak *classBreak4 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak4"
															  description:@"level 4" 
																 maxValue:200 
																   symbol:sms4];
		self.censusBlockPointRenderer.classBreaks = [NSArray arrayWithObjects:classBreak1, classBreak2, classBreak3, classBreak4, nil];
	}
	return _censusBlockPointRenderer;
}

#pragma mark Collaboration

-(void)updateCollaborationStatus:(NSString*)status showActivity:(BOOL)activity showAccept:(BOOL)accept {

	self.acceptBtn.hidden = !accept;
	self.declineBtn.hidden = !accept;
	
	if (status.length > 0){
		self.collaborationStatusView.hidden = NO;
		
		// animate in...
		[UIView beginAnimations:@"statusIn" context:nil];
		[UIView setAnimationDuration:0.25];
		self.collaborationStatusView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
	}
	
	self.collaborationStatusLabel.text = status;
	if (activity){
		[self.collaborationActivityIndicator startAnimating];
	}
	else {
		[self.collaborationActivityIndicator stopAnimating];
	}
	
}

-(void)updateCollaborationStatusToEmpty {
	[self updateCollaborationStatus:@"" showActivity:NO showAccept:NO];
	//self.collaborationStatusView.hidden = YES;
	
	// animate out
	[UIView beginAnimations:@"collaborationStatusOut" context:nil];
	[UIView setAnimationDuration:0.25];
	self.collaborationStatusView.transform = CGAffineTransformMakeTranslation(self.collaborationStatusView.frame.size.width + 100, 0);
	[UIView commitAnimations];
	
}

-(void)updateStatus:(NSString*)status showActivity:(BOOL)activity{
	
	if (status.length > 0){
		self.statusView.hidden = NO;
		
		// animate in...
		if (!CGAffineTransformEqualToTransform(self.statusView.transform, CGAffineTransformIdentity)){
		[UIView beginAnimations:@"statusIn" context:nil];
		[UIView setAnimationDuration:0.25];
		self.statusView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
	}
	}
	
	self.statusLabel.text = status;
	if (activity){
		[self.activityIndicator startAnimating];
	}
	else {
		[self.activityIndicator stopAnimating];
	}

}

-(void)updateStatusToEmpty{
	[self updateStatus:@"" showActivity:NO];
	//self.statusView.hidden = YES;
	
	// animate out
	[UIView beginAnimations:@"statusOut" context:nil];
	[UIView setAnimationDuration:0.25];
	self.statusView.transform = CGAffineTransformMakeTranslation(self.statusView.frame.size.width + 100, 0);
	[UIView commitAnimations];
}

-(IBAction)startCollaborate:(id)sender {
	
	if (!self.gkSession) {
		if (_isServer) {
			NSLog(@"Server");
			[self updateCollaborationStatus:@"Starting session..." showActivity:YES showAccept:NO];
		}
		else {
			[self updateCollaborationStatus:@"Joining session..." showActivity:YES showAccept:NO];
		}

		self.gkSession = [[GKSession alloc] initWithSessionID:@"Collaboration"
												   displayName:_isServer ? @"Server" : @"Client"
												   sessionMode:_isServer ? GKSessionModeServer : GKSessionModeClient];
														   //sessionMode:GKSessionModePeer] autorelease];
		self.gkSession.available = YES;
		self.gkSession.delegate = self;
		[self.gkSession setDataReceiveHandler:self withContext:nil];
		
		if (self.gkSession) {
			NSLog(@"session created");
		}
				
	}
	else {
		// if we are the server, disconnect all other peers before
		// ending the session
		if (_isServer) {
			for (NSString *peerId in [self.gkSession peersWithConnectionState:GKPeerStateConnected]) {
				[self.gkSession disconnectPeerFromAllPeers:peerId];
			}
		}
		[self endGKSession];
		[self resetSharingImg];
		[self updateCollaborationStatusToEmpty];		
	}
}

-(IBAction)acceptConnection:(id)sender {
	[self.gkSession acceptConnectionFromPeer:self.waitingPeerId error:nil];
}

-(IBAction)declineConnection:(id)sender {
	[self.gkSession denyConnectionFromPeer:self.waitingPeerId];
	[self updateCollaborationStatusToEmpty];
	[self resetSharingImg];
}

-(IBAction)sharingModeChanged:(id)sender{
	NSLog(@"sharing mode changed...");
}

-(void)didAddMaddenGraphic:(AGSGraphic*)g{
	
	if (!self.gkSession.sessionID){
		return;
	}
	
	NSDictionary *msg = [NSMutableDictionary dictionary];
	NSMutableDictionary *graphicsDict = [NSMutableDictionary dictionary];
	[msg setValue:@"graphics" forKey:@"type"];
	[AGSJSONUtility encodeToDictionary:graphicsDict withKey:@"madden" AGSCodingArray:[NSArray arrayWithObject:g]];
	[msg setValue:graphicsDict forKey:@"value"];
	NSString *jsonGraphicsStr = [msg ags_JSONRepresentation];
	NSData *data2 = [jsonGraphicsStr dataUsingEncoding:NSUTF8StringEncoding];
	NSError *err = nil;

	BOOL success = [self.gkSession sendDataToAllPeers:[NSData gtm_dataByGzippingData:data2] withDataMode:GKSendDataReliable error:&err];

	if (!success) {
		NSLog(@"err2: %@", err);
	}
	NSLog(@"did add madden graphic...");
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	NSLog(@"peer conection failed: %@", error);
	if ([[error localizedDescription] isEqualToString:@"The invited peer has declined the connection."]) {
		[self updateCollaborationStatus:@"Connection declined..." showActivity:NO showAccept:NO];
	}
	else {
		[self updateCollaborationStatus:@"Connection failed..." showActivity:NO showAccept:NO];
	}
	[NSTimer scheduledTimerWithTimeInterval:1.0 
									 target:self 
								   selector:@selector(updateCollaborationStatusToEmpty) 
								   userInfo:nil 
									repeats:NO];
	[self resetSharingImg];
	[self endGKSession];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"session failed");
	[self updateCollaborationStatus:@"Session failed..." showActivity:NO showAccept:NO];
	[self resetSharingImg];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"connection request from: %@", peerID);
	self.waitingPeerId = peerID;
	[self updateCollaborationStatus:[NSString stringWithFormat:@"%@ wants to connect...", peerID] 
					   showActivity:NO
						 showAccept:YES];
	
	//[self.gkSession acceptConnectionFromPeer:peerID error:nil];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	NSLog(@"change state: peerID: %@", peerID);
	
	switch (state) {
		case GKPeerStateConnecting:
			[self updateCollaborationStatus:@"Connecting..." showActivity:YES showAccept:NO];
			NSLog(@"connecting to %@", peerID);
			break;
		case GKPeerStateConnected:
			[self updateCollaborationStatus:@"Connected" showActivity:NO showAccept:NO];
			NSLog(@"connected to %@", peerID);
			// @todo - eric, clean this up if you have time.
			if (_hasGraphicsToShare) {
				NSMutableDictionary *msg = [NSMutableDictionary dictionary];
				[msg setValue:[self.mapView.maxEnvelope encodeToJSON] forKey:@"value"];
				[msg setValue:@"extent" forKey:@"type"];
				NSString *jsonStr = [msg ags_JSONRepresentation];
				NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
				NSError *err = nil;

				BOOL success = [self.gkSession sendDataToAllPeers:[NSData gtm_dataByGzippingData:data] withDataMode:GKSendDataReliable error:&err];

				if (!success) {
					NSLog(@"err1: %@", err);
				}
				
				
				[msg removeAllObjects];
				
				NSMutableDictionary *graphicsDict = [NSMutableDictionary dictionary];
				[msg setValue:@"graphics" forKey:@"type"];
				if (self.graphicsLayer.graphics.count > 0) {
					[AGSJSONUtility encodeToDictionary:graphicsDict withKey:@"gl" AGSCodingArray:self.graphicsLayer.graphics];
				}
				
				if (self.schoolLayer.graphics.count > 0) {
					[AGSJSONUtility encodeToDictionary:graphicsDict withKey:@"school" AGSCodingArray:self.schoolLayer.graphics];
				}
				[msg setValue:graphicsDict forKey:@"value"];
				
				//NSLog(@"msg: %@", [graphicsDict valueForKey:@"gl"]);
				
				NSString *jsonGraphicsStr = [msg ags_JSONRepresentation];
				NSData *data2 = [jsonGraphicsStr dataUsingEncoding:NSUTF8StringEncoding];
				
				// compress the data because there is a limit to the amount you can send
				// this sucks

				success = [self.gkSession sendDataToAllPeers:[NSData gtm_dataByGzippingData:data2] withDataMode:GKSendDataReliable error:&err];

				if (!success) {
					NSLog(@"err2: %@", err);
				}
				
			}
			[NSTimer scheduledTimerWithTimeInterval:1.0 
											 target:self 
										   selector:@selector(updateCollaborationStatusToEmpty) 
										   userInfo:nil 
											repeats:NO];
			break;
		case GKPeerStateDisconnected:
			if (_isServer) {
				[self updateCollaborationStatus:@"Client disconnected" showActivity:NO showAccept:NO];
			}
			else {
				[self updateCollaborationStatus:@"Disconnected from server" showActivity:NO showAccept:NO];
			}

			NSLog(@"disconnected from: %@", peerID);
			[self resetSharingImg];
			[self endGKSession];
			
			// kick off timer to fire method to remove collaborationStatusView
			[NSTimer scheduledTimerWithTimeInterval:1.0 
											 target:self 
										   selector:@selector(updateCollaborationStatusToEmpty) 
										   userInfo:nil 
											repeats:NO];
			break;
		case GKPeerStateAvailable:
			NSLog(@"peer available: %@", peerID);
			[self.gkSession connectToPeer:peerID withTimeout:kConnectionTimeout];
			break;
		default:
			break;
	}
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSLog(@"Recieved Data");
	NSString *dataStr = [[NSString alloc] initWithData:[NSData gtm_dataByInflatingData:data]
											   encoding:NSUTF8StringEncoding];
	
	NSDictionary *json = [dataStr ags_JSONValue];
	NSLog(@"recv: %@", json);
	NSString *type = [json objectForKey:@"type"];
	if ([type isEqualToString:@"extent"]) {
		
		// set flag so we don't send the new extent 
		_extentChangedByCollaborator = YES;
		
		NSDictionary *envJson = [json valueForKey:@"value"];
		AGSEnvelope *env = [[AGSEnvelope alloc] initWithJSON:envJson];
		double envW = fabs(env.width - self.mapView.maxEnvelope.width);
		double cX = fabs(env.center.x - self.mapView.maxEnvelope.center.x);
		if ((cX + envW) > 0.0001) {
			[self.mapView zoomToEnvelope:env animated:YES];
		}
	}
	else if ([type isEqualToString:@"graphics"]) {
		NSDictionary *graphicsJson = [json valueForKey:@"value"];
		NSDictionary *schools = [graphicsJson objectForKey:@"school"];
		if (schools) {
			NSArray *graphicsArray = [AGSJSONUtility decodeFromDictionary:graphicsJson withKey:@"school" fromClass:[AGSGraphic class]];
			for (AGSGraphic *g in graphicsArray) {
				g.infoTemplateDelegate = self;
				[self.schoolLayer addGraphic:g];
			}
			[self.schoolLayer refresh];
		}
		
		NSDictionary *gLayer = [graphicsJson objectForKey:@"gl"];
		if (gLayer) {
			NSArray *graphicsArray = [AGSJSONUtility decodeFromDictionary:graphicsJson withKey:@"gl" fromClass:[AGSGraphic class]];
			for (AGSGraphic *g in graphicsArray) {
				g.infoTemplateDelegate = self;
				[self.graphicsLayer addGraphic:g];
			}
			[self.graphicsLayer refresh];
		}
	}

	/*
	NSString *recData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:recData message:peer delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av show];
	[av release];
	 */
    // Read the bytes in data and perform an application-specific action.
}

- (void)endGKSession {
	[self.gkSession disconnectFromAllPeers];
	self.gkSession.available = NO;
	[self.gkSession setDataReceiveHandler:nil withContext:nil];
	self.gkSession.delegate = nil;
	self.gkSession = nil;
}

#pragma mark MapPan/zoomed

-(void)mapDidEndPanning:(NSNotification *)notification {
	if (self.gkSession && !_extentChangedByCollaborator) {
		[self sendExtent:self.mapView.maxEnvelope];
	}
	
	_extentChangedByCollaborator = NO;
}

-(void)mapDidEndZooming:(NSNotification *)notification {
	if (self.gkSession && !_extentChangedByCollaborator) {
		[self sendExtent:self.mapView.maxEnvelope];
	}
	
	_extentChangedByCollaborator = NO;
}

- (void)sendExtent:(AGSEnvelope*)envelope {
	NSLog(@"sending updated extent");
	
	NSMutableDictionary *msg = [NSMutableDictionary dictionary];
	[msg setValue:[envelope encodeToJSON] forKey:@"value"];
	[msg setValue:@"extent" forKey:@"type"];
	[msg setValue:@"" forKey:@"graphicsLayer"];
	NSString *jsonStr = [msg ags_JSONRepresentation];
	NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[self.gkSession sendDataToAllPeers:[NSData gtm_dataByGzippingData:data] withDataMode:GKSendDataReliable error:nil];	
}

- (void)resetSharingImg {

}

- (void)getPopulationInfo {
	AGSQuery *query = [[AGSQuery alloc] init];
	query.geometry = self.paZone.geometry;
	query.outSpatialReference = [AGSSpatialReference spatialReferenceWithWKID:102100];
	query.returnGeometry = NO;
	query.outFields = [NSArray arrayWithObjects:
					   @"POP2000",
					   @"POP2007",
					   @"AGE_UNDER5",
					   @"AGE_5_17",
					   @"AGE_18_21",
					   @"AGE_22_29",
					   @"AGE_30_39",
					   @"AGE_40_49",
					   @"AGE_50_64",
					   @"AGE_65_UP",
					   @"MED_AGE",
					   @"MED_AGE_M",
					   @"MED_AGE_F",
					   @"HOUSEHOLDS",
					   @"AVE_HH_SZ",
					   @"AVE_FAM_SZ",
					   @"SQMI",
					   nil];

//	query.spatialRelationship = AGSSpatialRelationshipContains;
	query.spatialRelationship = AGSSpatialRelationshipIntersects;
	[self.populationQueryTask executeWithQuery:query];
	
	[self updateStatus:@"Querying population info..." showActivity:YES];
}

- (void)getCensusBlockPoints {
//	AGSQuery *query = [AGSQuery query];
//	query.outFields = [NSArray arrayWithObjects:
//					   @"HOUSEHOLDS",
//					   @"POP2000",
//					   nil];
//	query.outSpatialReference = [AGSSpatialReference spatialReferenceWithWKID:102100];
//	[unionedPoly setSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:102100]];
//	query.geometry = unionedPoly;
//	query.returnGeometry = YES;
//	query.spatialRelationship = AGSSpatialRelationshipContains;
//	[self.censusQueryTask executeWithQuery:query];
//	
//	[self updateStatus:@"Querying demographics..." showActivity:YES];
	
}

#pragma mark CorePlot methods

//-(NSUInteger)numberOfRecordsForPlot:(CPPlot*)plot {
//	return 8;
//}
//
//-(NSNumber*)numberForPlot:(CPPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
//	NSArray *vals = [NSArray arrayWithObjects:
//					 [NSNumber numberWithInt:2],
//					 [NSNumber numberWithInt:3],
//					 [NSNumber numberWithInt:4],
//					 [NSNumber numberWithInt:5],
//					 [NSNumber numberWithInt:6],
//					 [NSNumber numberWithInt:7],
//					 [NSNumber numberWithInt:8],
//					 [NSNumber numberWithInt:9],
//					 nil];
//	return [vals objectAtIndex:index];
//}

#pragma mark AGSServiceAreaTaskDelegate

- (NSData *)compressData:(NSData*)data {
	return [NSData gtm_dataByGzippingData:data];
}

- (NSData *)decompressData:(NSData*)data {
	return [NSData gtm_dataByInflatingData:data];
}

#if 0

#pragma mark Demo Code

- (void)analyze:(id)sender {
	
	//
	// setup geoprocessor object
	NSURL *gpTaskUrl = [NSURL URLWithString:kERGByChemical];
	self.gpTask = [AGSGeoprocessor geoprocessorWithURL:gpTaskUrl];
	self.gpTask.delegate = self;
	self.gpTask.outputSpatialReference = self.mapView.spatialReference;
	self.gpTask.interval = 5.0;
	
	NSString *material = @"Chlorine";
	double windDirection = 45.0;
	double windSpeed = 10.0;
	
	AGSPolygon *poly = nil;//(AGSPolygon*)self.sketchGraphicsLayer.geometry;
	
	AGSPoint *centroid = poly.envelope.center;
	
	NSMutableArray *gpParams = [NSMutableArray array];
	
	AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:centroid 
												   symbol:nil 
											   attributes:nil 
									 infoTemplateDelegate:nil];
	
	NSArray *features = [NSArray arrayWithObject:graphic];
	
	AGSFeatureSet *fs = [AGSFeatureSet featureSetWithFeatures:features];
	
	//
	// parameter for spill location
	AGSGPParameterValue *gpInputLocation = [AGSGPParameterValue parameterWithName:kERGIncidentLocation 
																			 type:AGSGPParameterTypeFeatureRecordSetLayer 
																			value:fs];
	[gpParams addObject:gpInputLocation];
	
	// 
	// material type input
	AGSGPParameterValue *gpInputMaterial = [AGSGPParameterValue parameterWithName:kERGMaterialType 
																			 type:AGSGPParameterTypeString 
																			value:material];
	[gpParams addObject:gpInputMaterial];
	
	//
	// wind speed input
	AGSGPParameterValue *gpInputWindSpeed = [AGSGPParameterValue parameterWithName:kERGWindSpeed 
																			  type:AGSGPParameterTypeDouble 
																			 value:[NSNumber numberWithDouble:windSpeed]];
	[gpParams addObject:gpInputWindSpeed];
	
	//
	// wind direction input
	AGSGPParameterValue *gpInputBearing = [AGSGPParameterValue parameterWithName:kERGWindBearing 
																			type:AGSGPParameterTypeDouble 
																		   value:[NSNumber numberWithDouble:windDirection]];
	[gpParams addObject:gpInputBearing];

	[self.gpTask submitJobWithParameters:gpParams];	
}

#pragma mark AGSGeoprocessorDelegate

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor 
		   operation:(NSOperation *)op 
		  jobDidFail:(AGSGPJobInfo *)jobInfo {
	
	// job failed
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"" 
													   delegate:nil 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor 
		   operation:(NSOperation *)op 
	   jobDidSucceed:(AGSGPJobInfo *)jobInfo {

	[self.gpTask queryResultData:jobInfo.jobId paramName:kERGOutput];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor 
		   operation:(NSOperation *)op 
			  ofType:(AGSGPAsyncOperationType)opType 
	didFailWithError:(NSError *)error forJob:(NSString *)jobId {
	
	// error querying results
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"" 
													   delegate:nil 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)geoprocessor:(AGSGeoprocessor *)geoprocessor 
		   operation:(NSOperation *)op 
  didQueryWithResult:(AGSGPParameterValue *)result 
			  forJob:(NSString *)jobId {
	
	// we know that we are going to get 1 feature back
	
	AGSFeatureSet *fs = (AGSFeatureSet*)result.value;
	
	if (fs.features.count == 0) {
		// we didn't get any features back
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" 
													 message:@"No Features Returned!" 
													delegate:nil
										   cancelButtonTitle:@"Ok" 
										   otherButtonTitles:nil];
		[av show];
		[av release];
		return;
	}
	
	
	// pull the protective action zone graphic from the feature set
	// and then add the graphic to the graphics layer
	{
	self.paZone = [fs.features objectAtIndex:0];
	
	// create a symbol for this graphic
	
	AGSSimpleLineSymbol *sls = [AGSSimpleLineSymbol simpleLineSymbol];
	sls.width = 3;
	sls.color = [UIColor redColor];
	
	AGSSimpleFillSymbol *sfs = [AGSSimpleFillSymbol simpleFillSymbol];
	sfs.outline = sls;
	sfs.color = [[UIColor redColor] colorWithAlphaComponent:.1];
	
	self.paZone.symbol = sfs;
			
	[self.graphicsLayer addGraphic:self.paZone];

	// notify layer that we need to redraw
	
	[self.graphicsLayer dataChanged];
	}
	
	//
	// setup query task object
	NSURL *queryTaskUrl = [NSURL URLWithString:kCensusBlockPoints];
	self.censusQueryTask = [AGSQueryTask queryTaskWithURL:queryTaskUrl];
	self.censusQueryTask.delegate = self;
	
	// create the query
	
	AGSQuery *query = [AGSQuery query];
	query.outFields = [NSArray arrayWithObjects:@"HOUSEHOLDS", nil];
	query.outSpatialReference = self.mapView.spatialReference;
	query.geometry = self.paZone.geometry; 
	query.returnGeometry = YES;
	query.spatialRelationship = AGSSpatialRelationshipContains;
	
	// execute the query
	
	[self.censusQueryTask executeWithQuery:query];
}

#pragma mark AGSQueryTaskDelegate

- (void)queryTask:(AGSQueryTask *)queryTask 
		operation:(NSOperation *)op 
 didFailWithError:(NSError *)error {
	
	// query failed
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"" 
													   delegate:nil 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)queryTask:(AGSQueryTask *)queryTask 
		operation:(NSOperation *)op 
		  didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
	
	// assign a renderer to the graphics layer and add the graphics
	
	{
	AGSClassBreaksRenderer *cbpRenderer = [[[AGSClassBreaksRenderer alloc] init] autorelease];
	cbpRenderer.field = @"HOUSEHOLDS";

	UIColor *smsColor1 = [[UIColor blueColor] colorWithAlphaComponent:0.30];
	UIColor *smsColor2 = [[UIColor blueColor] colorWithAlphaComponent:0.37];
	UIColor *smsColor3 = [[UIColor blueColor] colorWithAlphaComponent:0.44];
	UIColor *smsColor4 = [[UIColor blueColor] colorWithAlphaComponent:0.50];
	
	AGSSimpleMarkerSymbol *sms1 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor1];
	sms1.size = 10;
	sms1.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
	
	AGSSimpleMarkerSymbol *sms2 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor2];
	sms2.size = 20;
	sms2.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
	
	AGSSimpleMarkerSymbol *sms3 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor3];
	sms3.size = 30;
	sms3.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
	
	AGSSimpleMarkerSymbol *sms4 = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:smsColor4];
	sms4.size = 40;
	sms4.outline = [AGSSimpleLineSymbol simpleLineSymbolWithColor:[UIColor whiteColor]];
	
	AGSClassBreak *classBreak1 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak1"
														  description:@"level 1" 
															 maxValue:25 
															   symbol:sms1];
	
	AGSClassBreak *classBreak2 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak2"
														  description:@"level 2" 
															 maxValue:50 
															   symbol:sms2];
	
	AGSClassBreak *classBreak3 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak3"
														  description:@"level 3" 
															 maxValue:100 
															   symbol:sms3];
	
	AGSClassBreak *classBreak4 = [[AGSClassBreak alloc] initWithLabel:@"ClassBreak4"
														  description:@"level 4" 
															 maxValue:200 
															   symbol:sms4];
	
	cbpRenderer.classBreaks = [NSArray arrayWithObjects:
											classBreak1, 
											classBreak2, 
											classBreak3, 
											classBreak4, 
											nil];
	
	// assign renderer to our graphics layer
	//self.graphicsLayer.renderer = cbpRenderer;
	
	//[self.graphicsLayer addGraphics:featureSet.features];

	//[self.graphicsLayer dataChanged];
	}
}


-(UIView*)customViewForGraphic:(AGSGraphic *)graphic screenPoint:(CGPoint)screen mapPoint:(AGSPoint *)mapPoint{
	
	// init our custom callout view controller with the NIB we created
	
	self.ccvc = [[[CustomCalloutViewController alloc] initWithNibName:@"CustomCalloutViewController" 
															   bundle:nil] autorelease];
	
	// modify view-specific values
	
	[self.ccvc updateWithGraphic:graphic];

	// return the view to be shown in the callout
	
	return self.ccvc.view;
}

#pragma mark GameKit

-(IBAction)startCollaborate:(id)sender {
	
	NSString *displayName;
	GKSessionMode sessionMode;
	
	if(_isServer) {
		displayName = @"Server";
		sessionMode = GKSessionModeServer;
	}
	else {
		displayName = @"Client";
		sessionMode = GKSessionModeClient;
	}
	
	self.gkSession = [[[GKSession alloc] initWithSessionID:@"Collaboration" 
											   displayName:displayName
											   sessionMode:sessionMode] autorelease];

	self.gkSession.available = YES;
	self.gkSession.delegate = self;

	[self.gkSession setDataReceiveHandler:self withContext:nil];
	
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session 
	connectionWithPeerFailed:(NSString *)peerID 
	  withError:(NSError *)error {
	
	// the connection failed, let's end the session and cleanup
	[self endGKSession];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	
	// the session failed, let's end the session and cleanup
	[self endGKSession];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {

	// we have a connection request, let's accept the connection
	
	[self.gkSession acceptConnectionFromPeer:peerID error:nil];
}

- (void)session:(GKSession *)session 
		   peer:(NSString *)peerID 
 didChangeState:(GKPeerConnectionState)state {
	
	switch (state) {
		case GKPeerStateConnected:

			if (_hasGraphicsToShare) {

				// encode our server's extent to JSON, 
				// compress and send to our peers so they can zoom to it
				
				NSMutableDictionary *msg = [NSMutableDictionary dictionary];
				
				// add the encoded extent
				[msg setValue:[self.mapView.envelope encodeToJSON] forKey:@"value"];
				
				// specify a type for this message
				[msg setValue:@"extent" forKey:@"type"];
				
				// get the string representation of the JSON
				NSString *jsonStr = [msg JSONRepresentation];
				
				// convert string to NSData to send
				NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
				
				NSError *err = nil;
				
				// send the data to all connected peers
				BOOL success = [self.gkSession sendDataToAllPeers:[self compressData:data] 
													 withDataMode:GKSendDataReliable 
															error:&err];
				
				if (!success) {
					NSLog(@"we encountered an error: %@", err);
				}
				
				// prepare to send the graphics over the wire
				
				NSMutableDictionary *msg2 = [NSMutableDictionary dictionary]
				
				// create a dictionary for the graphics
				
				NSMutableDictionary *graphicsDict = [NSMutableDictionary dictionary];
				
				// specify type of the message
				[msg2 setValue:@"graphics" forKey:@"type"];
				
				// if we have graphics in our main graphics layer, encode them to JSON
				if (self.graphicsLayer.graphics.count > 0) {
					[JSONUtility encodeToDictionary:graphicsDict 
											withKey:@"gl" 
									 AGSCodingArray:self.graphicsLayer.graphics];
				}
				
				// if we have graphics in our main schools layer, encode them to JSON
				if (self.schoolLayer.graphics.count > 0) {
					[JSONUtility encodeToDictionary:graphicsDict 
											withKey:@"school" 
									 AGSCodingArray:self.schoolLayer.graphics];
				}
				
				// add the graphics dictionary to the message dictionary
				[msg2 setValue:graphicsDict forKey:@"value"];
				
				// create string representation of the JSON
				NSString *jsonGraphicsStr = [msg2 JSONRepresentation];
				
				// get NSData to send
				NSData *graphicsData = [jsonGraphicsStr dataUsingEncoding:NSUTF8StringEncoding];
				
				success = [self.gkSession sendDataToAllPeers:[self compressData:graphicsData] 
												withDataMode:GKSendDataReliable 
													   error:&err];
			}
			break;
		case GKPeerStateDisconnected:
			[self endGKSession];
			break;
		case GKPeerStateAvailable:
			
			// a peer is available, let's connect
			[self.gkSession connectToPeer:peerID withTimeout:kConnectionTimeout];
			
			break;
		default:
			break;
	}
}

- (void)receiveData:(NSData *)data 
		   fromPeer:(NSString *)peer 
		  inSession:(GKSession *)session 
			context:(void *)context {

	// recreate the JSON string representation
	
	NSString *dataStr = [[[NSString alloc] initWithData:[self decompressData:data] 
											   encoding:NSUTF8StringEncoding] autorelease];
	
	// use the json-framework to recreate the JSON dictionary
	NSDictionary *json = [dataStr JSONValue];

	// see what type of message we just received
	
	NSString *type = [json valueForKey:@"type"];
	
	// if we received an "extent" message, we zoom to the extent
	
	if ([type isEqualToString:@"extent"]) {
		
		// set flag so we don't send the new extent 
		_extentChangedByCollaborator = YES;
		
		// grab json for envelope from the dictionary
		NSDictionary *envJson = [json valueForKey:@"value"];
		
		// create and zoom to new envelope
		
		AGSEnvelope *env = [[[AGSEnvelope alloc] initWithJSON:envJson] autorelease];
		
		[self.mapView zoomToEnvelope:env animated:YES];
	}
	else if ([type isEqualToString:@"graphics"]) {
		
		NSDictionary *graphicsJson = [json valueForKey:@"value"];
		
		NSDictionary *schools = [NSDictionary safeGetObjectFromDictionary:graphicsJson 
																  withKey:@"school"];
		if (schools) {
			NSArray *graphicsArray = [JSONUtility decodeFromDictionary:graphicsJson 
															   withKey:@"school" 
															 fromClass:[AGSGraphic class]];
			for (AGSGraphic *g in graphicsArray) {
				g.infoTemplateDelegate = self;
				[self.schoolLayer addGraphic:g];
			}
			[self.schoolLayer dataChanged];
		}
		
		NSDictionary *gLayer = [NSDictionary safeGetObjectFromDictionary:graphicsJson 
																 withKey:@"gl"];
		if (gLayer) {
			NSArray *graphicsArray = [JSONUtility decodeFromDictionary:graphicsJson 
															   withKey:@"gl" 
															 fromClass:[AGSGraphic class]];
			for (AGSGraphic *g in graphicsArray) {
				g.infoTemplateDelegate = self;
				[self.graphicsLayer addGraphic:g];
			}
			[self.graphicsLayer dataChanged];
		}
		
		NSDictionary *mLayer = [NSDictionary safeGetObjectFromDictionary:graphicsJson 
																 withKey:@"madden"];
		if (mLayer) {
			NSArray *graphicsArray = [JSONUtility decodeFromDictionary:graphicsJson 
															   withKey:@"madden" 
															 fromClass:[AGSGraphic class]];
			for (AGSGraphic *g in graphicsArray) {
				[self.maddenGL addGraphic:g];
			}
			[self.maddenGL dataChanged];
		}
	}
}

- (void)endGKSession {
	[self.gkSession disconnectFromAllPeers];
	self.gkSession.available = NO;
	[self.gkSession setDataReceiveHandler:nil withContext:nil];
	self.gkSession.delegate = nil;
	self.gkSession = nil;
}



#endif

@end
