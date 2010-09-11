//
//  Slices.m
//  Puzzle
//
//  Created by Guy Van Overtveldt on 24/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Slices.h"

@interface Slices (slices)


@end

#pragma mark -
#pragma mark public instance methods

@implementation Slices

@synthesize _row;
@synthesize _col;
@synthesize _rowInGame;
@synthesize _colInGame;
@synthesize _theImage;


- (void) setStartImage:(CGImageRef) ref withRow:(int) row withCol:(int) col{
	_imageRef = ref;
	_row = _rowInGame = row;
	_col = _colInGame = col;
	_state = OK;
}

- (void) setInGameRowCol: (int) row withCol: (int) col{
	_rowInGame = row;
	_colInGame = col;
}

- (void) setState: (SliceState) state{
	_state = state;
}

- (SliceState) getState{
	return _state;
}

- (CGImageRef) getImage{
	return _imageRef;
}

- (int) getRow{
	return _row;
	
}
- (int) getCol{
	return _col;
}

- (void) dealloc{
	[_theImage release];
	[super dealloc];
}	

#pragma mark -
#pragma mark private instance methods


@end
