//
//  SlideOutView.h
//  Plenary1
//
//  Created by ryan3374 on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SlideOutView : UIView {
	UIView *_contentView;
	UIView *_inputView;
	UIButton *_slideButton;
	BOOL _expanded;
	CGSize _margin;
	CGFloat _inputWidth;
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *inputView;
@property (nonatomic, retain) UIButton *slideButton;
@property (nonatomic, assign) BOOL expanded;

@end
