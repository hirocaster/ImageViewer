//
//  ImageViewerView.m
//  ImageViewer
//
//  Created by Hiroki Ohtsuka on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewerView.h"


@implementation ImageViewerView

@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _image = nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _image = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *theImage = [self image];
    
    if (!theImage)
        return;
    
    CGSize imageSize = theImage.size;
    
    CGSize boundSize = self.bounds.size;
    
    CGRect dstRect;
    
    if (imageSize.width < boundSize.width && imageSize.height < boundSize.height)
    {
        dstRect.size = imageSize;
    }
    else
    {
        dstRect.size = imageSize;
        
        if ( imageSize.width > boundSize.width)
        {
            CGFloat h;
            h = round(boundSize.width / imageSize.width * imageSize.height);
            dstRect.size = CGSizeMake(boundSize.width, h);
        }
        
        if (dstRect.size.height > boundSize.height)
        {
            CGFloat w;
            w = round(boundSize.height / imageSize.height * imageSize.width);
            dstRect.size = CGSizeMake(w, boundSize.height);
        }
    }
    
    CGFloat x = round((boundSize.width - dstRect.size.width) / 2);
    CGFloat y = round((boundSize.height - dstRect.size.height) / 2);
    dstRect.origin = CGPointMake(x, y);
    
    [theImage drawInRect:dstRect];
}

- (void)setImage:(UIImage *)newImage
{
    if (newImage != _image)
    {
        [_image release];
        _image = nil;
    }
    
    if (newImage != nil)
    {
        CGSize imageSize = newImage.size;
        
        if ( newImage.size.width > 1024 || newImage.size.height > 1024)
        {
            CGSize newSize;
            
            if ( imageSize.width > imageSize.height)
            {
                newSize = CGSizeMake(1024, (int)imageSize.height * 1024 / imageSize.width);
            }
            else
            {
                newSize = CGSizeMake((int)imageSize.width * 1024 / imageSize.height, 1024);
            }
            
            UIGraphicsBeginImageContext(newSize);
            [newImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            _image = UIGraphicsGetImageFromCurrentImageContext();
            [_image retain];
            UIGraphicsEndImageContext();
        }
        else
        {
            _image = [newImage retain];
        }
    }
}

@end
