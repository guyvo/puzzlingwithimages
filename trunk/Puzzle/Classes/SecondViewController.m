//
//  SecondViewController.m
//  Puzzle
//
//  Created by Guy Van Overtveldt on 22/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SecondViewController.h"
#import "PopOverTest.h"


@implementation SecondViewController

UIImageView * pic;
int grids;

@synthesize source;
@synthesize _grids;

- (IBAction)press:(id)sender {
	
	_picker = [[UIImagePickerController alloc]init];
	_picker.delegate = self;
	_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	PopOverTest *switchV = [[PopOverTest alloc] init];
	pop = [[UIPopoverController alloc] initWithContentViewController:_picker];
	pop.delegate = self;
	[pop setPopoverContentSize:CGSizeMake(200,200) animated:YES];
	CGRect rect = CGRectMake(0,0,1,1);
	[pop presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

	[switchV release];
}

+(UIImage *) getImage{
	return [pic image];
}

+(int) getGrids{
	return grids;
}

-(IBAction) editGrid :(id)sender{
	grids = [_grids.text intValue];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	if ( pic != nil ) [pic release];
	
	pic = [[UIImageView alloc] initWithImage:image];
	source.image = pic.image;
	
	[pop dismissPopoverAnimated:YES];
	[pop autorelease];
	[_picker autorelease];
	//source = pic;
	//[self.view addSubview:source];
	//pic.center = CGPointMake(384,512);
	//pic.bounds = CGRectMake(0,100,500,500);
}

- (void)viewDidLoad {
	pic = [[UIImageView alloc] initWithImage:source.image];
	grids = [_grids.text intValue];
    [super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[source dealloc];
	[_grids dealloc];
    [super dealloc];
}

@end
