//
//  SecondViewController.h
//  Puzzle
//
//  Created by Guy Van Overtveldt on 22/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController <UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
	UIPopoverController * popup;
	IBOutlet UIImageView * source;
	UIImagePickerController * _picker;
	UIPopoverController *pop;
	IBOutlet UITextField * _grids;
}

@property (nonatomic,retain) IBOutlet UIImageView * source;
@property (nonatomic,retain) IBOutlet UITextField * _grids;

-(IBAction) press :(id)sender;
-(IBAction) editGrid :(id)sender;

+(UIImage *) getImage;
+(int) getGrids;

@end
