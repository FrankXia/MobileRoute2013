//
//  RulerView.m
//  Plenary1
//
//  Created by Ryan Olson on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RulerView.h"
#import "Plenary1ViewController.h"

@implementation RulerView
@synthesize mapView;// = _mapView;
@synthesize label;// = _label;
@synthesize pvc;// = _pvc;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		//self.label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)]autorelease];
		//self.label.textAlignment = UITextAlignmentCenter;
		//self.label.textColor = [UIColor redColor];
		//self.label.backgroundColor = [UIColor clearColor];
		//[self addSubview:self.label];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	NSSet *totalTouches = [event touchesForView:self];
	
	if (totalTouches.count == 2){
		NSArray *touchArr = [totalTouches allObjects];
		UITouch *t1 = (UITouch *)[touchArr objectAtIndex:0];
		UITouch *t2 = (UITouch *)[touchArr objectAtIndex:1];
		_p1 = [t1 locationInView:self];
		_p2 = [t2 locationInView:self];
		self.label.hidden = NO;
	}
	
	[self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	NSSet *totalTouches = [event allTouches];
	
	if (totalTouches.count == 2){
		NSArray *touchArr = [totalTouches allObjects];
		UITouch *t1 = (UITouch *)[touchArr objectAtIndex:0];
		UITouch *t2 = (UITouch *)[touchArr objectAtIndex:1];
		_p1 = [t1 locationInView:self];
		_p2 = [t2 locationInView:self];
		
		//self.label.text = [NSString stringWithFormat:@"%f,%f  %f,%f",_p1.x, _p1.y, _p2.x, _p2.y];
		AGSMutablePolyline *pline = [[AGSMutablePolyline alloc]initWithSpatialReference:[AGSSpatialReference webMercatorSpatialReference]];
		[pline addPathToPolyline];
		[pline addPointToPath:[self.mapView toMapPoint:_p1]];
		[pline addPointToPath:[self.mapView toMapPoint:_p2]];
		double dist = [[AGSGeometryEngine defaultGeometryEngine] geodesicLengthOfGeometry:pline inUnit:AGSSRUnitMeter];
		
		//self.label.text = [NSString stringWithFormat:@"%.0f Meters", dist];
		//self.label.center = CGPointMake((_p1.x + _p2.x) / 2, (_p2.y + _p2.y + 60) / 2);
		//self.label.hidden = NO;
		 
		// convert meters to miles if greater than 1609.344 m
		if (dist > 1609.344) {
			[self.pvc updateStatus:[NSString stringWithFormat:@"%.3f Miles", AGSUnitsToUnits(dist, AGSUnitsMeters, AGSUnitsMiles)] showActivity:NO];
		}
		else {
			[self.pvc updateStatus:[NSString stringWithFormat:@"%.0f Meters", dist] showActivity:NO];
		}
	}
	
	[self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	/*
	NSSet *tfv = [event touchesForView:self];
	NSLog(@"tfv: %d",tfv.count);
	
	NSSet *totalTouches = [event allTouches];
	
	if (totalTouches.count != 2)*/
	{
		_p1 = CGPointZero;
		_p2 = CGPointZero;
		//self.label.hidden = YES;
		[self.pvc updateStatusToEmpty];
	}
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	if (CGPointEqualToPoint(_p1, CGPointZero) ||
		CGPointEqualToPoint(_p2, CGPointZero)){
		return;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, _p1.x, _p1.y);
	CGPathAddLineToPoint(path, NULL, _p2.x, _p2.y);
	CGContextAddPath(context, path);
	
	CGContextSetLineWidth(context, 8);
	CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 5);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	CGContextRestoreGState(context);
}



@end
