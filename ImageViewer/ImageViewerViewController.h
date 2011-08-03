//
//  ImageViewerViewController.h
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerViewController : 
    UIViewController<UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationBarDelegate>
{
    
    UIToolbar *_toolbar;
}

@property (retain,nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)openImage:(id)sender;

@end
