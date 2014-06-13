//
//  MaterialTypeVC.h
//  Plenary1
//
//  Created by Eric Ito on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MaterialTypeVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
//{
//	UITableView *_tableView;
//	NSArray *_materials;
//	NSString *_currentMaterial;
//	id _delegate;
//	SEL _didSelectMaterial;
//	SEL _didCancelSelectMaterial;
//}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *materials;
@property (nonatomic, retain) NSString *currentMaterial;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didSelectMaterial;
@property (nonatomic, assign) SEL didCancelSelectMaterial;

- (id)initWithNibName:(NSString *)nibNameOrNil material:(NSString*)material;

@end
