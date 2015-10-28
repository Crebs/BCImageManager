//
//  ImageManagerTests.m
//  ImageManagerTests
//
//  Created by Riley Crebs on 10/28/15.
//  Copyright © 2015 Incravo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XCTAsyncTestCase.h"
#import "INImageManager.h"

@interface ImageManagerTests : XCTAsyncTestCase

@end

@implementation ImageManagerTests

- (void)setUp {
    [super setUp];
    [[INImageManager sharedInstance] clearCache];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLazyLoadImageWithURL_WithValidURLAndImageNotAlreadyCached_ShouldReturnImage {
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=CmRdAAAAclnpOlsh2T_TI-kFGXXS5OHlMpU3sW0nGmN1SH9oug5LGA0gkZzrBwBQJKstI57uwQ5Dsb2NFFZTBJJSab_8Kt9p6ghdUzdTc825ff_4GHQR_-CZ3fTo8ERxz_7rv-tCEhAotejH5diEVfcT1M-qYmUyGhQS8o7PORiz3eUoj48nKAFrBbt0mw&key=AIzaSyBmJBy7qBczekcmYIHVMM0vzPGh8zMJ6ZM"];
    [self prepare];
    [[INImageManager sharedInstance] lazyLoadImageWithURL:url completion:^(UIImage *image, BOOL fromCache) {
        XCTAssertNotNil(image);
        XCTAssertFalse(fromCache);
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    // Will wait for 20.0 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:20.0];
}

- (void)testLazyLoadImageWithURL_WithValidURLAndImageAlreadyCached_ShouldReturnImage {
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=CmRdAAAAclnpOlsh2T_TI-kFGXXS5OHlMpU3sW0nGmN1SH9oug5LGA0gkZzrBwBQJKstI57uwQ5Dsb2NFFZTBJJSab_8Kt9p6ghdUzdTc825ff_4GHQR_-CZ3fTo8ERxz_7rv-tCEhAotejH5diEVfcT1M-qYmUyGhQS8o7PORiz3eUoj48nKAFrBbt0mw&key=AIzaSyBmJBy7qBczekcmYIHVMM0vzPGh8zMJ6ZM"];
    [self prepare];
    [[INImageManager sharedInstance] lazyLoadImageWithURL:url
                                               completion:^(UIImage *image, BOOL fromCache) {
                                                   XCTAssertNotNil(image);
                                                   XCTAssertFalse(fromCache);
                                                   [[INImageManager sharedInstance] lazyLoadImageWithURL:url
                                                                                              completion:^(UIImage *image, BOOL fromCache) {
                                                                                                  XCTAssertNotNil(image);
                                                                                                  // Should be cached
                                                                                                  XCTAssertTrue(fromCache);
                                                                                                  [self notify:kXCTUnitWaitStatusSuccess];
                                                                                              }];
                                               }];
    // Will wait for 20.0 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:20.0];
}


- (void)testLazyLoadImageWithURL_WithGarbageURLAndImageNotAlreadyCached_ShouldReturnNilImageNotFromCache {
    NSURL *url = [NSURL URLWithString:@"https://garbage.com/some/garbagehere"];
    [self prepare];
    [[INImageManager sharedInstance] lazyLoadImageWithURL:url completion:^(UIImage *image, BOOL fromCache) {
        XCTAssertNil(image);
        XCTAssertFalse(fromCache);
        [self notify:kXCTUnitWaitStatusSuccess];
    }];
    
    // Will wait for 20.0 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:20.0];
}

@end
