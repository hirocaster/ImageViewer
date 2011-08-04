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

static const float kMaximumZoomScale = 2.0f;

@implementation ImageViewerViewController

@synthesize toolbar = _toolbar;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize fit = _fit;

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
    
    [self.imageView setImage:img];
    
    [self.imageView setNeedsDisplay];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [_toolbar release];
    [_scrollView release];
    [_imageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



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

-(CGSize)calcMinimumViewSize
{
    CGSize scrollViewSize = self.scrollView.frame.size;
    CGSize toolbarSize = self.toolbar.frame.size;
    return CGSizeMake(scrollViewSize.width, scrollViewSize.height - toolbarSize.height);
}

- (float)calcMinimumZoomScale
{
    UIImage *image = self.imageView.image;

    if (!image) {
        return 1.0f;
    }
    
    CGSize imageSize = image.size;
    CGSize minViewSize = [self calcMinimumViewSize];
    
    float scaleX = minViewSize.width / imageSize.width;
    float scaleY = minViewSize.height / imageSize.height;
    
    return (scaleX < scaleY ? scaleX : scaleY);
}

- (void)updateZoomScale
{
    float f = [self calcMinimumZoomScale];
    
    if (f > 1.0f) {
        f = 1.0f;
    }
    
    [self.scrollView setMaximumZoomScale:kMaximumZoomScale];
    [self.scrollView setMinimumZoomScale:f];
}

- (void)makeFit:(BOOL)isFit
{
    if (isFit) {
        self.scrollView.zoomScale = [self calcMinimumZoomScale];
        
        CGRect newFrame;
        newFrame.origin = CGPointMake(0, 0);
        newFrame.size = [self calcMinimumViewSize];
        
        [self.imageView setFrame:newFrame];
        
        [self.scrollView setContentSize:newFrame.size];
        
        UIViewAutoresizing newMask;
        newMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.imageView setAutoresizingMask:newMask];
    }
    else
    {
        UIViewAutoresizing newMask;
        newMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
        [self.imageView setAutoresizingMask:newMask];
    }
    
    [self setFit:isFit];
}

- (void)updateFrameWithScale:(float)scale
{
    if (scale == self.scrollView.minimumZoomScale) {
        [self makeFit:YES];
    }
    else
    {
        if (self.fit) {
            [self makeFit:NO];
        }
        
        UIImage *image = self.imageView.image;
        if (!image) {
            return;
        }
        
        CGSize imageSize = image.size;
        imageSize = CGSizeMake(round(imageSize.width * scale), round(imageSize.height * scale));
        
        CGSize minSize = [self calcMinimumViewSize];
        if (imageSize.width < minSize.width) {
            imageSize.width = minSize.width;
        }
        if (imageSize.height < minSize.height) {
            imageSize.height = minSize.height;
        }
        
        CGRect newFrame;
        newFrame.origin = CGPointMake(0, 0);
        newFrame.size = imageSize;
        
        [self.imageView setFrame:newFrame];
        [self.scrollView setContentSize:newFrame.size];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [super didRotateFromInterfaceOrientation:orientation];
    
    [self updateZoomScale];
    
    if (self.isFit) {
        [self makeFit:YES];
    }
    else
    {
        [self updateFrameWithScale:self.scrollView.zoomScale];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view 
                        atScale:(float)scale
{
    [self updateFrameWithScale:scale];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:kSampleImageFileName];
    [self.imageView setImage:image];
    
    [self updateZoomScale];
    
    UIBarButtonItem *btn = [self.toolbar.items objectAtIndex:0];
    [btn setTitle:NSLocalizedString(kOpen, @"")];
}

@end
