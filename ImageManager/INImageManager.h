//
//  INImageManager.h
//  ImageManager
//
//  Created by Riley Crebs on 10/28/15.
//  Copyright © 2015 Incravo. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface INImageManager : NSObject

+ (instancetype) sharedInstance;

/* @brief Lazy loads image.  First check cache.  If not in cache asynchronously
 * downloads image from url.
 * @param imageURL URL for image
 * @param completionBlock Block to call back once image is obtained.
 */
- (void)lazyLoadImageWithURL:(NSURL*)imageURL
                  completion:(void (^)(UIImage *image, BOOL fromCached))completionBlock;

/* @brief Clear cache on the ImageManager
 *
 */
- (void)clearCache;
@end
