//
//  ImageViewerViewController.m
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewerViewController.h"
#import "ImageViewerView.h"

static NSString *kSampleImageFileName = @"SampleImage.jpg";
static NSString *kPhotoLibrary = @"PhotoLibrary";
static NSString *kCancel = @"Cancel";
static NSString *kOpen = @"Open";

@implementation ImageViewerViewController

@synthesize toolbar = _toolbar;

- (IBAction)openImage:(id)sender
{
    UIActionSheet *sheet;
    
    NSString *cancelStr = NSLocalizedString(kCancel, @"");
    NSString *photoLibraryStr = NSLocalizedString(kPhotoLibrary, @"");
    
    sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:cancelStr 
                          destructiveButtonTitle:nil 
                               otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [sheet addButtonWithTitle:photoLibraryStr];
    }
    
    [sheet showFromToolbar:[self toolbar]];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0)
    {
        UIImagePickerController *picker;
        picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.delegate = self;
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info  
{
    UIImage *img;
    img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [(ImageViewerView *)self.view setImage:img];
    
    [self.view setNeedsDisplay];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:kSampleImageFileName];
    [(ImageViewerView *)[self view] setImage:image];
    
    UIBarButtonItem *btn = [self.toolbar.items objectAtIndex:0];
    [btn setTitle:NSLocalizedString(kOpen, @"")];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

@end
