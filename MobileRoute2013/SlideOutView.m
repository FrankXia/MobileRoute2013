//
//  SlideOutView.m
//  Plenary1
//
//  Created by ryan3374 on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SlideOutView.h"


@implementation SlideOutView

@synthesize contentView = _contentView;
@synthesize inputView = _inputView;
@synthesize slideButton = _slideButton;
@synthesize expanded = _expanded;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_expanded = NO;
		
		_margin = CGSizeMake(17, 17);
		
		self.backgroundColor = [UIColor clearColor];
		
		// slide button
		//self.slideButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		self.slideButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.slideButton.frame = CGRectMake(0, 0, 30, 30);
		[self.slideButton setImage:[UIImage imageNamed:@"GreenRightArrow.png"] forState:UIControlStateNormal];

		[self.slideButton addTarget:self action:@selector(slideButtonTapped) forControlEvents:UIControlEventTouchUpInside];
		self.slideButton.center = CGPointMake(self.slideButton.frame.size.width/2, self.frame.size.height/2);
		self.slideButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		
		// main view
		CGRect f = CGRectMake(frame.origin.x, frame.origin.y, self.slideButton.frame.size.width, frame.size.height);
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		self.frame = f;
		
		// contentView
		CGRect fcv = CGRectMake(0, 0, self.slideButton.frame.size.width, self.frame.size.height);
		self.contentView = [[UIView alloc] initWithFrame:fcv];
		self.contentView.backgroundColor = [UIColor blackColor];
		self.contentView.alpha = .2;
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		// add subviews
		[self addSubview:self.contentView];
		[self addSubview:self.slideButton];
		
    }
    return self;
}

-(void)slideButtonTapped{
	self.expanded = !self.expanded;
}

-(void)setExpanded:(BOOL)expanded{
	/*if (_expanded == expanded){
		return;
	}*/
	_expanded = expanded;
	
	if (_expanded){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:.3];
		
		self.contentView.alpha = .5;
		self.frame = CGRectMake(self.frame.origin.x, 
								self.frame.origin.y,
								_inputWidth + (self.slideButton.frame.size.width/2) + (_margin.width*2),
								self.frame.size.height);
		self.contentView.frame = CGRectMake(0, 0, _inputWidth + (_margin.width*2), self.frame.size.height);
		_inputView.alpha = 1;
		self.slideButton.center = CGPointMake(self.frame.origin.x+self.frame.size.width-(self.slideButton.frame.size.width/2), 
								  self.frame.size.height/2);
		//self.slideButton.transform = CGAffineTransformMakeRotation(M_PI);
		_inputView.frame = CGRectMake(_margin.width, _margin.height, _inputWidth, self.inputView.frame.size.height);
		//self.inputView.transform = CGAffineTransformMakeTranslation(-(_inputWidth+_margin.width), 0);
		
		[UIView commitAnimations];
		self.slideButton.transform = CGAffineTransformMakeScale(-1, 1);
	}
	else {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:.3];
		
		self.contentView.alpha = .2;
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.slideButton.frame.size.width, self.frame.size.height);
		_inputView.alpha = 0;
		self.contentView.frame = CGRectMake(0, 0, self.slideButton.frame.size.width, self.frame.size.height);
		self.slideButton.center = CGPointMake(self.slideButton.frame.size.width/2, self.frame.size.height/2);
		//self.slideButton.transform = CGAffineTransformIdentity;
		//self.inputView.frame = CGRectMake(0, 0, 0, self.inputView.frame.size.height);
		_inputView.frame = CGRectMake(-(_inputWidth+_margin.width), _margin.height, _inputWidth, self.inputView.frame.size.height);
		
		//NSLog(@"f:    %@",NSStringFromCGRect(self.frame));
		//NSLog(@"cvf:  %@",NSStringFromCGRect(self.contentView.frame));
		
		_inputView.transform = CGAffineTransformMakeTranslation(-(_inputWidth+_margin.width), 0);
		
		[UIView commitAnimations];
		self.slideButton.transform = CGAffineTransformIdentity;
	}

}

-(void)setInputView:(UIView*)inputView{
	
	if (_inputView){
		[_inputView removeFromSuperview];
	}

	_inputView = inputView;
	
	_inputView.alpha = 0;
	_inputWidth = inputView.frame.size.width;
	float h = _inputView.frame.size.height;
	if (h == 0){
		h = self.frame.size.height - (_margin.height*2);
	}
	_inputView.frame = CGRectMake(_margin.width, _margin.height, _inputView.frame.size.width, h);
	[self insertSubview:_inputView atIndex:1]; // insert below button
	
	self.expanded = self.expanded;
}



@end
