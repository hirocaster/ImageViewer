//
//  ImageViewerView.h
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewerView : UIView {
    
    UIImage *_image;
    
}

@property (retain,nonatomic) UIImage *image;


@end
