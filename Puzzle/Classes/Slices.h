//
//  Slices.h
//  Puzzle
//
//  Created by Guy Van Overtveldt on 24/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum  { BLACKHOLE , INMOVE , MOVED, NOK , OK } SliceState;

@interface Slices : NSObject {
	CGImageRef _imageRef;
	UIImageView * _theImage;
	int _row;
	int _col;
	int _rowInGame;
	int _colInGame;
	SliceState _state;
}

@property (nonatomic,retain) UIImageView * _theImage;
@property int _row;
@property int _col;
@property int _rowInGame;
@property int _colInGame;


- (void) setStartImage:(CGImageRef) ref withRow:(int) row withCol:(int) col;
- (void) setInGameRowCol: (int) row withCol: (int) col;


- (CGImageRef) getImage;
- (int) getRow;
- (int) getCol;
- (void) setState: (SliceState) state;
- (SliceState) getState;

@end
