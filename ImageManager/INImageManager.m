//
//  INImageManager.m
//  ImageManager
//
//  Created by Riley Crebs on 10/28/15.
//  Copyright © 2015 Incravo. All rights reserved.
//

#import "INImageManager.h"

@interface INImageManager ()
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) dispatch_queue_t imageQueue;
@end

@implementation INImageManager

#pragma mark - Life Cycle Methods
+ (instancetype) sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageQueue = dispatch_queue_create("com.Incravo.lazyload", DISPATCH_QUEUE_SERIAL);
        _imageCache = [NSCache new];
    }
    return self;
}

#pragma mark - Image
- (void)lazyLoadImageWithURL:(NSURL*)imageURL
                  completion:(void (^)(UIImage *image))completionBlock {
    // If no completion block is passed in, no-op
    if (!completionBlock) {
        return;
    }
    
    UIImage *cachedImage = [self.imageQueue valueForKey:imageURL.absoluteString];
    if (cachedImage) {
        completionBlock(cachedImage);
    } else {
        dispatch_async(self.imageQueue, ^{
            NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                [self.imageCache setObject:image forKey:imageURL.absoluteString];
                completionBlock(image);
            });
        });
    }
}

- (void)clearCache {
    [self.imageCache removeAllObjects];
}
@end
