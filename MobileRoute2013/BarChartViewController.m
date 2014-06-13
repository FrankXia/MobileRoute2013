//
//  BarCharViewController.m
//  Plenary1
//
//  Created by Eric Ito on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarChartViewController.h"
#import "CorePlot-CocoaTouch.h"


@interface BarChartViewController ()
-(NSRange)dataRange;
@end

@implementation BarChartViewController

@synthesize chart = _chart;
@synthesize hostingView = _hostingView;
@synthesize labels = _labels;
@synthesize labelValues = _labelValues;

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

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   labels:(NSArray*)lbls 
			   values:(NSArray*)values {
	if (self = [self initWithNibName:nibNameOrNil bundle:nil]) {
		self.labels = lbls;
		self.labelValues = values;
	}
	return self;
}

//- (void)awakeFromNib {
//	
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// do this in init method
//	self.labels = [NSMutableArray array];
//	[self.labels addObject:@"< 5"];
//	[self.labels addObject:@"5 - 17"];
//	[self.labels addObject:@"18 - 21"];
//	[self.labels addObject:@"22 - 29"];
//	[self.labels addObject:@"30 - 39"];
//	[self.labels addObject:@"40 - 49"];
//	[self.labels addObject:@"50 - 64"];
//	[self.labels addObject:@"65 & Up"];
//	self.labelValues = [NSMutableArray array];
//	[self.labelValues addObject:[NSNumber numberWithInt:20]];
//	[self.labelValues addObject:[NSNumber numberWithInt:25]];
//	[self.labelValues addObject:[NSNumber numberWithInt:60]];
//	[self.labelValues addObject:[NSNumber numberWithInt:25]];
//	[self.labelValues addObject:[NSNumber numberWithInt:40]];
//	[self.labelValues addObject:[NSNumber numberWithInt:100]];
//	[self.labelValues addObject:[NSNumber numberWithInt:60]];
//	[self.labelValues addObject:[NSNumber numberWithInt:30]];
	
	// create the chart
	self.chart = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
	self.chart.paddingLeft = 5.0f;
	self.chart.paddingRight = 0.0f;
	self.chart.paddingTop = 15.0f;
	self.chart.paddingBottom = 0.0f;
	
	self.hostingView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 310, 300)];
	self.hostingView.hostedGraph = self.chart;
    
	self.hostingView.layer.borderColor = [UIColor grayColor].CGColor;
	self.hostingView.layer.borderWidth = 1.0;
	
	self.view.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.hostingView];
	
	float length = (float)self.labels.count;
	
	NSRange barDataRange = [self dataRange];
	
	// default white text style
	CPTMutableTextStyle *mts = [[CPTMutableTextStyle alloc] init];
	mts.color = [CPTColor whiteColor];
	
	// Configure Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.chart.axisSet;
	
	CPTXYAxis *xAxis = axisSet.xAxis;
	xAxis.axisLineStyle = nil;
	xAxis.majorTickLineStyle = nil;
	xAxis.minorTickLineStyle = nil;
	xAxis.majorIntervalLength =  CPTDecimalFromFloat(ceil((double)barDataRange.length/2));
	xAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
//	xAxis.title = @"Age";
	xAxis.titleLocation = CPTDecimalFromFloat(7.5f);
	xAxis.titleTextStyle = mts;
	xAxis.labelTextStyle = mts;
	
	CPTXYAxis *yAxis = axisSet.yAxis;
	yAxis.axisLineStyle = nil;
	yAxis.majorTickLineStyle = nil;
	yAxis.minorTickLineStyle = nil;	
	yAxis.majorIntervalLength = CPTDecimalFromFloat(ceil((double)barDataRange.length/2));
	yAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	yAxis.titleTextStyle = mts;
	yAxis.labelTextStyle = mts;
	
	// create bar ploy
	CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor orangeColor]
											 horizontalBars:NO];
	barPlot.dataSource = self;
	barPlot.baseValue = CPTDecimalFromString(@"0");
	barPlot.barOffset = CPTDecimalFromFloat(0.5f); 
	barPlot.barCornerRadius = 3.0f;
	barPlot.delegate = self;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*)self.chart.defaultPlotSpace;

	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(barDataRange.location)
												   length:CPTDecimalFromFloat(barDataRange.length+1)];
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
												   length:CPTDecimalFromFloat(length)];
	
	self.chart.plotAreaFrame.paddingLeft = 50.0;
	self.chart.plotAreaFrame.paddingTop = 20.0;
	self.chart.plotAreaFrame.paddingRight = 10.0;
	self.chart.plotAreaFrame.paddingBottom = 60.0;
	
	// labeling
	xAxis.labelRotation = M_PI/4;
	xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
	
	NSMutableArray *customTickLocations = [NSMutableArray arrayWithCapacity:self.labelValues.count];
	for (int i = 0; i < self.labels.count; i++) {
		[customTickLocations addObject:[NSDecimalNumber numberWithFloat:(0.5 + i)]];
	}
	
	// instantiate a new set of axis labels
	NSArray *xAxisLabels = self.labels;
	
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++]
														textStyle:xAxis.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = xAxis.labelOffset + xAxis.majorTickLength;
		newLabel.rotation = M_PI/4;
		[customLabels addObject:newLabel];
	}
	
	xAxis.axisLabels = [NSSet setWithArray:customLabels];
	
	CPTMutableTextStyle *titleMTS = [[CPTMutableTextStyle alloc] init];
	titleMTS.color = [CPTColor whiteColor];
	titleMTS.fontSize = 14.0;
	self.chart.title = [NSString stringWithFormat:@"Affected Population by Age"];
	self.chart.titleTextStyle = titleMTS;
	
	// add the plot to the chart
	[self.chart addPlot:barPlot toPlotSpace:plotSpace];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

#pragma mark -
#pragma mark CPPlotDataSource

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return self.labels.count;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot
					field:(NSUInteger)fieldEnum 
			  recordIndex:(NSUInteger)index {
	
	NSNumber *num = nil;
	
	switch (fieldEnum) {
		case CPTBarPlotFieldBarBase:
			break;
		case CPTBarPlotFieldBarTip:
			num = [self.labelValues objectAtIndex:index];
			break;
		case CPTBarPlotFieldBarLocation:
			num = [NSNumber numberWithInt:index];
			break;
		default:
			break;
	}
	
	return num;
}

-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//	CPTextLayer *label = [[[CPTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", index]] autorelease];
//	return label;
	return nil;
}

#pragma mark CPBarPlotDelegate

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
	// @todo, touch interaction
}

#pragma mark -
#pragma mark Misc

-(NSRange)dataRange {
	// min will ALWAYS be 0
	NSNumber *min = [NSNumber numberWithInt:0];
	NSNumber *max = [self.labelValues lastObject];
	
	for (NSNumber *n in self.labelValues) {
		float val = [n floatValue];
		max = val > [max floatValue] ? [NSNumber numberWithFloat:val] : max;
	}
	
	// don't optimize, taking advantage of integer division
	max = [NSNumber numberWithInt:(([max intValue]/1000) + 1) * 1000];
	
	return NSMakeRange([min intValue], [max intValue] - [min intValue]);
}
@end
