//
//  ImageViewerAppDelegate.h
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewerViewController;

@interface ImageViewerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ImageViewerViewController *viewController;

@end
