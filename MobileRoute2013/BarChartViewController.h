//
//  BarCharViewController.h
//  Plenary1
//
//  Created by Eric Ito on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface BarChartViewController : UIViewController<CPTPlotDataSource, CPTBarPlotDelegate> {
	NSArray *_labels;
	NSArray *_labelValues;
	
	CPTXYGraph *_chart;
	CPTGraphHostingView *_hostingView;
}

@property (nonatomic, retain) CPTXYGraph *chart;
@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) NSArray *labels;
@property (nonatomic, retain) NSArray *labelValues;

- (id)initWithNibName:(NSString *)nibNameOrNil 
			   labels:(NSArray*)lbls 
			   values:(NSArray*)values;
@end
