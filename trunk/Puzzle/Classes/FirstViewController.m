//
//  FirstViewController.m
//  Puzzle
//
//  Created by Guy Van Overtveldt on 22/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "Slices.h"
#import <math.h>


@implementation FirstViewController

@synthesize _slices;
@synthesize _toolbar;

int gAmountOfRows=3;
int widthImage=0;
int heigthImage=0;

- (void) drawSlice:(Slices *) slice withPieces:(int) pieces {
	int widthScreen,heigthScreen;
	
	// calculate the screen bounds
	UIScreen * screen = [UIScreen mainScreen];
	
	// get the image measurments
	int toolBarHeigth = _toolbar.bounds.size.height;
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
		widthScreen = screen.applicationFrame.size.width;
		heigthScreen = screen.applicationFrame.size.height - toolBarHeigth - 50; 
	}
	else{
		widthScreen = screen.applicationFrame.size.height;
		heigthScreen = screen.applicationFrame.size.width - toolBarHeigth - 50; 
	}
	int pieceWidth = (widthScreen/pieces);
	int pieceHeigth = (heigthScreen/pieces);
	
	[slice._theImage setCenter:CGPointMake( (slice._colInGame * pieceWidth)+ (pieceWidth / 2),toolBarHeigth + (slice._rowInGame * pieceHeigth) + (pieceHeigth / 2) )];
	
	if ( [slice getState] == BLACKHOLE )
		[slice._theImage setAlpha:0];
	else if ( [slice getState] == MOVED ){
		[slice._theImage setAlpha:1];
		[slice setState:OK];
	}
	
}

- (void) animateSlices: (UIImageView *) view{

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatCount:2];
	[UIView setAnimationRepeatAutoreverses:YES];
	view.transform = CGAffineTransformMakeScale(0.1,0.1);
	[UIView commitAnimations];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatCount:2];
	[UIView setAnimationRepeatAutoreverses:YES];
	view.transform = CGAffineTransformMakeScale(1.0,1.0);
	[UIView commitAnimations];
}


- (void) setBlackHole: (int) row withCol: (int) col{
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;
	
	
	while ( (slice = [iterator nextObject] ) ){
		if ( (slice._rowInGame == row) && (slice._colInGame == col) ){
			[slice._theImage setAlpha:0];
			[slice setState:BLACKHOLE];
		}
	}
}

- (Slices *) getSliceWithRowInGame:(int) row andColInGame:(int) col{
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;
	
	
	while ( (slice = [iterator nextObject] ) ){
		if ( (slice._rowInGame == row) && (slice._colInGame == col) ){
			return slice;
		}
	}
	
	return nil;
}


- (void) swapSlices{
	NSEnumerator * iterator = [_slices objectEnumerator];
	
	Slices * slice;
	Slices * blackhole = nil;
	Slices * inmove = nil;
	int row,col;

	while ( (slice = [iterator nextObject] ) ){
		if ( [slice getState] == INMOVE ){
			inmove = slice;
		}
		else if ( [slice getState] == BLACKHOLE ){
			blackhole = slice;
		}
	}
	
	if ( (inmove != nil) && (blackhole != nil)){
		[inmove setState:MOVED];
		[blackhole setState:BLACKHOLE];
		row = blackhole._rowInGame;
		col = blackhole._colInGame;
		blackhole._rowInGame = inmove._rowInGame;
		blackhole._colInGame = inmove._colInGame;
		inmove._rowInGame = row;
		inmove._colInGame = col;
		[self drawSlice:blackhole withPieces:gAmountOfRows];
		[self drawSlice:inmove withPieces:gAmountOfRows];
	}
}


- (void) slicePieces:(UIImage *) theImage intoNumberOf: (int) pieces{
	
	int x=0,y=0,row=0,col=0;
	int widthScreen,heigthScreen,offset;
	
	// get the image measurments
	widthImage = theImage.size.width;
	heigthImage = theImage.size.height;
	int sliceWidth = (widthImage/pieces);
	int sliceHeigth = (heigthImage/pieces);
	
	// calculate the screen bounds
	UIScreen * screen = [UIScreen mainScreen];
	
	// get the image measurments
	int toolBarHeigth = _toolbar.bounds.size.height;

	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
		widthScreen = screen.applicationFrame.size.height;
		heigthScreen = screen.applicationFrame.size.width - toolBarHeigth - 50; 
		offset = toolBarHeigth;
	}
	else{	
		widthScreen = screen.applicationFrame.size.width;
		heigthScreen = screen.applicationFrame.size.height - toolBarHeigth - 50; 
		offset = toolBarHeigth;
	}
	
	int pieceWidth = (widthScreen/pieces);
	int pieceHeigth = (heigthScreen/pieces);
	
	// prepare the rect
	CGRect pane;
	pane.size.width = pieceWidth;
	pane.size.height = pieceHeigth;
	pane.origin.x = 0;
	pane.origin.y = 0;	
	
	// tranform original into ref
	CGImageRef originalImage = [theImage CGImage];
	
	// temporary slice ref
	CGImageRef slice;
	
	// slice object refernce
	Slices * thePiece;
	
	// storage in array
	_slices = [[NSMutableArray arrayWithCapacity:pieces*pieces] retain];
	
	for (x=0 , col=0 ; col < pieces ; x = x + sliceWidth , col++){
		for (y=0 , row=0 ; row < pieces ; y = y + sliceHeigth , row++){
			slice = CGImageCreateWithImageInRect(originalImage, CGRectMake(x ,y ,sliceWidth ,sliceHeigth));
			thePiece = [[Slices alloc]init];
			[thePiece setStartImage:slice withRow:row withCol:col];
			thePiece._theImage = [[UIImageView alloc] initWithImage :[UIImage imageWithCGImage:slice]];
			[thePiece._theImage setContentMode:UIViewContentModeScaleToFill];
			[thePiece._theImage setFrame: pane];
			[thePiece._theImage setBounds: pane];
			[thePiece._theImage.layer setBorderColor:[[UIColor redColor] CGColor]];
			[thePiece._theImage.layer setBorderWidth:1.0];
			[thePiece._theImage setCenter:CGPointMake( (col * pieceWidth)+ (pieceWidth / 2), offset + (row * pieceHeigth) + (pieceHeigth / 2) )];
			
			[_slices addObject:thePiece];
			CGImageRelease(slice);
			[thePiece release];
		}
	}
	
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * s;
	while ( (s = [iterator nextObject] ) ){
		[self animateSlices:s._theImage];
	}
}

- (void) redrawSlices{
	
	int x=0,y=0,row=0,col=0;
	int widthScreen,heigthScreen;
	
	// calculate the screen bounds
	UIScreen * screen = [UIScreen mainScreen];
	
	// get the image measurments
	int toolBarHeigth = _toolbar.bounds.size.height;
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
		widthScreen = screen.applicationFrame.size.height;
		heigthScreen = screen.applicationFrame.size.width - toolBarHeigth - 50; 
	}
	else{	
		widthScreen = screen.applicationFrame.size.width;
		heigthScreen = screen.applicationFrame.size.height - toolBarHeigth - 50; 
	}
	
	int pieceWidth = (widthScreen/gAmountOfRows);
	int pieceHeigth = (heigthScreen/gAmountOfRows);

	int sliceWidth = (widthImage/gAmountOfRows);
	int sliceHeigth = (heigthImage/gAmountOfRows);

	// prepare the rect
	CGRect pane;
	pane.size.width = pieceWidth;
	pane.size.height = pieceHeigth;
	pane.origin.x = 0;
	pane.origin.y = 0;
	
	for (x = 0 , col=0 ; x < widthImage - 1  ; x = x + sliceWidth , col++){
		for (y = 0 , row=0 ; y < heigthImage - 1 ; y = y + sliceHeigth , row++){
			Slices * thePiece = [self getSliceWithRowInGame:row andColInGame:col];
			[thePiece._theImage setFrame: pane];
			[thePiece._theImage setBounds: pane];
			[thePiece._theImage.layer setBorderColor:[[UIColor redColor] CGColor]];
			[thePiece._theImage.layer setBorderWidth:1.0];
			[thePiece._theImage setCenter:CGPointMake( (col * pieceWidth)+ (pieceWidth / 2), toolBarHeigth + (row * pieceHeigth) + (pieceHeigth / 2) )];			
		}
	}
}

- (void)viewDidLoad {
	
	
	[super viewDidLoad];

}
-(void)motionEnded :(UIEventSubtype)motion withEvent:(UIEvent *)event{
	if (event.subtype == UIEventSubtypeMotionShake)
		[self setBlackHole: 0 withCol: 0];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;
	
	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:[self view]];
		while ( (slice = [iterator nextObject] ) ){
			if ( CGRectContainsPoint( [slice._theImage frame] , point )){
				if ( [slice getState] != BLACKHOLE ){
					[slice._theImage setAlpha:0.5];
					[slice setState:INMOVE];
				}
			}
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;
	
	for (UITouch * touch in touches){
		CGPoint point = [touch locationInView:[self view]];
		while ( (slice = [iterator nextObject] ) ){
			if ( CGRectContainsPoint( [slice._theImage frame] , point )){
				if ( [slice getState] == BLACKHOLE ){
					[self swapSlices];
					return;
				}
			}
		}
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;

	while ( (slice = [iterator nextObject] ) ){
		if ( [slice getState] == INMOVE ){
			[slice._theImage setAlpha:1];
			[slice setState:OK];
			//return;
		}			
	}	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(BOOL) canBecomeFirstResponder{
	return YES;
}
- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
	
	
	if (_slices != nil ){
		
		
		NSEnumerator * iterator = [_slices objectEnumerator];
		Slices * slice;
		
		while ( (slice = [iterator nextObject] ) ){
			[slice._theImage removeFromSuperview];
			[slice._theImage release];
			
		}
		
		[_slices release];
	
	}
	
	gAmountOfRows = [SecondViewController getGrids];
	
	[self slicePieces:[SecondViewController getImage] intoNumberOf:gAmountOfRows];
	
	NSEnumerator * iterator = [_slices objectEnumerator];
	Slices * slice;
	
	while ( (slice = [iterator nextObject] ) ){
		[self.view addSubview: slice._theImage]; 
	}
	
	[self setBlackHole: 1 withCol: 2];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[self redrawSlices];	
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_toolbar release];
	[_slices release];
    [super dealloc];
}

@end
