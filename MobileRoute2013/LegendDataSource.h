//
//  LegendDataSource.h
//  Plenary1
//
//  Created by Danny Hatcher on 9/22/11.
//  Copyright 2011 Esri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface LegendDataSource : NSObject<UITableViewDataSource, AGSMapServiceInfoDelegate>


@property (nonatomic, retain) UITableView *legendTableView;

- (id) init;
- (void) reload;
- (void) addLegendForLayer:(AGSLayer*)layer;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView ;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath ;

@property (nonatomic, retain) NSMutableArray* legendInfos;

@end

@interface LegendInfo : NSObject {
@protected
    NSString *_name;
    UIImage *_image;
	NSString *_detail;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *detail;
@property (readwrite,retain) UIImage *image;

@end
