//
//  FirstViewController.h
//  Puzzle
//
//  Created by Guy Van Overtveldt on 22/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Slices;

@interface FirstViewController : UIViewController {
	NSMutableArray * _slices;
	UIToolbar * _toolbar;
}

@property (nonatomic,retain) NSMutableArray * _slices;
@property (nonatomic,retain) IBOutlet UIToolbar * _toolbar;

- (void) slicePieces:(UIImage *) theImage intoNumberOf: (int) pieces; 
- (void) drawSlice:(Slices *) slice withPieces:(int) pieces; 
- (void) setBlackHole: (int) row withCol:(int)col;
- (void) swapSlices;
- (void) redrawSlices;
- (Slices *) getSliceWithRowInGame:(int) row andColInGame:(int) col;
- (void) animateSlices: (UIImageView *) view;

@end
