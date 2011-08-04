//
//  ImageViewerViewController.h
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewerView.h"

@class ImageViewerView;

@interface ImageViewerViewController : 
    UIViewController<UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationBarDelegate>
{
    
    UIToolbar *_toolbar;
    UIScrollView *_scrollView;
    ImageViewerView *_imageView;
    BOOL _fit;
}

@property (retain,nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain,nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain,nonatomic) IBOutlet ImageViewerView *imageView;
@property (getter = isFit) BOOL fit;

- (IBAction)openImage:(id)sender;

- (CGSize)calcMinimumViewSize;
- (float)calcMinimumZoomScale;
- (void)makeFit:(BOOL)isFit;
- (void)updateZoomScale;
- (void)updateFrameWithScale:(float)scale;

@end
